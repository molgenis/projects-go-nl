# ////////////////////////////////////////////////////////////////////////////
# FILE: rscript.sh
# AUTHOR: David Ruvolo
# CREATED: 2021-02-19
# MODIFIED: 2021-02-19
# PURPOSE: execute R scripts
# DEPENDENCIES: NA
# COMMENTS: NA
# ////////////////////////////////////////////////////////////////////////////

Rscript -e "source('R/emx_create_01_pkg.R')"
Rscript -e "source('R/emx_create_02_entities.R')"
Rscript -e "source('R/emx_create_03_attribs.R')"
Rscript -e "source('R/emx_create_04_static_content.R')"
Rscript -e "source('R/emx_create_05_request_pkg.R')"