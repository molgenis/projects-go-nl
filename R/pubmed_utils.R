#'////////////////////////////////////////////////////////////////////////////
#' FILE: pubmed_api.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-20
#' MODIFIED: 2021-02-16
#' PURPOSE: source publications list from pubmed
#' STATUS: working
#' PACKAGES: *see DESCRITPION*
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

# pubmed
# Methods for extacting pubmed data
pubmed <- list(class = "pubmed")

# get_ids
#
# In order to return publication metadata, you need to first retreive
# publication IDs. You can do this by building a query and using
# `get_ids`. Result is a character array.
pubmed$get_ids <- function(query) {

    response <- httr::GET(
        url = paste0(
            "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?",
            "db=pubmed",
            "&term=", utils::URLencode(query),
            "&retmode=json"
        ),
        httr::add_headers(
            `Content-Type` = "application/json"
        )
    )

    if (response$status_code == "200") {
        raw <- httr::content(response, "text", encoding = "UTF-8")
        raw %>%
            rjson::fromJSON(.) %>%
            `[[`("esearchresult") %>%
            `[[`("idlist")
    } else {
        stop(paste0("An error occurred: ", response$status_code))
    }
}

# get_metadata
#
# Using the list of publication IDs, you can now extract publication
# metadata. Pass the output of `get_ids`.
pubmed$get_metadata <- function(ids, delay = 0.5) {
    out <- data.frame()
    purrr::imap(ids, function(.x, .y) {
        response <- pubmed$make_request(.x)
        if (response$status_code == 200) {
            raw <- httr::content(response, as = "text", encoding = "UTF-8")
            result <- rjson::fromJSON(raw)
            df <- pubmed$clean_request(result)
            if (NROW(df) > 0) {
                cli::cli_alert_success("Returned data for pubID {.val {.x}}")
                if (.y == 1) {
                    out <<- df
                } else {
                    out <<- rbind(out, df)
                }
            } else {
                cli::cli_alert_success("No data for pubID {.val {.x}}")
            }
        } else {
            cli::cli_alert_danger("Query failed for {.val {.x}}")
        }
        Sys.sleep(delay)
    })
    return(out)
}


#' make_request
#'
#' Make a GET request for a single publication ID
#'
#' @param id a publication ID
#'
#' @noRd
pubmed$make_request <- function(id) {
    httr::GET(
        url = paste0(
            "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?",
            "db=pubmed",
            "&id=", id,
            "&retmode=json&"
        ),
        httr::add_headers(
            `Content-Type` = "application/json"
        )
    )
}

# clean_request
# Clean the result of `make_request`
pubmed$clean_request <- function(x) {
    id <- x[["result"]][["uids"]]
    data <- data.frame(
        uid = id,
        sortpubdate = x[["result"]][[id]][["sortpubdate"]],
        fulljournalname = x[["result"]][[id]][["fulljournalname"]],
        volume = x[["result"]][[id]][["volume"]],
        elocationId = x[["result"]][[id]][["elocationid"]],
        title = x[["result"]][[id]][["title"]]
    )
    data$authors <- paste0(
        sapply(
            x[["result"]][[id]][["authors"]],
            function(n) {
                n[["name"]]
            }
        ),
        collapse = "; "
    )
    return(data)
}

# build_df
# Compile results from `get_metadata` into a tidy object
pubmed$build_df <- function(data) {
    d <- data
    d$uid <- as.character(d$uid)
    d$sortpubdate <- as.Date(lubridate::ymd_hm(d$sortpubdate))
    d$doi_url <- stringr::str_replace_all(
        string = d$elocationId,
        pattern = "doi: ",
        replacement = "https://doi.org/"
    )
    d$doi_label <- stringr::str_replace_all(
        string = d$elocationId,
        pattern = "doi: ",
        replacement = ""
    )
    d$elocationId <- NULL
    d <- d[order(d$sortpubdate, decreasing = TRUE), ]
    d$sortpubdate <- as.character(d$sortpubdate)
    return(d)
}

#' build_html
#'
#' After results have been cleaned, generate the html markup
#'
#' @param x output from `build_pubs` function
#'
#' @export
pubmed$build_html <- function(x) {
    sapply(seq_len(NROW(x)), function(d) {
        as.character(
            htmltools::tags$li(
                class = "pub",
                `data-uid` = x[["uid"]][[d]],
                # `data-item` = x[["html_order"]][[d]],
                `data-pub-year` = x[["year"]][[d]],
                htmltools::tags$span(
                    class = "pub-data pub-title",
                    x[["title"]][[d]]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-journal",
                    x[["fulljournalname"]][[d]]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-year",
                    x[["sortpubdate"]][[d]]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-authors",
                    x[["authors"]][[d]]
                ),
                htmltools::tags$a(
                    class = "pub-data pub-doi",
                    href = x[["doi_url"]][[d]],
                    x[["doi_label"]][[d]]
                )
            )
        )}
    )
}

#' write_html
#'
#' Write html markup to file using comment anchors. Your output file must have
#' the following comments. Make sure you replace `yourId` with your own Ids.
#'
#' `<!--- startHtmlOuput: yourId -->`
#' `<!--- endHtmlOuput: youId -->`
#'
#' Place the comments anywhere in your html document. Please note that any
#' markup within these comments will be replaced.
#'
#' @param file path to html document to render content into
#' @param id id of the comment anchors
#' @param html object containing the html markup
#'
#' @export
pubmed$write_html <- function(file, id, html) {

    #' Read html to file
    input <- readLines(file, warn = FALSE)

    # find start and end points using `<!--- *HtmlOutput: ... ->`
    ids <- list()
    ids$start <- paste0("<!--- startHtmlOuput: ", id, " -->")
    ids$end <- paste0("<!--- endHtmlOuput: ", id, " -->")

    positions <- list()
    positions$start <- grep(ids$start, input)
    positions$end <- grep(ids$end, input)

    # insert new html content
    output <- c(
        input[1:positions$start],
        html,
        input[positions$end:length(input)]
    )

    # save new output
    write(output, file)
}


#' Prep Data for Import
#'
#' Serialize data for import into molgenis directly
#'
#' @param x an object
#'
#' @export
pubmed$as_molgenis_entity <- function(x) {
    jsonlite::toJSON(list(entities = x), dataframe = "row")
}