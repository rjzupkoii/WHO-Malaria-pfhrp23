# plotting.R
#
# This file contains all of the logic associated with the generation of plots.
# We assume that the caller (i.e., server.R) will handle all of the processing
# that is specific to the web environment.
library(ggplot2)
library(magrittr)
library(sf)
library(yaml)

risk_palette <- c("#882255", "#DDCC77", "#88CCEE", "#44AA99", "#E5E4E2")

# Read in our map data once now
global_map <- readRDS("data/map.rds")

# Load the data and return the filtered map data
prepare <- function(parameters, filename) {
  # Load the data
  load(filename)

  # Filter the results based upon the parameters provided
  indices <- which(dataset$Micro.2.10 == parameters$microscopy_prevalence &
                      dataset$ft == parameters$treatment_seeking &
                      dataset$microscopy.use == parameters$microscopy_usage &
                      dataset$rdt.det == parameters$rdt_deleted &
                      dataset$rdt.nonadherence == parameters$rdt_nonadherence &
                      dataset$fitness == parameters$fitness)
  results <- subset(dataset, row.names(dataset) %in% indices)

  # Filter the results based upon the region selected
  if (parameters$region != 1) {
    results <- results[results$global_region == parameters$region, ]
  }

  # Prepare the geometry to be rendered
  geometry <- merge(x = worldmap, y = results, by.x = "id_1", by.y = "map_subregion")
  return(geometry)
}

# Load the data and return the filtered map data
choices_list_conv <- list(`1` = "best", `2` = "central", `3` = "worst")
region_list_conv <- list(`1` = "global", `2` = "africa", `3` = "asia", `4` = "latam")
prepare_new <- function(parameters, filename, risk) {
  
  geometry <-
    global_map$plot(
      Micro.2.10 = choices_list_conv[[parameters$microscopy_prevalence]],
      ft = choices_list_conv[[parameters$treatment_seeking]],
      microscopy.use = choices_list_conv[[parameters$microscopy_usage]],
      rdt.nonadherence = choices_list_conv[[parameters$rdt_nonadherence]],
      fitness = choices_list_conv[[parameters$fitness]],
      rdt.det = choices_list_conv[[parameters$rdt_deleted]], 
      region = region_list_conv[[parameters$region]],
      risk = risk,
      print = FALSE
    )

  return(geometry)
}


# Produce the HRP2 risk map
plot_risk_map <- function(parameters, data_file, language_file) {
  # Load the data
  map <- prepare_new(parameters, data_file)
  labels <- read_yaml(file(language_file))

  # Render the plot
  map %>% ggplot() +
    geom_sf(aes(fill = factor(hrp2_risk))) +
    scale_fill_manual(values = risk_palette, 
                      labels = labels[[parameters$language]]$labels, 
                      name = labels[[parameters$language]]$risk_map) +
    theme_void() +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}

# Produce the HRP2 risk map
plot_risk_map_new <- function(parameters, data_file, language_file) {
  # Load the data
  map <- prepare_new(parameters, data_file, risk = "innate")
  labels <- read_yaml(file(language_file))
  
  # Render the plot
  map +
    scale_fill_manual(values = risk_palette, 
                      labels = labels[[parameters$language]]$labels, 
                      name = labels[[parameters$language]]$risk_map) +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}

# Produce the HRP2 prospective risk map
plot_prospective_map <- function(parameters, data_file, language_file) {
  map <- prepare_new(parameters, data_file)
  labels <- read_yaml(file(language_file))
  
  map %>% ggplot() +
    geom_sf(aes(fill = factor(hrp2_prospective_risk))) +
    scale_fill_manual(values = risk_palette, 
                      labels = labels[[parameters$language]]$labels, 
                      name = labels[[parameters$language]]$prospective_map) +
    theme_void() +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}

# Produce the HRP2 prospective risk map
plot_prospective_map_new <- function(parameters, data_file, language_file) {
  map <- prepare_new(parameters, data_file, risk = "prospective")
  labels <- read_yaml(file(language_file))

  map  +
    scale_fill_manual(values = risk_palette, 
                      labels = labels[[parameters$language]]$labels, 
                      name = labels[[parameters$language]]$prospective_map) +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}

