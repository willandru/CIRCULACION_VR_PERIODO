

# A partir del dataset original se retorna el dataset util para la 
# gráfica de la linea de tendencia

prepare_line_data <- function(data) {
  line_data <- data %>%
    mutate(YearWeek = paste(ano, sprintf("%02d", periodo_epidemiologico), sep = "-")) %>%
    select(YearWeek, Percent_Positivity = percent_de_positividad) %>%
    drop_na(Percent_Positivity) # Remove any NA values in Percent_Positivity
  
  return(line_data)
}














