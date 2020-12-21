# ////////////////////////////////////////////////////////////////////////////
# FILE: curl.sh
# AUTHOR: David Ruvolo
# CREATED: 2020-12-21
# MODIFIED: 2020-12-21
# PURPOSE: curl old html pages
# DEPENDENCIES: NA
# COMMENTS: NA
# ////////////////////////////////////////////////////////////////////////////

# home
curl http://www.nlgenome.nl -o src/pages/home.html
curl http://www.nlgenome.nl/?page_id=28 -o src/pages/about.html
curl http://www.nlgenome.nl/?page_id=160 -o src/pages/news.html
curl http://www.nlgenome.nl/?page_id=185 -o src/pages/publications.html
curl http://www.nlgenome.nl/?page_id=9 -o src/pages/download_data.html
curl http://www.nlgenome.nl/?page_id=114 -o src/pages/request_data.html
curl http://www.nlgenome.nl/?page_id=118 -o src/pages/browse_data.html
curl http://www.nlgenome.nl/?page_id=16 -o src/pages/wiki.html

# news posts
curl http://www.nlgenome.nl/?p=199 -o src/pages/news_2014_07_08.html
curl http://www.nlgenome.nl/?p=180 -o src/pages/news_2014_07_03.html
curl http://www.nlgenome.nl/?p=154 -o src/pages/news_2014_03_14.html
curl http://www.nlgenome.nl/?p=102 -o src/pages/news_2013_07_07.html
curl http://www.nlgenome.nl/?p=79 -o src/pages/news_2013_07_03.html
curl http://www.nlgenome.nl/?p=41 -o src/pages/news_2012_07_15.html