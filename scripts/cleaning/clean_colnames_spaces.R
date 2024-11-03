# Función para reemplazar espacios en los nombres de las columnas con guiones bajos
clean_colnames_spaces <- function(df) {
  # Replace spaces with underscores in the column names
  colnames(df) <- gsub(" ", "_", colnames(df))
  return(df)
}

# Example usage
#tabla <- clean_colnames_spaces(tabla)
