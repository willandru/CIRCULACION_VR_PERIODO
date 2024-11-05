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
    "A(H1N1)pdm09" = "#0F9ED5",       # Light blue for A(H1N1)pdm09
    "A_no_subtipificado" = "#A02B93", # Purple for A no subtipificado
    "A(H3)" = "#4EA72E",              # Green for A(H3)
    "Influenza__B" = "#0D3A4E",       # Dark gray for Influenza B
    "Adenovirus" = "#095F80",         # Dark teal for Adenovirus
    "Metapneumovirus" = "#601A58",    # Dark purple for Metapneumovirus
    "Rinovirus" = "#2F641C",          # Dark green for Rinovirus
    "Bocavirus" = "#1F8EC0",          # Blue for Bocavirus
    "Otros_Virus" = "#156082",        # Blue for Otros Virus
    "Parainfluenza" = "#994010",      # Brown for Parainfluenza
    "VSR" = "#0F4016",                # Dark green for VSR
    "nueva_columna" = "black"         # Black for nueva_columna (appears as line in legend)
  ))+
  labs(x = "PERÍODO EPIDEMIOLÓGICO", fill = NULL, color = NULL) +
  
  # Customize the grid lines
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 0,size=6,  margin = margin(t = -215)),
    axis.title.x = element_text(margin = margin(t = 20), size = 8, face = "bold", color = "#595959"),
    axis.title.y = element_text(hjust = 0.8, size = 8, face = "bold", color = "#595959"),
    panel.grid.major.x = element_blank(),         # Remove vertical major grid lines
    panel.grid.minor.x = element_blank(),         # Remove vertical minor grid lines
    panel.grid.minor.y = element_blank(),
    legend.position = "bottom",
    legend.key.size = unit(1.2, "lines"),            # Adjust the size of the legend items
    legend.text = element_text(size = 8)
  )+
  # Agregar líneas verticales con altura ajustable usando geom_segment
  geom_segment(aes(x = 13.5, xend = 13.5, y = -45, yend = 690), color = "black", linewidth = 1.2) +
  geom_segment(aes(x = 26.5, xend = 26.5, y = -45, yend = 690), color = "black", linewidth = 1.2) +
  annotate("text", x = c(6.5, 19.5, 30), y = -50, label = c("AÑO 2022", "AÑO 2023", "AÑO 2024"), size = 2.6, fontface = "bold") +
  guides(
    fill = guide_legend(
      nrow = 2,
      byrow = TRUE
      ),
    color = "none") + 
  annotate("segment", x = 25.8, xend = 26.8, y = -225, yend = -225, color = "#E97132", linewidth = 1) +
  annotate("text", x = 27.2, y = -220, label = "% DE POSITIVIDAD", hjust = 0, color = "black", size= 2.4) 






  


