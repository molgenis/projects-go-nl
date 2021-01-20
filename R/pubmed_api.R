#'////////////////////////////////////////////////////////////////////////////
#' FILE: pubmed_api.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-20
#' MODIFIED: 2021-01-20
#' PURPOSE: source publications list from pubmed
#' STATUS: in.progress
#' PACKAGES: easypubmed
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' pkgs
#' install.packages("easyPubMed")
#' install.packages("htmltools")
#' install.packages("rlist")

#' run publication query
q <- "\"Genome of The Netherlands Consortium\"[Author - Corporate]"
pub_ids <- easyPubMed::get_pubmed_ids(q)
pub_raw <- easyPubMed::fetch_pubmed_data(pub_ids)
pub_df <- easyPubMed::table_articles_byAuth(
    pubmed_data = pub_raw,
    getKeywords = FALSE,
    included_authors = "all",
    autofill = FALSE
)


pub_raw_ids <- easyPubMed::custom_grep(pub_raw, "PMID")
pub_raw_aucorp <- easyPubMed::custom_grep(pub_raw, "Author", format = "char")

#' reduce dataset
df <- pub_df %>%
    select(pmid, doi, title, year, jabbrv, journal, lastname, firstname) %>%
    group_by(pmid) %>%
    mutate(
        authors = paste0(
            lastname, ", ",
            substring(firstname, 1, 1),
            collapse = "; "
        )
    ) %>%
    select(-lastname, -firstname) %>%
    distinct(pmid, .keep_all = TRUE)

#' generate html
html <- lapply(
    seq_len(NROW(df)),
    function(d) {
        htmltools::tags$li(
            class = "pub",
            htmltools::tags$span(
                class = "pub-data pub-title",
                df[d, c("title")]
            ),
            htmltools::tags$span(
                class = "pub-data pub-year",
                df[d, c("year")]
            ),
            htmltools::tags$span(
                class = "pub-data pub-authors",
                df[d, c("authors")]
            ),
            htmltools::tags$span(
                class = "pub-data pub-journal",
                df[d, c("journal")]
            ),
            htmltools::tags$span(
                class = "pub-data pub-doi",
                df[d, c("doi")]
            )
        )
    }
)



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
pubmed$get_metadata <- function(ids) {
    
}


#' make_request
#'
#' Make a GET request for a single publication ID
#'
#' @param id a publication ID
#'
#' @noRd
pubmed$make_request <- function(id) {
    response <- httr::GET(
        url = paste0(
            "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?",
            "db=pubmed",
            "&id=", id,
            "&retmode=json&"
        )
    )

    if (response$status_code == 200) {
        raw <- httr::content(response, as = "text", encoding = "UTF-8")
        rjson::fromJSON(raw)
    } else {
        m <- "An error occurred {.val {response$status_code}}"
        cli::cli_alert_danger(m)
        response
    }
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

x <- pubmed$make_request(ids[1])
pubmed$clean_request(x)

library(pipeR)
library(rlist)