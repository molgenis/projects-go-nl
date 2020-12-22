#'////////////////////////////////////////////////////////////////////////////
#' FILE: emx_create_05_questionnaire.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-12-22
#' MODIFIED: 2020-12-22
#' PURPOSE: create request datda questionnaire
#' STATUS: in.progress
#' PACKAGES: NA
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

# pkgs
suppressPackageStartupMessages(library(dplyr))

# create workbook
wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, "packages")
openxlsx::addWorksheet(wb, "entities")
openxlsx::addWorksheet(wb, "attributes")

#'//////////////////////////////////////

#' ~ 1 ~
# Create Package

data.frame(
    name = "requests",
    label = "Requests",
    description = "GoNL Data Requests"
) %>%
    openxlsx::writeData(wb, "packages", .)

#'//////////////////////////////////////

#' ~ 2 ~
#' Create Entities

data.frame(
    name = "requests_submissions",
    label = "Submissions",
    description = "GoNL data access request submissions"
) %>%
    openxlsx::writeData(wb, "entities", .)

#'//////////////////////////////////////

#' ~ 3 ~
#' Create Attributes

data.frame(
    entity = "requests_submissions",
    name = c(
        "id",
        "applicantName",
        "applicantEmail",
        "applicantAffiliation",
        "applicantTeam",
        "studyTitle",
        "researchQuestion",
        "consentApprovals"
    ),
    label = c(
        "identifier",
        "Name",
        "Email",
        "Affiliation",
        "Additional Applicants",
        "Postal Address",
        "Enter the Title of the study",
        "Research Question",
        "Consent and Approvals"
    ),
    description = c(
        "request ID",
        "Name of the primary applicant",
        "",
        "Employment or affiliation with your organization",
        # applicant team
        paste0(
            "If there are more than one applicants, list them below.",
            "Please ensure that a full postal and email address is ",
            "included for each applicant."
        ),
        # study title
        "Less than 30 words",
        # research question
        paste0(
            "Please describe the study in no more than 750 words. Include: a",
            "outline of the study design; b. an indication of the ",
            "methodologies to be used; c. proposed use of the Project Data; ",
            "d. preceding peer-reviews of the study (if any present); ",
            "e. specific details of what you plan to do with the Project Data;",
            " f. timeline; g. key references."
        ),
        # consent and approvals
        paste0(
            "If your proposed use of Project Data involves use of your own ",
            "data, please confirm that you have obtained all approvals ",
            "required by the rules and regulations of your jurisdiction, ",
            "including your institution’s institutional rules, and the ",
            "consent of your data subjects, for your use of your own data ",
            "in the study, by ticking the following box:"
        )
    ),
    dataType = c(
        "string",
        "string",
    )
) %>%
    mutate(
        idAttribute = case_when(
            name == "id" ~ "AUTO",
            TRUE ~ FALSE
        ),
        nillable = case_when(
            name == "id" ~ FALSE,
            TRUE ~ FALSE
        )
    )