#'////////////////////////////////////////////////////////////////////////////
#' FILE: pubmed_02_update.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-27
#' MODIFIED: 2021-01-27
#' PURPOSE: update publication history
#' STATUS: in.progress
#' PACKAGES: see below
#' COMMENTS: Na
#'////////////////////////////////////////////////////////////////////////////

#' load pubmed tools
source("R/pubmed_99_utils.R")

#' ~ 1 ~
#' Build Request and pull data

#' load publication dataset for Ids (if exists)
ref_df <- readr::read_tsv("data/pubdatda/publications.tsv")

#' build and run requests
papers <- list()

#' define queries here
#'papers$queries <- data.frame(
#'    id = c("q_01", "q_02"),
#'    type = c("author", "papers"),
#'    query = c(
#'        "\"Genome of the Netherlands consortium\"[Corporate Author]",
#'        "The Genome of the Netherlands: design, and project goals[Title]"
#'    )
#')

#' save queries
papers$queries <- write.csv(
    papers$queries, "data/pubdata/queries.csv", row.names = FALSE
)

if (length(papers$ids) == 0) {
    print("No new papers")
}

#' get publication ids for each query
papers$ids <- unlist(lapply(papers$queries$query, function(x) {
    pubmed$get_ids(query = x)
}))

#' if `ref_df` exists, remove existing Ids (we are interested in new ids)
papers$ids <- papers$ids[!papers$ids %in% ref_df$uid]

#' fetch publication metadata (if there are new Ids)
if (length(papers$ids)) {
    papers$data <- pubmed$get_metadata(
        ids = papers$ids,
        delay = sample(runif(50, 0.75, 2), length(papers$ids))
    )

    # create object containing run queries
    papers$query_df <- data.frame(
        type = names(papers$q),
        query = as.character(papers$q)
    )

    #' prepare publications dataset
    pubs <- pubmed$build_df(x = papers$data)

    #' build and write html (first time only)
    #' html <- c("<ol>", pubmed$build_html(x = pubs), "</ol>")
    #' pubmed$write_html(
    #'     file = "src/apps/publications/index.html",
    #'     id = "publicationList",
    #'     html = html
    #' )

    #' save data
    write.csv(pubs, "data/pubdata/records.csv", row.names = FALSE)
}
