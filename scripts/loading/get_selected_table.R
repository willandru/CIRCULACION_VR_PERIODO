# Función para extraer una tabla específica de la lista y devolverla como data.frame
get_selected_table <- function(tables, INDICADOR) {
  # Verificar que 'tables' es una lista
  if (!is.list(tables)) {
    stop("El argumento 'tables' debe ser una lista de tablas.")
  }
  
  # Verificar que el INDICADOR es válido
  if (INDICADOR < 1 || INDICADOR > length(tables)) {
    stop("El INDICADOR está fuera del rango de las tablas disponibles.")
  }
  
  # Extraer la tabla especificada
  selected_table <- tables[[INDICADOR]]
  
  # Asegurarse de que la tabla es un data.frame o convertirla en uno si es necesario
  if (!is.data.frame(selected_table)) {
    selected_table <- as.data.frame(selected_table)
  }
  
  # Devolver la tabla seleccionada como data.frame
  return(selected_table)
}

# Ejemplo de uso
#INDICADOR <- 2 # Seleccionar el número de la tabla que se desea utilizar
#selected_table <- get_selected_table(tables, INDICADOR)