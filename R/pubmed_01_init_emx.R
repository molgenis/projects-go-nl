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

#' pkgs
suppressPackageStartupMessages(library(dplyr))

#' ~ 1 ~
#' create emx structure
emx <- list()

#' define package
emx$package <- data.frame(
    name = "publications",
    label = "GoNL Publications",
    description = "GoNL Publications"
)

#' define entities
emx$entities <- data.frame(
    name = c("records", "queries", "exclusions"),
    label = c("Publication Records", "API Queries", "Records to Exclude"),
    package = "publications",
    description = c(
        "History of Publications and Acknowledgements",
        "Pubmed API queries used to update publication records",
        "List of records to remove that aren't related to the GoNL consortium"
    )
)

#' define attributes
emx$attributes <- tibble::tribble(
    ~entity,    ~name,             ~description,               ~dataType,
    # --------|------------------|---------------------------|-------------|
    "records", "uid",             "pubmed idenitifer",          "string",
    "records", "sortpubdate",     "year of publication",        "string",
    "records", "fulljournalname", "journal title",              "string",
    "records", "volume",          "publication volume",         "string",
    "records", "title",           "article title",              "text",
    "records", "authors",         "all authors collapsed",      "text",
    "records", "doi_url",         "doi url for html href",      "hyperlink",
    "records", "doi_label",       "url link label",             "string",
    "queries", "id",              "a auto generated ID",        "string",
    "queries", "type",            "a general grouping",         "string",
    "queries", "query",           "query to run",               "string",
    "exclusions", "uid",          "pubmed identifier",          "string",
    "exclusions", "reason",       "reason for excluding",       "text",
    "exclusions", "date_created", "date entry was created",     "date"
) %>%
    mutate(
        entity = paste0("publications_", entity),
        idAttribute = case_when(
            name %in% c("id", "uid") ~ TRUE,
            TRUE ~ FALSE
        ),
        nillable = case_when(
            name %in% c("id", "uid") ~ FALSE,
            TRUE ~ TRUE
        )
    )

#' load data files
emx$records <- read.csv("data/pubdata/records.csv")
emx$queries <- read.csv("data/pubdata/queries.csv")

#'//////////////////////////////////////

#' ~ 2 ~
#' Build EMX file

#' init workboox
wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, "packages")
openxlsx::addWorksheet(wb, "entities")
openxlsx::addWorksheet(wb, "attributes")
# openxlsx::addWorksheet(wb, "publications_records")
# openxlsx::addWorksheet(wb, "publications_queries")

#' write data
openxlsx::writeData(wb, "packages", emx$package)
openxlsx::writeData(wb, "entities", emx$entities)
openxlsx::writeData(wb, "attributes", emx$attributes)
# openxlsx::writeData(wb, "publications_records", emx$records)
# openxlsx::writeData(wb, "publications_queries", emx$queries)

#' save workbook
openxlsx::saveWorkbook(wb, "data/pubdata/publications.xlsx", overwrite = TRUE)

#' write emx package
#' write.csv(emx$package, "data/pubdata/sys_md_Package.csv", row.names = FALSE)
