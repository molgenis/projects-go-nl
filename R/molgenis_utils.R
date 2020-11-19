#'////////////////////////////////////////////////////////////////////////////
#' FILE: molgenis_utils.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-11-18
#' MODIFIED: 2020-11-19
#' PURPOSE: login to molgenis server
#' STATUS: working
#' PACKAGES: RCurl; rjson
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' getMolgenisToken
#'
#' Retrieve token. Adapted from molgenis R api client
#'
#' @param url a molgenis host
#' @param username a valid username
#' @param password a valid password
#'
#' @noRd
get_molgenis_token <- function(url, username, password) {
    RCurl::postForm(
        uri = paste0(url, "/api/v1/login"),
        .opts = list(
            postfields = rjson::toJSON(
                list(
                    username = username,
                    password = password
                )
            ),
            httpheader = c(
                `Content-Type` = "application/json"
            )
        )
    ) %>%
    rjson::fromJSON(.) %>%
    .["token"]
}