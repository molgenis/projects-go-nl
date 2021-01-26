#'////////////////////////////////////////////////////////////////////////////
#' FILE: molgenis_upload.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-06
#' MODIFIED: 2021-01-26
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

# upload data access agreement
m$file_upload(
    name = "GoNLDATA_ACCESS_POLICY_CONDITIONS_FINAL-2014.pdf",
    path = "src/www/docs/GoNLDATA_ACCESS_POLICY_CONDITIONS_FINAL-2014.pdf"
)

# upload acknowledgements doc
m$file_upload(
    name = "GoNL-Acknowledgements.docx",
    path = "src/www/docs/GoNL-Acknowledgements.docx"
)

# check status
m$file_info(id = "aaaac5wx7sgqv6qwh32jd7yaai") # Data Access Agreement
m$file_info(id = "aaaac5z7aijfr6qwh32jd7yaae") # GoNl-Acknowledgements

# end session
m$logout()
