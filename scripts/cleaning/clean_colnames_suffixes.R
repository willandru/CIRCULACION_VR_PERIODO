

clean_colnames_suffixes <- function(df) {
  # Remove suffixes of the form '...21', '...22', etc., from column names
  colnames(df) <- gsub("\\.\\.\\.[0-9]+$", "", colnames(df))
  return(df)
}

# Example usage
#tabla <- clean_colnames_suffixes(tabla)

