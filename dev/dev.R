#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-02-16
#' MODIFIED: 2021-06-14
#' PURPOSE: repo management
#' STATUS: working, on.going
#' PACKAGES: see below
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' init project
usethis::create_project(path = ".")
usethis::use_description(check_name = FALSE)
usethis::use_namespace()

#' set pkgs
usethis::use_package("dplyr", min_version = TRUE)
usethis::use_package("httr", min_version = TRUE)
usethis::use_package("cli", min_version = TRUE)
usethis::use_package("jsonlite", min_version = TRUE)
usethis::use_package("rjson", min_version = TRUE)
usethis::use_package("purrr", min_version = TRUE)
usethis::use_package("stringr", min_version = TRUE)
usethis::use_package("lubridate", min_version = TRUE)
usethis::use_package("readr", min_version = TRUE)
usethis::use_package("tibble", min_version = TRUE)
