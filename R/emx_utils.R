#' ////////////////////////////////////////////////////////////////////////////
#' FILE: emx_utils.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-11-17
#' MODIFIED: 2020-11-17
#' PURPOSE: function for creating base attribute set
#' STATUS: working
#' PACKAGES: NA
#' COMMENTS: NA
#' ////////////////////////////////////////////////////////////////////////////

#' create attributes EMX
#'
#' @param entity entity ID
#'
#' @noRd
set_attributes <- function(entity) {
    d <- data.frame(
        rbind(
            c(
                name = "#CHROM",
                entity = entity,
                dataType = "string",
                label = "#CHROM",
                description = "The chromosome on which the variant is observed",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = FALSE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "ALT",
                entity = entity,
                dataType = "text",
                label = "ALT",
                description = "The alternative allele observed",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = FALSE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "POS",
                entity = entity,
                dataType = "int",
                label = "POS",
                description = "The position on the chromosome which the variant is observed",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = FALSE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "REF",
                entity = entity,
                dataType = "text",
                label = "REF",
                description = "The reference allele",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = FALSE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "FILTER",
                entity = entity,
                dataType = "string",
                label = "FILTER",
                description = "",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "QUAL",
                entity = entity,
                dataType = "string",
                label = "QUAL",
                description = "",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "ID",
                entity = entity,
                dataType = "string",
                label = "ID",
                description = "",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = FALSE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "INTERNAL_ID",
                entity = entity,
                dataType = "string",
                label = "INTERNAL_ID",
                description = "",
                idAttribute = TRUE,
                labelAttribute = TRUE,
                aggregateable = FALSE,
                visible = TRUE,
                nillable = FALSE,
                refEntity = "",
                partOfAttribute = ""
            ),
            c(
                name = "AC",
                entity = entity,
                dataType = "string",
                label = "AC",
                description = "Allele count in genotypes, for each ALT allele, in the same order as ced",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "AF",
                entity = entity,
                dataType = "string",
                label = "AF",
                description = "Allele Frequency, for each ALT allele, in the same order as ced",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "AN",
                entity = entity,
                dataType = "int",
                label = "AN",
                description = "Total number of alleles in called genotypes",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "DB",
                entity = entity,
                dataType = "bool",
                label = "DB",
                description = "dbSNP Membership",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "DP",
                entity = entity,
                dataType = "int",
                label = "DP",
                description = "Approximate read depth; some reads may have been filtered",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "NUMALT",
                entity = entity,
                dataType = "int",
                label = "NUMALT",
                description = "Number of alternative alleles",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "set",
                entity = entity,
                dataType = "text",
                label = "set",
                description = "Source VCF for the merged record in CombineVariants",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = "INFO"
            ),
            c(
                name = "INFO",
                entity = entity,
                dataType = "compound",
                label = "INFO",
                description = "",
                idAttribute = FALSE,
                labelAttribute = FALSE,
                aggregateable = TRUE,
                visible = TRUE,
                nillable = TRUE,
                refEntity = "",
                partOfAttribute = ""
            ) # ,
            # c(
            #     name = "SAMPLES_ENTITIES",
            #     entity = entity,
            #     dataType = "mref",
            #     label = "SAMPLES",
            #     description = "",
            #     idAttribute = FALSE,
            #     labelAttribute = FALSE,
            #     aggregateable = FALSE,
            #     visible = TRUE,
            #     nillable = TRUE,
            #     # refEntity = "GoNL_chr{chr}snps_indelsrSample",
            #     refEntity = "",
            #     partOfAttribute = ""
            # )
        )
    )

    d %>%
        mutate(
            name = factor(
                x = name,
                levels = c(
                    "INTERNAL_ID",
                    "#CHROM", "ALT", "POS", "REF", "FILTER", "QUAL", "ID",
                    "AC", "AF", "AN", "DB", "DP", "NUMALT",
                    "set", "INFO", "SAMPLES_ENTITIES"
                )
            ),
            idAttribute = as.logical(idAttribute),
            labelAttribute = as.logical(labelAttribute),
            aggregateable = as.logical(aggregateable),
            visible = as.logical(visible),
            nillable = as.logical(nillable)
        ) %>%
        arrange(name)
}