[![Refresh Publications](https://github.com/molgenis/molgenis-go-nl/actions/workflows/update-publications.yml/badge.svg)](https://github.com/molgenis/molgenis-go-nl/actions/workflows/update-publications.yml)

![Genome of the Netherlands proejct](www/images/gonl.png)

# GoNL Molgenis Server

The `molgenis-go-nl` repository contains all of the code, data, and files used to update the GoNL MOLGENIS app. The motivation behind this was to create a semi-reproducible workflow for updating the GoNL Molgenis server. This method may be useful for developing, managing, documenting future Molgenis projects.

## What's in this repository?

There's a lot going here. Perhaps it's better to start with the phases of the project.

### The GoNL EMX Structure

The GoNL database has two packages (i.e., emx packages).

1. GoNL: the GoNL package contains all of the vcf files for the GoNL project
2. Publications: the purpose of this package is to store all information related to GoNL publications. There are two entities in this package: `records` (publication data) and `queries` (all queries required to find publications). These entities are used by a GitHub Action that runs the periodically.

I wanted to programmatically create and import the assets (EMX and data) into the Molgenis database. I created a series of scripts (`R/*`) that generate the EMX for both molgenis packages. The outputs of these scripts are saved in the `data` folder, and then imported into the database using the script `shell/setup.sh`. Thes methods and workflows for the GitHub Action are also stored in the `R/` directory.

I do not have an automated workflow for downloading the source vcfs. Download the files from the server to your locally machine, and then run `shell/import_vcfs.sh`

### Custom Molgenis Apps: Migrating from Wordpress

The UI of the database is a series of custom molgenis apps. The site was originally hosted on wordpress, but we decided to move everything into the Molgenis database. The original HTML pages, images, and other assets are located in the `src` directory. The redesigned Molgenis apps are stored in `public` folder.

For more information about this phase of the project, see `public/README.md`. Commands for configuring the apps be found in `shell/setup.sh`.

## Getting Started

Depending on which side of the database you are working on, you will need to install some tools. I would recommend installing all of them anyways as they are good to have. The following instructions show you have to install everything.

### 1. Install Node and NPM

Make sure [Node and NPM](https://nodejs.org/en/) are installed on your machine. You may also use [Yarn](https://yarnpkg.com/en/). To test the installation or to see if these tools are already installed on your machine, run the following commands in the terminal.

```shell
node -v
npm -v
```

I have decided to use [pnpm](https://github.com/pnpm/pnpm) as an alternative to yarn and npm. It is much easier to manage packages across projects on my machine. To install `pnpm`, run the following command.

```shell
npm install -g pnpm
```

### 2. Install R

If you are working on the EMX and database, you will need to install R. See [https://cran.r-project.org](https://cran.r-project.org) for the latest installation instructions.

Once R is installed, you will need the following R packages.

```r
install.packages(c("dplyr", "jsonlite", "readr", "stringr"))
```

In the setup shell script (`shell/rscript.sh`), use the `Rscript` commands to generate the GoNL EMX data files. For example, let's say that I want to update the entities EMX. First, make the required changes in the `R/emx_create_02_entities.R` files, and then run it using `Rscript`.

```shell
Rscript -e "source('R/emx_create_02_entities.R')"
```

All files are saved to the `data/` folder.
