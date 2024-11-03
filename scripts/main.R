# Cargamos las funciones
source("scripts/utils/load_libraries.R")
source("scripts/loading/get_all_tables.R")
source("scripts/loading/print_all_tables.R")
source("scripts/loading/get_selected_table.R")
source("scripts/cleaning/fill_down_year.R")
source("scripts/cleaning/clean_colnames_suffixes.R")
source("scripts/cleaning/clean_colnames_spaces.R")

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

# VISUALIZING


# Assuming `tabla` has been cleaned and prepared as per your code.
data <- tabla %>% slice(1:32) # Select the relevant rows

# Reshape the data to long format for stacked bars
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

# Calculate the scaling factor for dual y-axes
scaling_factor <- max(stacked_data$Cases, na.rm = TRUE) / max(line_data$Percent_Positivity, na.rm = TRUE)

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
  
  # Scale and labels
  scale_y_continuous(name = "NÚMERO DE CASOS POSITIVOS", 
                     sec.axis = sec_axis(~ . / scaling_factor, 
                                         name = "% DE POSITIVIDAD")) +
  labs(x = "Período Epidemiológico", fill = "Virus Type", color = "Positivity Rate") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # Rotate x-axis labels for better readability
