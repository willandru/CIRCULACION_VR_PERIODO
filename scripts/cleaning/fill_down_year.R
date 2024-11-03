source("scripts/utils/load_libraries.R")
PACKAGES <- c("dplyr", "tidyr")
install_and_load_packages(PACKAGES)

# Definir la función
fill_down_year <- function(df, column_name) {
  # Rellenar los valores NA en la columna especificada
  df <- df %>%
    fill({{ column_name }}, .direction = "down")
  
  # Devolver el data frame limpio
  return(df)
}

# Ejemplo de uso
# cleaned_df <- fill_na_column(df, AÑO) # Usa el nombre real de la columna sin comillas
