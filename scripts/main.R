# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")

#Declaramos variables constantes
PACKAGES <- c("dplyr", "readxl")
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
  fill_down_year("AÑO")
colnames(tabla)



#PREPROCESSING
data <- tabla %>% slice(1:32)

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
           stat = "identity") +
  
  # Line chart for % positivity with scaling applied
  geom_line(data = line_data, 
            aes(x = YearWeek, 
                y = Percent_Positivity * scaling_factor, 
                color = "Positivity Rate", 
                group = 1), 
            size = 1) +
  
  # Scale and labels with specified y-axis breaks
  scale_y_continuous(name = "NÚMERO DE CASOS POSITIVOS", 
                     limits = c(0, 700), breaks = seq(0, 700, by = 100), # Only display horizontal grid at these values
                     sec.axis = sec_axis(~ . / scaling_factor, 
                                         name = "% DE POSITIVIDAD", 
                                         breaks = seq(0, 70, by = 10))) +
  labs(x = "Período Epidemiológico", fill = NULL, color = NULL) +
  
  # Customize the grid lines
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    panel.grid.major.x = element_blank(),         # Remove vertical major grid lines
    panel.grid.minor.x = element_blank(),         # Remove vertical minor grid lines
    panel.grid.minor.y = element_blank()          # Remove minor horizontal grid lines
  )











