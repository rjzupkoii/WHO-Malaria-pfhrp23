# plotting.R
#
# This file contains all of the logic associated with the generation of plots.
# We assume that the caller (i.e., server.R) will handle all of the processing
# that is specific to the web environment.
library(magrittr)
library(ggplot2)

# Path to the data when running in an environment like RStudio
r_data_path <- "data/hrp2_scenario_maps.rds"

risk_categories <- list("best" = 1, "central" = 2, "worst" = 3)
risk_labels  <- c("High", "Moderate", "Slight", "Marginal", "No Data")
risk_palette <- c("#882255", "#DDCC77", "#88CCEE", "#44AA99", "#E5E4E2")

# Load the data and return the filtered map data
load <- function(parameters, filename) {

  # Read the data
  scenario_maps <- readRDS(filename)

  # Filter by the requested parameters
  ind <- which(scenario_maps$scenarios$prev == parameters$prev &
                 scenario_maps$scenarios$treat == parameters$treat &
                 scenario_maps$scenarios$fitness == parameters$fitness &
                 scenario_maps$scenarios$hrp3 == parameters$hrp3 &
                 scenario_maps$scenarios$nmf == parameters$nmf)

  # Update the data in the object with the correct scenario data
  map <- scenario_maps$map
  map$hrp2_risk <- scenario_maps$map_data[[ind]]$hrp2_risk
  map$hrp2_freq <- scenario_maps$map_data[[ind]]$hrp2_freq  
  return(map)
}

# Produce the HRP2 risk map
plot_risk_map <- function(parameters, filename = r_data_path) {
  map <- load(parameters, filename)
  map %>% ggplot() +
    geom_sf(aes(fill = factor(hrp2_risk))) +
    scale_fill_manual(values = risk_palette, labels = risk_labels, name = "HRP2 risk") +
    theme_void()
}

# Produce the HRP2 frequency map
plot_frequency_map <- function(parameters, filename = r_data_path) {
  map <- load(parameters, filename)
  map %>% ggplot() +
    geom_sf(aes(fill = hrp2_freq)) +
    scale_fill_distiller(palette = "Spectral", name = "HRP2 frequency") +
    theme_void()
}
