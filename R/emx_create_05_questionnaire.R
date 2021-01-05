#'////////////////////////////////////////////////////////////////////////////
#' FILE: emx_create_05_questionnaire.R
#' AUTHOR: David Ruvolo
#' CREATED: 2021-01-05
#' MODIFIED: 2021-01-05
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
openxlsx::addWorksheet(wb, sheetName = "entities")
openxlsx::addWorksheet(wb, sheetName = "attributes")


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
#' Create 'entities' worksheet

data.frame(
    name = "dar",
    label = "GoNL Data Access Request",
    description = as_html_string(
        tags$p(
            "Individual level sequence data and/or variant calls can be",
            "requested as follows."
        ),
        tags$ol(
            tags$li(
                "Fill in the GoNL Data Access Request form. For questions",
                "email",
                tags$a(
                    href = "mailto:gonl@bbmri.nl",
                    "gonl@bbmri.nl"
                )
            ),
            tags$li(
                "Your research request will be evaluated by the GoNL steering",
                "committee"
            ),
            tags$li(
                "If positive, you will receive a ",
                tags$a(
                    href = "/api/files/aaaac5wm2w4d4ascvqkqabqaae?alt=media",
                    "data access agreement",
                    .noWS = "outside"
                ),
                "to be signed"
            ),
            tags$li(
                "You will be granted access to the data using a suitable method"
            ),
            tags$li("At publication add suitable acknowledgement")
        )
    ),
    extends = "sys_Questionnaire"
) %>%
    openxlsx::writeData(wb, sheet = "entities", x = .)

#'//////////////////////////////////////

#' ~ 2 ~
#' Create `attributes` worksheet

data.frame(
    name = "id",
    label = "id",
    description = "unique identifier",
    dataType = "string",
    partOfAttribute = ""
) %>%
    bind_rows(

        # applicant information
        data.frame(
            name = "applicant",
            label = "Applicant Information",
            description = paste0(
                "Please provide contact details for the applicant and any ",
                "additional applicants (if applicable)."
            ),
            dataType = "compound",
            partOfAttribute = ""
        ),
        data.frame(
            name = "applicant_name",
            label = "Name",
            description = "",
            dataType = "string",
            partOfAttribute = "applicant"
        ),
        data.frame(
            name = "applicant_email",
            label = "Email",
            description = "",
            dataType = "email",
            partOfAttribute = "applicant"
        ),
        data.frame(
            name = "applicant_affiliation",
            label = "Affiliation",
            description = "Employment or affiliation with any organization",
            dataType = "string",
            partOfAttribute = "applicant"
        ),
        data.frame(
            name = "applicant_collaborators",
            label = "Additional Applicants",
            description = paste0(
                "Please ensure that a full postal and email is included for ",
                "each applicant."
            ),
            dataType = "text",
            partOfAttribute = "applicant"
        ),

        # information about the research study
        data.frame(
            name = "research",
            label = "Research Study",
            description = "",
            dataType = "compound"
        ),
        data.frame(
            name = "research_title",
            label = "Study Title",
            description = "Enter the name of your study (less than 30 words)",
            dataType = "string",
            partOfAttribute = "research"
        ),
        data.frame(
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
        ),

        # consent information
        data.frame(
            name = "consent",
            label = "Consent and Approvals",
            description = "",
            dataType = "compound"
        ),
        data.frame(
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
            dataType = "bool",
            partOfAttribute = "consent"
        ),
        data.frame(
            name = "consent_info",
            label = "Please specify official IRB or METc",
            description = "",
            dataType = "text",
            partOfAttribute = "consent"
        ),

        # data requested
        data.frame(
            name = "data",
            label = "Data Requested",
            description = paste0(
                "Indicate the data that is ",
                "Select all that apply. Twin data cannot be requested in ",
                "light of privacy concerns. Age, sex and family structure is ",
                "included in the data access."
            ),
            dataType = "compound",
            partOfAttribute = ""
        ),
        data.frame(
            name = "data_snv",
            label = "SNV calls",
            description = "498 unrelated parents and 249 children",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_indel",
            label = "INDEL Calls",
            description = "498 unrelated parents and 249 children",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_haplotypes",
            label = "Haplotypes",
            description = "SNVs and INDELS (998 haplotypes)",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_svCalls",
            label = "SV Calls",
            description = "> 20bp",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_trioBamFiles",
            label = "trio-BAM files",
            description = "249 trios, 498 unrelated parents, 249 children",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_fastq",
            label = "Unaligned fastq files",
            description = "750 samples",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_other",
            label = "Other",
            description = "",
            dataType = "bool",
            partOfAttribute = "data"
        ),
        data.frame(
            name = "data_other_info",
            label = "Other data required",
            description = "Please describe below",
            dataType = "text",
            partOfAttribute = "data"
        ),

        # Resources, Feasibility & Expertise
        data.frame(
            name = "resources",
            label = "Resources, Feasibility & Expertise",
            description = "",
            dataType = "compound",
            partOfAttribute = ""
        ),
        data.frame(
            name = "resources_hasFunding",
            label = "Do you have funding to carry out the proposed research?",
            description = paste0(
                "Please confirm that you have secured funding for your ",
                "proposed use of the Project Data and that you will carry ",
                "out your research within a reasonable period of time after ",
                "the granting of this application"
            ),
            dataType = "bool",
            partOfAttribute = "resources"
        ),
        data.frame(
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
        data.frame(
            name = "resources_pubs",
            label = "Publications",
            description = paste0(
                "Please provide a list of recent publications (max 10)"
            ),
            dataType = "text",
            partOfAttribute = "resources"
        ),
        data.frame(
            name = "agreement",
            label = "Acess Conditions",
            description = "",
            dataType = "compound",
            partOfAttribute = ""
        ),
        data.frame(
            name = "agreement_status",
            label = "Have you read and agree to the GoNL data acess agreement?",
            description = paste0(
                "Please declare that you have read and agree to abide by the ",
                "terms and conditions outlined in the GoNL data access ",
                "agreement (which you will need to sign on approval of this ",
                "project)"
            ),
            dataType = "bool",
            partOfAttribute = "agreement"
        )
    ) %>%
    mutate(
        entity = "dar",
        visible = case_when(
            name == "consent_info" ~ "$('consent_status').eq(true).value()",
            name == "data_other_info" ~ "$('data_other').eq(true).value()"
        ),
        nillable = case_when(
            name == "id" ~ FALSE
        ),
        idAttribute = case_when(
            name == "id" ~ "AUTO"
        )
    ) %>%
    select(
        entity, name, label, description, dataType,
        idAttribute, nillable, visible, partOfAttribute
    ) %>%
    openxlsx::writeData(wb, sheet = "attributes", x = .)

#'//////////////////////////////////////

#' ~ 3 ~
#' Write data

openxlsx::saveWorkbook(
    wb = wb,
    file = "data/dar_questionnaire.xlsx",
    overwrite = TRUE
)