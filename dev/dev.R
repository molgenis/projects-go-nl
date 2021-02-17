#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-02-16
#' MODIFIED: 2021-02-16
#' PURPOSE: repo management
#' STATUS: in.progress
#' PACKAGES: see below
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' init project
usethis::create_project(path = ".")
usethis::use_description(check_name = FALSE)
usethis::use_namespace()

#' set pkgs
usethis::use_package("dplyr")
usethis::use_package("httr")
usethis::use_package("cli")
usethis::use_package("jsonlite")
usethis::use_package("rjson")
usethis::use_package("purrr")
usethis::use_package("stringr")
usethis::use_package("lubridate")
usethis::use_package("readr")
usethis::use_package("tibble")
