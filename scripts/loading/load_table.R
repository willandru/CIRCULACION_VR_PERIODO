# Source the function from utils
source("scripts/utils/get_all_tables.R")
source("scripts/utils/load_libraries.R")


PACKAGES <- c("dplyr", "readxl")
FILE_NAME <- "data/VIRUS RESPIRATORIO 2022 A 2024.xlsx"
SHEET_NAME <- "POR PERIODO"

install_and_load_packages(PACKAGES)

tables <- get_all_tables(FILE_NAME, SHEET_NAME)
