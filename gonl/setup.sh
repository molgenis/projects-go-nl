# ////////////////////////////////////////////////////////////////////////////
# FILE: index.sh
# AUTHOR: David Ruvolo
# CREATED: 2020-11-18
# MODIFIED: 2021-02-19
# PURPOSE: script for interacting with GONL Server
# DEPENDENCIES: mcmd (molgenis commander); RScript
# COMMENTS: NA
# This script can be run at once, but it may be easier to use VSCode's
# integrated terminal. Make sure a keybinding exists for:
# `terminal run selected text in active terminal`. I recommend using
# "cmd + shift + enter"
# ////////////////////////////////////////////////////////////////////////////

# config `mcmd`
# pip3 install molgenis-commander               # install mcmd
# pip3 install --upgrade molgenis-commander     # upgrade mcmd
# mcmd --version              # test mcmd
# mcmd config add host        # initial time only
mcmd config set host
mcmd ping

# push EMX assets
mcmd import -p data/sys_md_Package.tsv
mcmd import -p data/gonl_attributes.tsv --as attributes --in gonl
mcmd import -p data/gonl_entities.tsv --as entities --in gonl


# import questionnaire and give permissions
mcmd import -p data/emx_data_access_requests.xlsx --in requests
# mcmd enable rls requests_dar

mcmd give anonymous view data-row-edit
mcmd give anonymous edit requests_dar
# mcmd make --role ANONYMOUS requests_EDITOR

# push content
mcmd import -p data/sys_StaticContent.tsv

# cheeky way of uploading multiple images (make sure logo is always last)
mcmd add logo -p src/images/bgi.png
mcmd add logo -p src/images/bmri.png
mcmd add logo -p src/images/eumc.png
mcmd add logo -p src/images/lumc.jpg
mcmd add logo -p src/images/nbic.png
mcmd add logo -p src/images/umcg.png
mcmd add logo -p src/images/umcu.png
mcmd add logo -p src/images/vumc.png
mcmd add logo -p src/images/website.png
mcmd add logo -p src/images/GoNL_DataSources_Flowchart_04.png
mcmd add logo -p src/images/gonl.png

# upload apps, add to menu, and then continue
# menu order: Home, About, News, Publications, Download, Browse, Request
# request is a redirect

mcmd give anonymous view sys_App
mcmd give anonymous view app-about
mcmd give anonymous view app-news
# mcmd give anonymous view app-publications
mcmd give anonymous view app-publist
mcmd give anonymous view app-download
mcmd give anonymous view app-browse
mcmd give anonymous view app-request

mcmd give anonymous view sys_FileMeta

# set permissions
mcmd make --role anonymous gonl_VIEWER
mcmd give anonymous view gonl

# upload publications dataset
mcmd import -p data/pubdata/sys_md_Package.csv
mcmd import -p data/pubdata/publications.xlsx
mcmd give anonymous view publications
