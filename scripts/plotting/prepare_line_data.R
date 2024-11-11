

# A partir del dataset original se retorna el dataset util para la 
# gráfica de la linea de tendencia

prepare_line_data <- function(data) {
  line_data <- data %>%
    mutate(YearWeek = paste(AÑO, sprintf("%02d", PERIODO_EPIDEMIOLOGICO), sep = "-")) %>%
    select(YearWeek, Percent_Positivity = `%_DE_POSITIVIDAD`) %>%
    drop_na(Percent_Positivity) # Remove any NA values in Percent_Positivity
  
  return(line_data)
}














