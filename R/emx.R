#' ////////////////////////////////////////////////////////////////////////////
#' FILE: emx.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-11-16
#' MODIFIED: 2020-11-18
#' PURPOSE: primary script for building EMX files
#' STATUS: working; ongoing
#' PACKAGES: readr; dplyr
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

#' pkgs
suppressPackageStartupMessages(library(dplyr))

#' ~ 1 ~
#' Create Package
data.frame(
    id = "gonl",
    label = "GoNL",
    description = "Genome of the Netherlands",
    idAttribute = FALSE,
    labelAttribute = FALSE,
    parent = "",
    tags = ""
) %>%
    readr::write_tsv(
        x = .,
        path = "data/sys_md_Package.tsv"
    )

#'//////////////////////////////////////

#' ~ 2 ~
#' Create entities
data.frame(
    name = "gonl_attribs",
    package = "gonl",
    extends = "",
    abstract = "",
    description = "package attributes"
) %>%
    bind_rows(
        data.frame(
            name = sapply(seq.int(1, 22, 1), function(d) paste0("gonl_chr", d)),
            package = "gonl",
            extends = "attribs",
            abstract = "",
            description = sapply(
                seq.int(1, 22, 1),
                function(d) {
                    paste0("GoNL chr", d)
                }
            )
        )
    ) %>%
    readr::write_tsv(
        x = .,
        path = "data/gonl_entities.tsv"
    )

#'//////////////////////////////////////

#' ~ 3 ~
#' Create `attributes` entity
source("R/emx_base_attribs.R")
set_attributes(entity = "attribs") %>%
    readr::write_tsv(x = ., path = "data/gonl_attributes.tsv")


#'//////////////////////////////////////

#' ~ 4 ~
#' Create Static Content

html <- readLines("./www/index.html", warn = FALSE) %>%
    paste0(., collapse = "\n") %>%
    stringr::str_replace_all(
        string = .,
        pattern = "([\\r\\n\\t])",
        replacement = ""
    )

data.frame(
    key = "home",
    content = html
) %>%
    readr::write_tsv(
        x = .,
        path = "data/sys_StaticContent.tsv",
        quote_escape = "double"  # this may need to be adjusted
    )
