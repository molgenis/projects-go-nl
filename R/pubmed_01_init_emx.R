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

#' ~ 1 ~
#' create emx structure
emx <- list()

#' define package
emx$package <- data.frame(
    id = "publications",
    label = "GoNL Publications",
    description = "GoNL Publications"
)

#' define entities
emx$entities <- data.frame(
    name = c("records", "queries"),
    label = c("Publication Records", "API Queries"),
    package = "publications",
    description = c(
        "History of Publications and Acknowledgements",
        "Pubmed API queries used to update publication records"
    )
)

#' define attributes
emx$attributes <- tibble::tribble(
    ~entity,    ~name,             ~description,               ~dataType,
    # --------|------------------|---------------------------|-------------|
    "records", "uid",             "pubmed idenitifer",          "string",
    "records", "sortpubdate",     "year of publication",        "int",
    "records", "fulljournalname", "journal title",              "string",
    "records", "volume",          "publication volume",         "int",
    "records", "title",           "article title",              "text",
    "records", "authors",         "all authors collapsed",      "text",
    "records", "doi_url",         "doi url for html href",      "hyperlink",
    "records", "doi_label",       "url link label",             "string",
    "records", "html_order",      "int for html purposes only", "int",
    "queries", "id",              "a auto generated ID",        "string",
    "queries", "type",            "a general grouping",         "string",
    "queries", "query",           "query to run",               "string"
) %>%
    mutate(
        # entity = paste0("publications_", entity),
        idAttribute = case_when(
            name %in% c("id", "uid") ~ TRUE,
            TRUE ~ FALSE
        ),
        nillable = case_when(
            name %in% c("id", "uid") ~ FALSE,
            TRUE ~ TRUE
        )
    )

#'//////////////////////////////////////

#' ~ 2 ~
#' Save

#' write emx package
write.csv(emx$package, "data/pubdata/sys_md_Package.csv", row.names = FALSE)

#' save emx entities -- this doesn't work at the moment!
write.csv(emx$entities, "data/pubdata/entities.csv", row.names = FALSE)
write.csv(
    emx$entities,
    "data/pubdata/publications_entities.csv",
    row.names = FALSE
)

#' save attributes for publication records entity
write.csv(
    emx$attributes[emx$attributes$entity == "records", ],
    "data/pubdata/records_attributes.csv",
    row.names = FALSE
)

#' save attributes for pubmed API queries entity
write.csv(
    emx$attributes[emx$attributes$entity == "queries", ],
    "data/pubdata/queries_attributes.csv",
    row.names = FALSE
)
