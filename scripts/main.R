# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")

#Declaramos variables constantes
PACKAGES <- c("dplyr", "readxl", "janitor")
FILE_NAME <- "data/VIRUS RESPIRATORIO 2022 A 2024.xlsx"
SHEET_NAME <- "POR PERIODO"
INDICADOR <- 2 #Sleccionar el numero de la tabla que se desea utilizar.

#Cargamos paquetes
install_and_load_packages(PACKAGES)
tables <- get_all_tables(FILE_NAME, SHEET_NAME)
display_tables(tables)


#DATA LOADING
tabla <- get_selected_table(tables, 2)

#DATA CLEANING
str(tabla)
colnames(tabla)
tabla <- clean_colnames_suffixes(tabla)
tabla <- clean_colnames_spaces(tabla)
tabla <- fill_down_year(tabla, "AÑO")
str(tabla)
colnames(tabla)

#PREPROCESSING

tabla <- tabla %>% slice(1:32)


# Transformar las columnas de virus en formato largo :: PERFECTO
tabla_long <- tabla %>%
  pivot_longer(
    cols = `A(H1N1)pdm09`:`Otros_Virus`,    # Selecciona solo las columnas de virus
    names_to = "Virus",                     # Columna nueva para el tipo de virus
    values_to = "Casos"                     # Columna nueva para los valores de casos
  )
print(tabla_long)

#DATA VISUALIZATION


library(ggplot2)

# Create the stacked bar plot
ggplot(tabla_long, aes(x = as.factor(PERIODO_EPIDEMIOLOGICO), y = Casos, fill = Virus)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    x = "Semana Epidemiológica",
    y = "Número Total de Casos",
    fill = "Tipo de Virus",
    title = "Casos Acumulados por Semana Epidemiológica y Año"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 0, hjust = 0.5)  # Keep x-axis labels horizontal # Place facet labels (year) outside the plot
  ) +
  facet_grid(~ AÑO, scales = "free_x", space = "free_x") 
