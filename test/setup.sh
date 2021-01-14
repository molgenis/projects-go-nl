mcmd -p test/sys_md_Package.tsv
mcmd -p yesno_attributes.tsv --as attributes --in requests
mcmd -p yesno_attributes.tsv --as requests_yesno --in requests
mcmd -p datasets_attributes.tsv --as attributes --in requests
mcmd -p datasets_attributes.tsv --as requests_datasets --in requests
mcmd -p dar_attributes.tsv --as attributes --in requests
