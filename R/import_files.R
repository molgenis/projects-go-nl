#'////////////////////////////////////////////////////////////////////////////
#' FILE: import_files.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-06
#' MODIFIED: 2021-01-06
#' PURPOSE: import files into molgenis db
#' STATUS: working
#' PACKAGES: NA
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

# pkgs
#' remotes::install_github("davidruvolo51/mcmdr")

# upload pdf
m <- mcmdr::molgenis$new()
m$config(host = "https://go-nl-acc.gcc.rug.nl")
m$login()


m$file_upload(
    name = "GoNLDATA_ACCESS_POLICY_CONDITIONS_FINAL-2014.pdf",
    path = "src/www/docs/GoNLDATA_ACCESS_POLICY_CONDITIONS_FINAL-2014.pdf"
)

m$logout()
