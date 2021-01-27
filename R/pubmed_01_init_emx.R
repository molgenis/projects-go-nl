#'////////////////////////////////////////////////////////////////////////////
#' FILE: pubmed_01_init_emx.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-27
#' MODIFIED: 2021-01-27
#' PURPOSE: init emx package structure for publications package
#' STATUS: in.progress
#' PACKAGES: Na
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' init
emx <- list()

#' define package
emx$package <- data.frame(
    id = "publications",
    label = "Publications",
    description = "GoNL Publications"
)

#' define entities
emx$entities <- data.frame(
    name = "history",
    package = "publications",
    description = "History of Publications and Acknowledgements"
)

#' define attributes
emx$attributes <- tibble::tribble(
    ~entity,    ~name,             ~description,               ~dataType,
    # --------|------------------|---------------------------|-------------|
    "history", "uid",             "pubmed idenitifer",          "string",
    "history", "sortpubdate",     "year of publication",        "int",
    "history", "fulljournalname", "journal title",              "string",
    "history", "volume",          "publication volume",         "int",
    "history", "title",           "article title",              "text",
    "history", "authors",         "all authors collapsed",      "text",
    "history", "doi_url",         "doi url for html href",      "hyperlink",
    "history", "doi_label",       "url link label",             "string",
    "history", "html_order",      "int for html purposes only", "int"
) %>%
    mutate(
        idAttribute = case_when(
            name == "uid" ~ TRUE,
            TRUE ~ FALSE
        )
    )

#' Create molgenis EMX
readr::write_tsv(emx$package, "data/pubdata/sys_md_Package.tsv")
readr::write_tsv(emx$entities, "data/pubdata/publications_entities.tsv")
readr::write_tsv(emx$attributes, "data/pubdata/publications_attributes.tsv")
