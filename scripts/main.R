# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")

source("scripts/plotting/create_plot.R")

#Declaramos variables constantes
PACKAGES <- c("dplyr", "readxl", "ggplot2")
FILE_NAME <- "data/VIRUS RESPIRATORIO 2022 A 2024.xlsx"
SHEET_NAME <- "POR PERIODO"
INDICADOR <- 2 #Sleccionar el numero de la tabla que se desea utilizar.


# LOADING
install_and_load_packages(PACKAGES)
tables <- get_all_tables(FILE_NAME, SHEET_NAME)
tabla <- get_selected_table(tables, INDICADOR)


# CLEANING V 2.0
# Clean colnames names
library(janitor)
tabla <- clean_colnames_suffixes(tabla) %>%
        clean_names()

#Fill year (ano)
tabla <- tabla %>%
  fill(ano, .direction = "down")
# DOUBLE TO INT: Convertir todas las columnas excepto la última a enteros
tabla <- tabla %>%
  mutate(across(-percent_de_positividad, as.integer))

str(tabla)


#TABLAS PARA PRUEBAS

# Filtrar registros del año 2022
subtabla_2022 <- tabla %>%
  filter(ano == 2022)
# Filtrar registros del año 2022
subtabla_SIN_2024 <- tabla %>%
  filter(ano != 2024)
# Crear nueva tabla sintetica
registros_2024 <- subtabla_2022 %>%
  mutate(ano = 2024)
tabla_2 <- bind_rows(subtabla_SIN_2024, registros_2024)
str(tabla_2)


subtabla <- data %>%
  filter((ano == 2024 & periodo_epidemiologico <= 4) | ano != 2024)



#PLOTTING
data <- tabla_2

create_plot(data, 7)
