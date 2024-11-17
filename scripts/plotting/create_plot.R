source("scripts/plotting/prepare_stacked_data.R")
source("scripts/plotting/prepare_line_data.R")

# AJUSTAMOS LA MAGNITUD DESEADA DE LOS EJES 'Y' DE LA GRÁFICA
#--
Y_AXIS1_VALOR_MAX <- 700
Y__AXIS2_VALOR_MAX <- 70
scaling_factor <- Y_AXIS1_VALOR_MAX / Y__AXIS2_VALOR_MAX

Y_AXIS1_NAME <- "NÚMERO DE CASOS POSITIVOS"
X_AXIS_NAME <- "PERÍODO EPIDEMIOLÓGICO"
ANNOTATION_TEXT <- c("AÑO 2022", "AÑO 2023", "AÑO 2024")


#--
ANCHO_BARRAS <- 0.4

ANCHO_LINEA <- 0.7
COLOR_LINEA <- "#E97132"

COLOR_AXIS_TITLES <- "#595959"
COLOR_VERTICAL_LINES <- "black"

#--

COLOR_a_h1n1_pdm09 <- "#8064A2"
COLOR_a_no_subtipificado <- "#4BACC6"
COLOR_a_h3 <- "#F79646"
COLOR_influenza_b <- "#2C4D75"
COLOR_parainfluenza <- "#772C2A"
COLOR_vsr <- "#5F7530"
COLOR_adenovirus <- "#4D3B62"
COLOR_metapneumovirus <- "#2C4D75"
COLOR_rinovirus <- "#B65708"
COLOR_bocavirus <- "#729ACA"
COLOR_otros_virus <- "#4F81BD"

#--
create_plot <- function(data_full, periodo_epi) {
  subtabla <- data_full %>%
            filter((data_full$ano == 2024 & periodo_epidemiologico <= periodo_epi) | data_full$ano != 2024)
  
  stacked_data <- prepare_stacked_data(subtabla)
  line_data <- prepare_line_data(subtabla)
  
  
  
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
    
    # Y-axis: Scale and axis labels, background grid location
    scale_y_continuous(name = Y_AXIS1_NAME,
                       limits = c(-500, 700), breaks = seq(0, 700, by = 100),
                       sec.axis = sec_axis(~ . / scaling_factor, 
                                           breaks = seq(0, 70, by = 10), 
                                           labels = function(x) sprintf("%.1f", x))
    ) +
    
    scale_x_discrete(labels = tabla$periodo_epidemiologico) +
    
    # Custom color scale for virus types
    scale_fill_manual(values = c(
      "a_h1n1_pdm09" = COLOR_a_h1n1_pdm09,
      "a_no_subtipificado" = COLOR_a_no_subtipificado,
      "a_h3" = COLOR_a_h3,
      "influenza_b" = COLOR_influenza_b,
      "parainfluenza" = COLOR_parainfluenza,
      "vsr" = COLOR_vsr,
      "adenovirus" = COLOR_adenovirus,
      "metapneumovirus" = COLOR_metapneumovirus,
      "rinovirus" = COLOR_rinovirus,
      "bocavirus" = COLOR_bocavirus,
      "otros_virus" = COLOR_otros_virus
    )) +
    
    labs(x = X_AXIS_NAME, fill = NULL, color = NULL) +
    
    # Customize the grid lines and other theme elements
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 0, size = 7, margin = margin(t = -255, b = -5)),
      axis.title.x = element_text(margin = margin(t = 20, b = -10), size = 8, face = "bold", color = COLOR_AXIS_TITLES),
      axis.title.y = element_text(hjust = 0.75, size = 8, face = "bold", color = COLOR_AXIS_TITLES),
      panel.grid.major.x = element_blank(),         # Remove vertical major grid lines
      panel.grid.minor.x = element_blank(),         # Remove vertical minor grid lines
      panel.grid.minor.y = element_blank(),
      legend.position = "bottom",
      legend.key.size = unit(1.2, "lines"),
      legend.key.height = unit(0.02, "lines"),
      legend.text = element_text(size = 7)
    ) +
    
    # Add vertical lines with adjustable height using geom_segment
    geom_segment(aes(x = 13.5, xend = 13.5, y = -25, yend = 700), color = COLOR_VERTICAL_LINES, linewidth = 0.65) +
    geom_segment(aes(x = 26.5, xend = 26.5, y = -25, yend = 700), color = COLOR_VERTICAL_LINES, linewidth = 0.65) +
    
    # Annotations
    annotate("text", x = c(6, 19, 31), y = -35, label = ANNOTATION_TEXT, size = 2.4, fontface = "bold") +
    
    guides(
      fill = guide_legend(
        nrow = 3,
        byrow = TRUE
      ),
      color = "none"
    ) +
    
    annotate("segment", x = 21, xend = 22.2, y = -150, yend = -150, color = "#E97132", linewidth = 0.7) +
    annotate("text", x = 22.5, y = -150, label = "% DE POSITIVIDAD", hjust = 0, color = "black", size = 2)
}
