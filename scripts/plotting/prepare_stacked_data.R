

# A partir del dataset original se retorna el dataset util para la gráfica 
# de barras apiladas

# El dataset es creado para ser usado con la opcion stat = "identity" de geom_bar().
# Un dataset difereten puede ser creado para usar la opcion "count"

prepare_stacked_data <- function(data) {
  stacked_data <- data %>%
    pivot_longer(
      cols = `A(H1N1)pdm09`:`Otros_Virus`,
      names_to = "Virus_Type",
      values_to = "Cases"
    ) %>%
    mutate(YearWeek = paste(AÑO, sprintf("%02d", PERIODO_EPIDEMIOLOGICO), sep = "-"))
  
  return(stacked_data)
}
