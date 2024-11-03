# Toma una lista de tablas de la función 'get_all_tables' y las imprime en pantalla sin devolverlas
display_tables <- function(tables) {
  # Bucle sobre cada tabla en la lista de entrada
  for (i in seq_along(tables)) {
    # Imprimir el título para cada tabla
    cat(paste("Tabla", i, ":\n"))
    # Imprimir el contenido de cada tabla
    print(tables[[i]])
  }
  
  return(invisible(NULL))
  
}

# Ejemplo de uso
# Suponiendo que tables es una lista de tablas generada previamente por get_all_tables
# tables <- list(table1_data, table2_data, table3_data)
# display_tables(tables)  # Solo imprime las tablas sin devolver nada
