# ////////////////////////////////////////////////////////////////////////////
# FILE: index.sh
# AUTHOR: David Ruvolo
# CREATED: 2020-11-18
# MODIFIED: 2020-11-20
# PURPOSE: script for interacting with GONL Server
# DEPENDENCIES: mcmd (molgenis commander); RScript
# COMMENTS: https://go-nl-acc.gcc.rug.nl
# This script can be run at once, but it may be easier to use VSCode's
# integrated terminal. Make sure a keybinding exists for:
# `terminal run selected text in active terminal`. I recommend using
# "cmd + shift + enter"
# ////////////////////////////////////////////////////////////////////////////

# download data (waiting for access)
# https://molgenis26.gcc.rug.nl/downloads/gonl_public/variants/release5/

# //////////////////////////////////////

# ~ 1 ~
# Build EMX files

Rscript -e "source('R/emx_create_01_pkg.R')"
Rscript -e "source('R/emx_create_02_entities.R')"
Rscript -e "source('R/emx_create_03_attribs.R')"
Rscript -e "source('R/emx_create_04_static_content.R')"

# //////////////////////////////////////

# ~ 2 ~
# Get Content

# logo: download and optimize
curl "http://www.nlgenome.nl/wp-content/uploads/2016/08/copy-logo2.png" -o src/images/gonl_logo.png
open -a "ImageOptim" src/images/gonl_logo.png


# //////////////////////////////////////

# ~ 3 ~
# Push to Molgenis Server

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

# push source data
mcmd import -p ~/Downloads/gonl.chr22.snps_indels.r5.vcf --in gonl --as gonl_chr22

# push content
mcmd import -p data/sys_StaticContent.tsv
mcmd add logo -p src/images/gonl_logo.png