#'////////////////////////////////////////////////////////////////////////////
#' FILE: emx_create_05_requests_pkg.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-05
#' MODIFIED: 2021-01-12
#' PURPOSE: create EMX for data access request questionnaire
#' STATUS: complete
#' PACKAGES: openxlsx, dplyr, htmltools
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

# pkgs
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(htmltools))

# create new workbook
wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, "entities")
openxlsx::addWorksheet(wb, "attributes")
openxlsx::addWorksheet(wb, "yesno")
openxlsx::addWorksheet(wb, "datasets")


# function to collapse shiny tags to html string
as_html_string <- function(...) {
    paste0(paste0(...), collapse = "") %>%
    gsub("\\s{2,}", " ", .) %>%
    gsub(">\\s{1}", ">", .) %>%
    gsub("\\n<", "<", .) %>%
    gsub("\\s{1}</", "</", .)
}

#'//////////////////////////////////////

#' ~ 1 ~
#' Create `entities` worksheets

entities <- data.frame(
    name = c("dar", "yesno", "datasets"),
    label = c("Data Access Requests", "YesNo", "Datasets"),
    description = c(
        "All requests for the GoNL data",
        "Input label reference entity",
        "Input labels for dataset selection"
    )
)
openxlsx::writeData(wb, sheet = "entities", x = entities)

#'//////////////////////////////////////

#' ~ 2 ~
#' Create `attributes` worksheet

#' ~ 2a ~
# create basic structure, and row bind other entries
attribs <- c(
    entity = "dar",
    name = "id",
    label = "id",
    description = "unique identifier",
    dataType = "string",
    idAttribute = "AUTO",
    nillable = "FALSE"
)


#' ~ 2b ~
# define applicant information
attribs <- attribs %>%
    bind_rows(
        c(
            name = "applicant",
            label = "Applicant Information",
            description = paste0(
                "Please provide contact details for the applicant and all ",
                "additional applicants if applicable."
            ),
            dataType = "compound"
        ),
        c(
            name = "applicant_name",
            label = "Name",
            dataType = "string",
            partOfAttribute = "applicant"
        ),
        c(
            name = "applicant_email",
            label = "Email",
            dataType = "email",
            partOfAttribute = "applicant"
        ),
        c(
            name = "applicant_affiliation",
            label = "Affiliation",
            description = "Employment or affiliation with any organization",
            dataType = "string",
            partOfAttribute = "applicant"
        ),
        c(
            name = "applicant_collaborators",
            label = "Additional Applicants",
            description = paste0(
                "Please ensure that a full postal and email is included for ",
                "each applicant."
            ),
            dataType = "text",
            partOfAttribute = "applicant"
        )
    )

#' ~ 2c ~
#' Information about the Research Study
attribs <- attribs %>%
    bind_rows(
        c(
            name = "research",
            label = "Research Study",
            dataType = "compound"
        ),
        c(
            name = "research_title",
            label = "Study Title",
            description = "Enter the name of your study (less than 30 words)",
            dataType = "string",
            partOfAttribute = "research"
        ),
        c(
            name = "research_question",
            label = "Research Question",
            description = paste0(
                "Please describe the study in no more than 750 words. ",
                " Include: a. outline of the study design; b. an indication of",
                " the methodologies to be used; c. proposed use of the Project",
                " Data; d. preceding peer-reviews of the study (if any",
                " present); e. specific details of what you plan to do with",
                " the Project Data; f. timeline; g. key references."
            ),
            dataType = "text",
            partOfAttribute = "research"
        )
    )

#' ~ 2d ~
#' Define Consent Attributes
attribs <- attribs %>%
    bind_rows(
        c(
            name = "consent",
            label = "Consent and Approvals",
            dataType = "compound"
        ),
        c(
            name = "consent_status",
            label = "Do you have approval to carry out the proposed research?",
            description = paste0(
                "If your proposed use of Project Data involves use of your own",
                " data, please confirm that you have obtained all approvals",
                " required by the rules and regulations of your jurisdiction,",
                " including your institution’s institutional rules, and the",
                " consent of your data subjects, for your use of your own data",
                " in the study, by ticking the following box."
            ),
            dataType = "categorical",
            partOfAttribute = "consent",
            refEntity = "yesno"
        ),
        c(
            name = "consent_info",
            label = "Please specify official IRB or METc",
            dataType = "text",
            partOfAttribute = "consent",
            visible = "$('consent_status').eq('Yes').value()"
        )
    )

#' ~ 2e ~
#' Define datasets attributes
attribs <- attribs %>%
    bind_rows(
        c(
            name = "data",
            label = "Data",
            dataType = "compound"
        ),
        c(
            name = "data_requested",
            label = "Datasets Requested",
            description = paste0(
                "Indicate the data that is ",
                "Select all that apply. Twin data cannot be requested in ",
                "light of privacy concerns. Age, sex and family structure is ",
                "included in the data access."
            ),
            dataType = "categorical_mref",
            partOfAttribute = "data",
            refEntity = "datasets"
        ),
        c(
            name = "data_other_info",
            label = "Other data required",
            description = "Please describe below",
            dataType = "text",
            partOfAttribute = "data",
            visible = "$('data_requested').value().indexOf('Other') > -1"
        )
    )

#' ~ 2f ~
#' Resources, Feasibility & Expertise
attribs <- attribs %>%
    bind_rows(
        c(
            name = "resources",
            label = "Resources, Feasibility & Expertise",
            dataType = "compound"
        ),
        c(
            name = "resources_hasFunding",
            label = "Do you have funding to carry out the proposed research?",
            description = paste0(
                "Please confirm that you have secured funding for your ",
                "proposed use of the Project Data and that you will carry ",
                "out your research within a reasonable period of time after ",
                "the granting of this application"
            ),
            dataType = "categorical",
            partOfAttribute = "resources",
            refEntity = "yesno"
        ),
        c(
            name = "resources_experience",
            label = "Research Experience",
            description = paste0(
                "Please describe your experience and expertise, and ",
                "that of your collaborators, and how this will be ",
                "applied to the proposed study"
            ),
            dataType = "text",
            partOfAttribute = "resources"
        ),
        c(
            name = "resources_pubs",
            label = "Publications",
            description = paste0(
                "Please provide a list of recent publications (max 10)"
            ),
            dataType = "text",
            partOfAttribute = "resources"
        )
    )

#' ~ 2g ~
#' Agreement
attribs <- attribs %>%
    bind_rows(
        c(
            name = "agreement",
            label = "Acess Conditions",
            dataType = "compound"
        ),
        c(
            name = "agreement_status",
            label = "Have you read and agree to the GoNL data acess agreement?",
            description = paste0(
                "Please declare that you have read and agree to abide by the ",
                "terms and conditions outlined in the GoNL data access ",
                "agreement (which you will need to sign on approval of this ",
                "project)"
            ),
            dataType = "categorical",
            partOfAttribute = "agreement",
            refEntity = "yesno"
        )
    )

#' ~ 2i ~
#' Add entity `requests_datasets`
attribs <- attribs %>%
    bind_rows(
        data.frame(
            entity = "datasets",
            name = c("id", "label", "sortOrder"),
            label = c("id", "label", "sortOrder"),
            dataType = c("string", "string", "int"),
            idAttribute = c("TRUE", "FALSE", "FALSE"),
            nillable = c("FALSE", "FALSE", "FALSE")
        )
    )


#' ~ 2j ~
#' Add entity `requests_yes_no`
attribs <- attribs %>%
    bind_rows(
        data.frame(
            entity = "yesno",
            name = c("id", "label"),
            label = c("id", "label"),
            dataType = c("string", "string"),
            idAttribute = c("TRUE", "FALSE"),
            nillable = c("FALSE", "FALSE")
        )
    )

#' ~ 2k ~
#' Clean
attribs <- attribs %>%
    mutate(
        entity = case_when(
            is.na(entity) ~ "dar",
            TRUE ~ as.character(entity)
        ),
        entity = factor(
            entity,
            c(
                "datasets",
                "yesno",
                "dar"
            )
        ),
        description = tidyr::replace_na(description, ""),
        idAttribute = case_when(
            is.na(idAttribute) ~ "FALSE",
            TRUE ~ as.character(idAttribute)
        ),
        nillable = case_when(
            is.na(nillable) ~ TRUE,
            TRUE ~ as.logical(nillable)
        ),
        visible = case_when(
            is.na(visible) ~ "TRUE",
            TRUE ~ as.character(visible)
        ),
        partOfAttribute = tidyr::replace_na(partOfAttribute, "")
    ) %>%
    select(
        entity, name, label, description, dataType,
        idAttribute, nillable, visible,
        partOfAttribute, refEntity
    ) %>%
    arrange(entity)
    

openxlsx::writeData(wb, sheet = "attributes", x = attribs)

#'//////////////////////////////////////

#' ~ 3 ~
#' create reference entities

#' ~ 3a ~
# Options for selecting datasets
data.frame(
    id = c(
        "SNV calls",
        "INDEL calls",
        "Imputation-ready haplotypes",
        "SV calls",
        "trio-BAM files",
        "unaligned fastq files",
        "Other"
    ),
    label = c(
        "SNV calls (498 unrelated parents and 249 children)",
        "INDEL calls (498 unrelated parents and 249 children)",
        "Imputation-ready haplotypes (SNVs + INDELs) (998 haplotypes)",
        "SV calls (> 20bp)",
        "trio-BAM files (249 trios, 498 unrelated parents, 249 children)",
        "unaligned fastq files (750 samples)",
        "Other, describe below"
    )
) %>%
    mutate(sortOrder = seq_len(length(label)) - 1) %>%
    select(id, label, sortOrder) %>%
    openxlsx::writeData(wb, "datasets", x = .)

#' ~ 3b ~
# labels for Yes or No categorical input
data.frame(id = c("Yes", "No"), label = c("Yes", "No")) %>%
    openxlsx::writeData(wb, "yesno", x = .)

#'//////////////////////////////////////

#' ~ 4 ~
#' Write data

openxlsx::saveWorkbook(
    wb = wb,
    file = "data/emx_data_access_requests.xlsx",
    overwrite = TRUE
)