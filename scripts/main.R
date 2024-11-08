# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")

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


#PREPROCESSING
data <- tabla 

stacked_data <- data %>%
  pivot_longer(cols = `A(H1N1)pdm09`:`Otros_Virus`, 
               names_to = "Virus_Type", 
               values_to = "Cases") %>%
  mutate(YearWeek = paste(AÑO, sprintf("%02d", PERIODO_EPIDEMIOLOGICO), sep = "-"))
# Prepare line data for the line chart, ensuring YearWeek is created consistently
line_data <- data %>%
  mutate(YearWeek = paste(AÑO, sprintf("%02d", PERIODO_EPIDEMIOLOGICO), sep = "-")) %>%
  select(YearWeek, Percent_Positivity = `%_DE_POSITIVIDAD`) %>%
  drop_na(Percent_Positivity) # Remove any NA values in Percent_Positivity



# VISUALIZING

# Calculate the scaling factor for dual y-axes
scaling_factor <- 700 / 70 # Scale Cases to match a max of 700 on the left and 70% on the right
# Plot the figure
ggplot() +
  # Stacked bar chart
  geom_bar(data = stacked_data, 
           aes(x = YearWeek, y = Cases, fill = Virus_Type), 
           stat = "identity",
           width = 0.4) +
  
  # Line chart for % positivity with scaling applied
  geom_line(data = line_data, 
            aes(x = YearWeek, 
                y = Percent_Positivity * scaling_factor, 
                color = "Positivity Rate", 
                group = 1),
            color = "#E97132",
            linewidth = 0.7) +
  
  # Scale and labels with specified y-axis breaks
  scale_y_continuous(name = "NÚMERO DE CASOS POSITIVOS",
                     limits = c(-500, 700), breaks = seq(0, 700, by = 100),
                     sec.axis = sec_axis(~ . / scaling_factor, 
                                         breaks = seq(0, 70, by = 10), 
                                         labels = function(x) sprintf("%.1f", x))
  ) +
  scale_x_discrete(labels = tabla$PERIODO_EPIDEMIOLOGICO)+
  scale_fill_manual(values = c(
    "A(H1N1)pdm09" = "#8064A2",       # Light blue for A(H1N1)pdm09
    "A_no_subtipificado" = "#4BACC6", # Purple for A no subtipificado
    "A(H3)" = "#F79646",              # Green for A(H3)
    "Influenza__B" = "#2C4D75",       # Dark gray for Influenza B
    "Adenovirus" = "#4D3B62",         # Dark teal for Adenovirus
    "Metapneumovirus" = "#2C4D75",    # Dark purple for Metapneumovirus
    "Rinovirus" = "#B65708",          # Dark green for Rinovirus
    "Bocavirus" = "#729ACA",          # Blue for Bocavirus
    "Otros_Virus" = "#4F81BD",        # Blue for Otros Virus
    "Parainfluenza" = "#772C2A",      # Brown for Parainfluenza
    "VSR" = "#5F7530",                # Dark green for VSR
    "nueva_columna" = "black"         # Black for nueva_columna (appears as line in legend)
  ))+
  labs(x = "PERÍODO EPIDEMIOLÓGICO", fill = NULL, color = NULL) +
  
  # Customize the grid lines
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 0,size=7,  margin = margin(t = -255, b=-5)),
    axis.title.x = element_text(margin = margin(t = 20, b=-10), size = 8, face = "bold", color = "#595959"),
    axis.title.y = element_text(hjust = 0.75, size = 8, face = "bold", color = "#595959"),
    panel.grid.major.x = element_blank(),         # Remove vertical major grid lines
    panel.grid.minor.x = element_blank(),         # Remove vertical minor grid lines
    panel.grid.minor.y = element_blank(),
    legend.position = "bottom",
    legend.key.size = unit(1.2, "lines"),
    legend.key.height = unit(0.02, "lines"),
    legend.text = element_text(size = 7)
  )+
  # Agregar líneas verticales con altura ajustable usando geom_segment
  geom_segment(aes(x = 13.5, xend = 13.5, y = -25, yend = 700), color = "black", linewidth = 0.65) +
  geom_segment(aes(x = 26.5, xend = 26.5, y = -25, yend = 700), color = "black", linewidth = 0.65) +
  annotate("text", x = c(6, 19, 31), y = -35, label = c("AÑO 2022", "AÑO 2023", "AÑO 2024"), size = 2.4, fontface = "bold") +
  guides(
    fill = guide_legend(
      nrow = 3,
      byrow = TRUE
    ),
    color = "none") + 
  annotate("segment", x = 21, xend = 22.2, y = -150, yend = -150, color = "#E97132", linewidth = 0.7) +
  annotate("text", x = 22.5, y = -150, label = "% DE POSITIVIDAD", hjust = 0, color = "black", size= 2) 



