#' yml
#'
#' Methods for extracting and writing yaml files
#'
yaml <- function(x) {
    UseMethod("yaml")
}

#' yaml.extract
#'
#' Extract nested data module for each entity
#'
#' @param entity an entity from a yaml object
#' @param type data module to extract (attributes or data)
#' @param pkg_name name of the package
#'
#' @noRd
yaml.extract <- function(
    entity,
    type = c("attributes", "data"),
    pkg_name
) {
    out <- data.frame()
    if (length(entity[[type]])) {
        for (n in seq_len(length(entity[[type]]))) {
            df <- data.frame(entity[[type]][n])
            if (n == 1) {
                out <- df
            } else {
                out <- dplyr::bind_rows(out, df)
            }
        }
    }
    return(out)
}


#' yaml.validate
#'
#' @param yaml a yaml object
#' @param target element to check (Default: entities)
#'
#' @noRd
yaml.validate <- function(yaml, target = "entities") {
    if (!length(yaml[names(yaml) %in% c(target)]) > 0) {
        cli::cli_alert_danger("No {.val {target}} found")
        stop_quietly()
    }
}

#' yaml.apply_options
#'
#' extract yaml options
#'
#' @param data the attributes object
#' @param options yaml$options output
#'
#' @noRd
yaml.apply_options <- function(data, options) {
    for (n in seq_len(NCOL(data))) {
        if (names(data[n]) %in% names(options)) {
            pos <- match(names(data[n]), names(options))
            data[n] <- tidyr::replace_na(data[n], options[pos])
        }
    }
    return(data)
}

#' yaml_load
#'
#' @param path path to yaml file
#' @param ... optional arguments to pass to `read_yaml`
#'
#' @examples
#' \dontrun{
#'  yaml.load("path/to/yml.yml")
#' }
#'
#' @return read yaml EMX configuration file
#'
#' @export
yaml_load <- function(path, ...) {
    if (!file.exists(path)) {
        cli::cli_alert_danger("{.file {path}} does not exist")
        stop_quietly()
    }

    yaml::read_yaml(path, ...)
}

#' yaml.emx
#'
#' extract all emx data
#'
#' @param yaml a yaml object
#'
#' @noRd
yaml_to_emx <- function(yaml) {
    yaml.validate(yaml, target = "entities")

    data <- list()
    data$package <- data.frame(
        yaml[!names(yaml) %in% c("options", "entities")]
    )

    for (d in seq_len(length(yaml[["entities"]]))) {

        entity <- yaml[["entities"]][[d]]

        data[[entity[["name"]]]] <- list(
            attributes = yaml.extract(entity, "attributes", data$package$name),
            data = yaml.extract(entity, "data", data$package$name)
        )

        if (length(yaml$options)) {
            data[[entity[["name"]]]][["attributes"]] <- yaml.apply_options(
                data = data[[entity[["name"]]]][["attributes"]],
                options = yaml$options
            )
        }

        entity_meta <- data.frame(
            entity[!names(entity) %in% c("attributes", "data")]
        )

        if (d == 1) {
            data$entities <- entity_meta

        } else {
            data$entities <- dplyr::bind_rows(data$entities, entity_meta)
        }
    }

    return(data)
}

#' write_yaml_emx
#'
#' Save emx object to file
#'
#' @param emx a parsed yaml object in emx format
#' @param out_dir path to output folder
#' @param ... optional arguments to pass down to readr write_tsv
#'
#' @noRd
write_yaml_emx <- function(emx, out_dir = ".", ...) {

    shell <- c()

    # write package
    readr::write_tsv(
        emx$package,
        path = paste0(out_dir, "/sys_md_Package.tsv"),
        ...
    )
    shell <- paste0("mcmd -p ", out_dir, "/sys_md_Package.tsv")

    # write entities
    readr::write_tsv(
        x = emx$entities,
        path = paste0(out_dir, "/", emx$package$name, "_entities.tsv"),
        ...
    )

    # data to write
    data <- emx[!names(emx) %in% c("package", "entities")]

    # write `attributes` and `data` for each entity
    for (d in seq_len(length(data))) {
        readr::write_tsv(
            x = data[[d]][["attributes"]],
            path = paste0(out_dir, "/", names(data[d]), "_attributes.tsv"),
            ...
        )

        shell <- c(
            shell,
            paste0(
                "mcmd -p ", names(data[d]), "_attributes.tsv ",
                "--as attributes ",
                "--in ", emx$package$name
            )
        )

        if (NROW(data[[d]][["data"]]) > 0) {
            readr::write_tsv(
                x = data[[d]][["data"]],
                path = paste0(out_dir, "/", names(data[d]), ".tsv")
            )

            shell <- c(
                shell,
                paste0(
                    "mcmd -p ", names(data[d]), "_attributes.tsv ",
                    "--as ", emx$package$name, "_", names(data[d]), " ",
                    "--in ", emx$package$name
                )
            )
        }
    }

    writeLines(shell, paste0(out_dir, "/", "setup.sh"))
}

test <- yaml_load("R/data_access_requests.yml") %>%
    yaml_to_emx(yaml = .)

test %>% write_yaml_emx(emx = ., out_dir = "test")
