# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")

#Declaramos variables constantes
PACKAGES <- c("dplyr", "readxl")
FILE_NAME <- "data/VIRUS RESPIRATORIO 2022 A 2024.xlsx"
SHEET_NAME <- "POR PERIODO"
INDICADOR <- 2 #Sleccionar el numero de la tabla que se desea utilizar.

#Cargamos paquetes
install_and_load_packages(PACKAGES)
tables <- get_all_tables(FILE_NAME, SHEET_NAME)
display_tables(tables)





tabla <- get_selected_table(tables, 2)
str(tabla)










