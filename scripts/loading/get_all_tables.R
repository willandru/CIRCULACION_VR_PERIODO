
# Escanea la hoja entera de excel buscando tablas.


get_all_tables <- function(file_name, sheet_name) {
  # Leer los datos de la hoja especificada en el archivo
  data <- read_excel(file_name, sheet = sheet_name)
  
  # Detectar filas y columnas en blanco
  blank_rows <- which(apply(data, 1, function(x) all(is.na(x))))
  blank_cols <- which(apply(data, 2, function(x) all(is.na(x))))
  
  # Agregar los límites de los datos como marcadores de fila/columna en blanco para asegurar que se procesen todas las secciones
  blank_rows <- c(0, blank_rows, nrow(data) + 1)
  blank_cols <- c(0, blank_cols, ncol(data) + 1)
  
  # Inicializar una lista para almacenar las tablas
  tables <- list()
  
  # Bucle sobre las secciones verticales definidas por las filas en blanco
  for (i in seq_along(blank_rows)[-length(blank_rows)]) {
    row_start <- blank_rows[i] + 1
    row_end <- blank_rows[i + 1] - 1
    if (row_start <= row_end) {
      # Extraer segmento vertical
      sub_df <- data[row_start:row_end, ]
      
      # Bucle sobre las secciones horizontales dentro de cada segmento vertical
      for (j in seq_along(blank_cols)[-length(blank_cols)]) {
        col_start <- blank_cols[j] + 1
        col_end <- blank_cols[j + 1] - 1
        if (col_start <= col_end) {
          # Extraer cada segmento de tabla
          table_part <- sub_df[, col_start:col_end] %>%
            filter(if_any(everything(), ~ !is.na(.))) %>%  # Remover filas en blanco
            select(where(~ any(!is.na(.))))  # Remover columnas en blanco
          
          # Agregar a la lista si no está vacío
          if (nrow(table_part) > 0 && ncol(table_part) > 0) {
            tables <- append(tables, list(table_part))
          }
        }
      }
    }
  }
  
  return(tables)
}
