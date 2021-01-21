#'////////////////////////////////////////////////////////////////////////////
#' FILE: pubmed_api.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-20
#' MODIFIED: 2021-01-21
#' PURPOSE: source publications list from pubmed
#' STATUS: in.progress
#' PACKAGES: *see below*
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' pkgs
#' install.packages("dplyr")
#' install.packages("httr")
#' install.packages("rjson")
#' install.packages("cli")
#' install.packages("purrr")
#' install.packages("tibble")
#' install.packages("rlist")
#' install.packages("htmltools")

#' test packages
packageVersion("dplyr")
packageVersion("httr")
packageVersion("rjson")
packageVersion("cli")
packageVersion("purrr")
packageVersion("tibble")
packageVersion("rlist")
packageVersion("htmltools")

#' load pkgs for current script
suppressPackageStartupMessages(library(dplyr))

#' pubmed
#'
#' Methods for extacting pubmed data
#'
#' @export
pubmed <- list(class = "pubmed")

#' get_ids
#'
#' In order to return publication metadata, you need to first retreive
#' publication IDs. You can do this by building a query and using
#' `get_ids`. Result is a character array.
#'
#' @param query a search query to run
#'
#' @examples
#' q <- "\"Genome of the Netherlands consortium\"[Corporate Author]"
#' ids <- pubmed$get_ids(query = q)
#'
#' @return Get list of publication IDs
#'
#' @export
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
        m <- "An error occurred {.val {response$status_code}}"
        cli::cli_alert_danger(m)
        response
    }
}

#' get_metadata
#'
#' Using the list of publication IDs, you can now extract publication
#' metadata. Pass the output of `get_ids`.
#'
#' @param ids a character array containing a list of IDs (output from get_ids)
#'
#' @examples
#'
#' @export
pubmed$get_metadata <- function(ids, delay = 0.5) {
    out <- NA
    purrr::imap(ids, function(.x, .y) {
        response <- pubmed$make_request(.x)
        if (response$status_code == 200) {
            raw <- httr::content(response, as = "text", encoding = "UTF-8")
            result <- rjson::fromJSON(raw)
            df <- pubmed$clean_request(result)
            if (NROW(df) > 0) {
                cli::cli_alert_success("Returned data for id: {.val {.x}}")
                if (is.na(out)) {
                    out <<- df
                } else {
                    out <<- rbind(out, df)
                }
            } else {
                cli::cli_alert_warning("Nothing returned for id: {.val {.x}}")
                response
            }
        } else {
            m <- "An error occurred {.val {response$status_code}}"
            cli::cli_alert_danger(m)
            response
        }

        Sys.sleep(delay)
    })
    tibble::as_tibble(out)
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

#' clean_request
#'
#' Clean the result of `make_request`
#'
#' @param x a result from `make_request`
#'
#' @export
pubmed$clean_request <- function(x) {
    id <- x[["result"]][["uids"]]
    df <- data.frame(
        uid = id,
        date = x[["result"]][[id]][["pubdate"]],
        journal = x[["result"]][[id]][["fulljournalname"]],
        volume = x[["result"]][[id]][["volume"]],
        issue = x[["result"]][[id]][["issue"]],
        elocationId = x[["result"]][[id]][["elocationid"]],
        title = x[["result"]][[id]][["title"]],
        authors = x[["result"]][[id]][["authors"]] %>%
            rlist::list.stack() %>%
            pull(name) %>%
            paste0(., collapse = ", ")
    )
    df
}

#'//////////////////////////////////////

#' ~ 1 ~
#' Build Request and pull data

q <- "\"Genome of the Netherlands consortium\"[Corporate Author]"
ids <- pubmed$get_ids(query = q)
df <- pubmed$get_metadata(ids = ids, delay = 1)

#' clean data
df <- df %>%
    mutate(
        year = stringr::str_replace_all(
            string = date,
            pattern = "([a-zA-Z]+\\s+[0-9]+)|([a-zA-Z]+)",
            replacement = " "
        ) %>%
        trimws(., "both"),
        href_url = stringr::str_replace_all(
            string = elocationId,
            pattern = "doi: ",
            replacement = "https://doi.org/"
        ),
        href_lab = stringr::str_replace_all(
            string = elocationId,
            pattern = "doi: ",
            replacement = ""
        )
    )

#' build html
html <- sapply(
    seq_len(NROW(df)),
    function(d) {
        as.character(
            htmltools::tags$li(
                class = "pub",
                `data-uid` = df[d, c("uid")],
                `data-pub-year` = df[d, c("year")],
                htmltools::tags$span(
                    class = "pub-data pub-title",
                    df[d, c("title")]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-journal",
                    df[d, c("journal")]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-year",
                    df[d, c("year")]
                ),
                htmltools::tags$span(
                    class = "pub-data pub-authors",
                    df[d, c("authors")]
                ),
                htmltools::tags$a(
                    class = "pub-data pub-doi",
                    href = df[d, c("href_url")],
                    df[d, c("href_lab")]
                )
            )
        )
    }
)

#'//////////////////////////////////////

#' ~ 2 ~
#' Write html to file

# load output file
output <- readLines("src/apps/publications/index.html", warn = FALSE)

# find start and end points using `<!--- *htmlTableOutput: ... ->`
positions <- list(
    start = grep("<!--- starthtmlTableOuput: publicationList -->", output) + 1,
    end = grep("<!--- endhtmlTableOuput: publicationList -->", output) - 1
)

# insert new html content
new_output <- c(
    output[1:positions$start],
    html,
    output[positions$end:length(output)]
)

# save new output
write(new_output, "src/apps/publications/index.html")
