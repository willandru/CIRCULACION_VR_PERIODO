
# recibe un vector c("dplyr", "readxl") e installa y carga cada libreria


install_and_load_packages <- function(packages) {
  # Inicializar variable de éxito en TRUE
  success <- TRUE
  
  # Iterar sobre cada paquete en el vector de paquetes
  for (pkg in packages) {
    # Verificar si el paquete está instalado, si no, lo instala
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg)
    }
    
    # Intentar cargar el paquete, y si falla, establecer éxito en FALSE
    if (!library(pkg, character.only = TRUE, logical.return = TRUE)) {
      message(paste("No se pudo cargar el paquete:", pkg))
      success <- FALSE
    }
  }
  
  # Devolver TRUE si todos los paquetes fueron cargados exitosamente, FALSE si alguno falló
  return(success)
}