#'////////////////////////////////////////////////////////////////////////////
#' FILE: molgenis_file_upload.py
#' AUTHOR: David Ruvolo
#' CREATED: 2021-06-16
#' MODIFIED: 2021-06-16
#' PURPOSE: import file into a molgenis db
#' STATUS: in.progress
#' PACKAGES: molgenis.client
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

import os
import molgenis.client as molgenis
import requests
import mimetypes
import yaml

# load config
with open('python/_config.yml', 'r') as yml:
    config = yaml.safe_load(yml)

# extend Molgenis Class
class molgenis(molgenis.Session):
    def upload_file(self, name, path):
        filepath = os.path.abspath(path)
        url = self._url + 'files/'
        header = {
            'x-molgenis-token': self._token,
            'x-molgenis-filename': name,
            'Content-Length': str(os.path.getsize(filepath)),
            'Content-Type': str(mimetypes.guess_type(filepath)[0])
        }
        with open(filepath,'rb') as f:
            data = f.read()
        f.close()
        response = requests.post(url, headers=header, data=data)
        if response.status_code == 201:
            print(
                'Successfully imported file:\nFile Name: {}\nFile ID: {}'
                .format(
                    response.json()['id'],
                    response.json()['filename']
                )
            )
        else:
            response.raise_for_status()

# init session
gonl = molgenis(url=config['host'][config['env']], token=config['token'])

# upload file
gonl.upload_file(
    name='GoNLDATA_ACCESS_REQUEST_APPLICATION_v1.1.pdf',
    path='docs/GoNLDATA_ACCESS_REQUEST_APPLICATION_v1.1.pdf'
)