# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")
source("scripts/plotting/prepare_stacked_data.R")
source("scripts/plotting/prepare_line_data.R")

#Declaramos variables constantes
PACKAGES <- c("dplyr", "readxl", "ggplot2")
FILE_NAME <- "data/VIRUS RESPIRATORIO 2022 A 2024.xlsx"
SHEET_NAME <- "POR PERIODO"
INDICADOR <- 2 #Sleccionar el numero de la tabla que se desea utilizar.


# LOADING
install_and_load_packages(PACKAGES)
tables <- get_all_tables(FILE_NAME, SHEET_NAME)
tabla <- get_selected_table(tables, INDICADOR)


# CLEANING
tabla <- tabla %>%
  clean_colnames_suffixes() %>%
  clean_colnames_spaces() %>%
  fill_down_year("AÑO") %>% 
  slice(1:32)


#PREPROCESSING FOR VISUALIZATION
data <- tabla 

stacked_data <- prepare_stacked_data(data)
line_data <- prepare_line_data(data)




# VISUALIZING


# AJUSTAMOS LA MAGNITUD DESEADA DE LOS EJES 'Y' DE LA GRÁFICA
EJEY_NUM_CASOS_VALOR_MAX <- 700
EJEY_PORC_POSI_VALOR_MAX <- 70
scaling_factor <- EJEY_NUM_CASOS_VALOR_MAX / EJEY_PORC_POSI_VALOR_MAX

#OTRAS CONSTANTE4S

ANCHO_BARRAS <- 0.4
COLOR_AH1N1pdm09 <- "#8064A2"
COLOR_A_no_subtipificado <- "#4BACC6"
COLOR_AH3 <- "#F79646"
COLOR_Influenza__B <- "#2C4D75"
COLOR_Adenovirus <- "#4D3B62"
COLOR_Metapneumovirus <- "#2C4D75"
COLOR_Rinovirus <- "#B65708"
COLOR_Bocavirus <- "#729ACA"
COLOR_Otros_Virus <- "#4F81BD"
COLOR_Parainfluenza <- "#772C2A"
COLOR_VSR <- "#5F7530"


ANCHO_LINEA <- 0.7
COLOR_LINEA <- "#E97132"


COLOR_AXIS_TITLES <- "#595959"
COLOR_VERTICAL_LINES <- "black"

ggplot() +
  # Stacked bar chart
  geom_bar(data = stacked_data, 
           aes(x = YearWeek, y = Cases, fill = Virus_Type), 
           stat = "identity",
           width = ANCHO_BARRAS) +
  
  # Line chart for % positivity with scaling applied
  geom_line(data = line_data, 
            aes(x = YearWeek, 
                y = Percent_Positivity * scaling_factor, 
                color = "Positivity Rate", 
                group = 1),
            color = COLOR_LINEA,
            linewidth = ANCHO_LINEA) +
  
  # EJE Y: Escala y nombres de los ejes. Ubicacion de la grilla de fondo
  scale_y_continuous(name = "NÚMERO DE CASOS POSITIVOS",
                     limits = c(-500, 700), breaks = seq(0, 700, by = 100),
                     sec.axis = sec_axis(~ . / scaling_factor, 
                                         breaks = seq(0, 70, by = 10), 
                                         labels = function(x) sprintf("%.1f", x))
  ) +
  
  
  scale_x_discrete(labels = tabla$PERIODO_EPIDEMIOLOGICO)+
  
  
  scale_fill_manual(values = c(
    "A(H1N1)pdm09" = COLOR_AH1N1pdm09,
    "A_no_subtipificado" = COLOR_A_no_subtipificado,
    "A(H3)" = COLOR_AH3,
    "Influenza__B" = COLOR_Influenza__B,
    "Adenovirus" = COLOR_Adenovirus,
    "Metapneumovirus" = COLOR_Metapneumovirus,
    "Rinovirus" = COLOR_Rinovirus,
    "Bocavirus" = COLOR_Bocavirus,
    "Otros_Virus" = COLOR_Otros_Virus,
    "Parainfluenza" = COLOR_Parainfluenza,
    "VSR" = COLOR_VSR,
    "nueva_columna" = COLOR_nueva_columna
  ))+
  
  
  labs(x = "PERÍODO EPIDEMIOLÓGICO", fill = NULL, color = NULL) +
  
  
  
  
  
  
  # Customize the grid lines
  theme_minimal() +
  
  
  theme(
    axis.text.x = element_text(angle = 0,size=7,  margin = margin(t = -255, b=-5)),
    axis.title.x = element_text(margin = margin(t = 20, b=-10), size = 8, face = "bold", color = COLOR_AXIS_TITLES),
    axis.title.y = element_text(hjust = 0.75, size = 8, face = "bold", color = COLOR_AXIS_TITLES),
    
    
    
    panel.grid.major.x = element_blank(),         # Remove vertical major grid lines
    panel.grid.minor.x = element_blank(),         # Remove vertical minor grid lines
    panel.grid.minor.y = element_blank(),
    legend.position = "bottom",
    
    
    
    legend.key.size = unit(1.2, "lines"),
    legend.key.height = unit(0.02, "lines"),
    legend.text = element_text(size = 7)
  )+
  
  
  # Agregar líneas verticales con altura ajustable usando geom_segment
  geom_segment(aes(x = 13.5, xend = 13.5, y = -25, yend = 700), color = COLOR_VERTICAL_LINES, linewidth = 0.65) +
  geom_segment(aes(x = 26.5, xend = 26.5, y = -25, yend = 700), color = COLOR_VERTICAL_LINES, linewidth = 0.65) +
  
  
  
  annotate("text", x = c(6, 19, 31), y = -35, label = c("AÑO 2022", "AÑO 2023", "AÑO 2024"), size = 2.4, fontface = "bold") +
  
  
  guides(
    fill = guide_legend(
      nrow = 3,
      byrow = TRUE
    ),
    color = "none") + 
  
  
  
  annotate("segment", x = 21, xend = 22.2, y = -150, yend = -150, color = "#E97132", linewidth = 0.7) +
  annotate("text", x = 22.5, y = -150, label = "% DE POSITIVIDAD", hjust = 0, color = "black", size= 2) 



