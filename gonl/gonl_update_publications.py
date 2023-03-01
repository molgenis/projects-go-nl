# ////////////////////////////////////////////////////////////////////////////
# FILE: gonl_update_publications.py
# AUTHOR: David Ruvolo
# CREATED: 2022-03-01
# MODIFIED: 2022-03-01
# PURPOSE: Get updated publication list from PubMed
# STATUS: stable
# PACKAGES: molgenis.client, requests, json, datetime, time
# COMMENTS: NA
# ////////////////////////////////////////////////////////////////////////////

import molgenis.client as molgenis
from datetime import datetime
import requests
import time
import json

# for local dev only
# from dotenv import load_dotenv
# from os import environ
# load_dotenv()
# host = environ['GONL_HOST']
# token = environ['GONL_TOKEN']

host = 'http://localhost/api'
token = '${molgenisToken}'

def status_msg(*args):
  """Status Message
  Print a log-style message, e.g., "[16:50:12.245] Hello world!"

  @param *args one or more strings containing a message to print
  @return string
  """
  t = datetime.utcnow().strftime('%H:%M:%S.%f')[:-3]
  print('\033[94m[' + t + '] \033[0m' + ' '.join(map(str, args)))


class Molgenis(molgenis.Session):
  def __init__(self, *args, **kwargs):
    super(Molgenis, self).__init__(*args, **kwargs)
    self.__getApiUrl__()
  
  def __getApiUrl__(self):
    """Find API endpoint regardless of version"""
    props = list(self.__dict__.keys())
    if '_url' in props:
      self._apiUrl = self._url
    if '_api_url' in props:
      self._apiUrl = self._api_url
  
  def _checkResponseStatus(self, response, label):
    if (response.status_code // 100) != 2:
      err = response.json().get('errors')[0].get('message')
      status_msg(f'Failed to import data into {label} ({response.status_code}): {err}')
    else:
      status_msg(f'Imported data into {label}')
  
  def _POST(self, url: str = None, data: list = None, label: str = None):
    response = self._session.post(
      url=url,
      headers=self._headers.ct_token_header,
      data=json.dumps({'entities': data})
    )
    self._checkResponseStatus(response, label)
    response.raise_for_status()
  
  def importData(self, entity: str, data: list):
    """Import Data
    Import data into a table. The data must be a list of dictionaries that
    contains the 'idAttribute' and one or more attributes that you wish
    to import.

    @param entity (str) : name of the entity to import data into
    @param data (list) : data to import (a list of dictionaries)

    @return a status message
    """
    url = '{}v2/{}'.format(self._apiUrl, entity)
    if len(data) < 1000:
      self._POST(url=url, data=data, label=str(entity))

    # batch push
    if len(data) >= 1000:
      for d in range(0, len(data), 1000):
        self._POST(
          url=url,
          data=data[d:d+1000],
          label='{} (batch {})'.format(str(entity), str(d))
        )

class Pubmed:
  def __init__(self):
    self.session = requests.Session()
    self.endpoints = {
        'esearch': 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json',
        'esummary': 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&retmode=json'
    }
    self._headers = {'Content-Type': 'application/json'}

  def _GET(self, url):
    try:
      response = self.session.get(url=url, headers=self._headers)
      response.raise_for_status()
      if response.status_code // 100 == 2:
        data = response.json()
        return data
    except requests.exceptions.HTTPError as error:
        raise SystemError(error)

  def getPublicationsIds(self, query: str) -> dict:
    """Get Publications Identifiers
    Retrieve a list of publications identifiers from esearch that match
    a given search term.

    @param query a string containing terms specific to the publications
      that you would like to retrieve

    @return dictionary containing publication metadata
    """
    queryParameter = requests.utils.quote(query)
    url = f"{self.endpoints.get('esearch')}&term={queryParameter}"
    data = self._GET(url=url)
    if data.get('esearchresult', {}).get('idlist'):
      status_msg(
        'Returned',
        data.get('esearchresult', {}).get('count'),
        'identifiers'
      )
      return data.get('esearchresult', {}).get('idlist')
    else:
      status_msg(
        'Response was successful, but the required key "esearchresult.idlist" is missing',
        str(data)
      )

  def getPublicationMetadata(self, id: str) -> dict:
    """Get Publication Metadata
    Retrieve metadata of a specific publication

    @param id the unique pubmed identifier of a publication
    @return a dictionary containing 
    """
    url = f"{self.endpoints.get('esummary')}&id={id}"
    data = self._GET(url)
    if data.get('result',{}).get(id):
      return data.get('result',{}).get(id)
    else:
      raise SystemError('Response was successful, but required key "result" is missing.', str(data))

  def _formatDate(self, value: str) -> str:
    return datetime.strptime(value, '%Y/%m/%d %H:%M').strftime('%Y-%m-%d')

  def extractPublicationData(self, data: dict) -> dict:
    """Extract data elements
    Extract attributes of interest from the response of `getPublicationMetadata`

    @param data result of `getPublicationMetadata`
    @return dictionary containing formated publication metadata
    """
    doi = data['elocationid'].replace('doi: ', '') if data.get('elocationid') else None
    return {
      'uid': data.get('uid'),
      'sortpubdate': self._formatDate(data.get('sortpubdate')),
      'fulljournalname': data.get('fulljournalname'),
      'volume': data.get('volume'),
      'title': data.get('title'),
      'authors': '; '.join(author['name'] for author in data.get('authors')),
      'doi_url': f"https://doi.org/{doi}" if doi else None,
      'doi_label': doi if doi else None
    }

# //////////////////////////////////////////////////////////////////////////////

# ~ 1 ~
# Get publication data

# init connections
gonl = Molgenis(url=host, token=token)
pubmed = Pubmed()

# get all publication search terms
searchTerms = [row['query'] for row in gonl.get('publications_queries')]

# get list of excluded publications identifiers
excludedPublicationIds = [row['uid'] for row in gonl.get('publications_exclusions')]


# for each pubmed search term, get all of the matching publication identifiers
allPublicationIds = []
for term in searchTerms:
  print('Finding publications that match:', term)
  allPublicationIds.extend(pubmed.getPublicationsIds(query=term))
  time.sleep(0.5)

gonlPublicationIds = list(set(
  [id for id in allPublicationIds if id not in excludedPublicationIds]
))

# for all identifiers, retrieve publication metadata
publicationData = []
for id in gonlPublicationIds:
  print('Fetching data for publication:', id)
  data = pubmed.getPublicationMetadata(id=id)
  publicationData.append(pubmed.extractPublicationData(data))
  time.sleep(0.7)

# import of data exists
if publicationData:
  status_msg('Importing data into GoNL Publications')
  gonl.delete('publications_records')
  gonl.importData(entity='publications_records', data=publicationData)
else:
  status_msg('No publications found.')
