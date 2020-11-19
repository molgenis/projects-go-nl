# ////////////////////////////////////////////////////////////////////////////
# FILE: index.sh
# AUTHOR: David Ruvolo
# CREATED: 2020-11-18
# MODIFIED: 2020-11-18
# PURPOSE: script for interacting with GONL Server
# DEPENDENCIES: mcmd (molgenis commander); RScript
# COMMENTS: https://go-nl-acc.gcc.rug.nl
# This script can be run at once, but it may be easier to use VSCode's
# integrated terminal. Make sure a keybinding exists for:
# `terminal run selected text in active terminal`. I recommend using
# "cmd + shift + enter"
# ////////////////////////////////////////////////////////////////////////////

# ~ 0 ~
# init
# pip3 install molgenis-commander               # install mcmd
# pip3 install --upgrade molgenis-commander     # upgrade mcmd
# mcmd --version         # test mcmd

# mcmd config add host # initial time only
mcmd config set host

# download data (waiting for access)
# https://molgenis26.gcc.rug.nl/downloads/gonl_public/variants/release5/

# //////////////////////////////////////

# ~ 1 ~
# compile EMX package and entities
rm -rf data/gonl_*
Rscript -e "source('R/emx.R')"


# //////////////////////////////////////

# ~ 2 ~
# import package

mcmd import -p data/sys_md_Package.tsv

mcmd import -p data/gonl_attributes.tsv --as attributes --in gonl
mcmd import -p data/gonl_entities.tsv --as entities --in gonl
mcmd import -p ~/Downloads/gonl.chr22.snps_indels.r5.vcf --in gonl --as gonl_chr22

mcmd import -p data/sys_StaticContent.tsv
mcmd add logo -p images/gonl_logo.png