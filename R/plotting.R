# plotting.R
#
# This file contains all of the logic associated with the generation of plots.
# We assume that the caller (i.e., server.R) will handle all of the processing
# that is specific to the web environment.
library(magrittr)
library(ggplot2)

# Path to the data when running in an environment like RStudio
r_data_path <- "data/data.RData"

risk_labels  <- c("High", "Moderate", "Slight", "Marginal", "No Data")
risk_palette <- c("#882255", "#DDCC77", "#88CCEE", "#44AA99", "#E5E4E2")

# Load the data and return the filtered map data
prepare <- function(parameters, filename) {
  # Load the data
  load(filename)  

  # Filter the results based upon the parameters provided
  indicies <- which(dataset$Micro.2.10 == parameters$microscopy_prevalence &
                      dataset$ft == parameters$treatment_seeking &
                      dataset$microscopy.use == parameters$microscopy_usage &
                      dataset$rdt.det == parameters$rdt_deleted &
                      dataset$rdt.nonadherence == parameters$rdt_nonadherence &
                      dataset$fitness == parameters$fitness)
  results <- subset(dataset, row.names(dataset) %in% indicies)
  
  # Filter the results based upon the region selected
  if (parameters$region != "Global") {
    region <- regions[[which(regions$names == parameters$region)]]
    results <- subset(results, results$iso %in% region$iso3n)
  }
  
  # Prepare the geometry to be rendered
  geometry <- merge(x = countries, y = results, by.x = "ISO_N3", by.y = "iso")
  return(geometry)
}

# Produce the HRP2 risk map
plot_risk_map <- function(parameters, filename = r_data_path) {
  map <- prepare(parameters, filename)
  map %>% ggplot() +
    geom_sf(aes(fill = factor(hrp2_risk))) +
    scale_fill_manual(values = risk_palette, labels = risk_labels, name = "HRP2 risk") +
    theme_void() +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}

# Produce the HRP2 composite risk map
plot_composite_map <- function(parameters, filename = r_data_path) {
  map <- prepare(parameters, filename)
  map %>% ggplot() +
    geom_sf(aes(fill = factor(hrp2_composite_risk))) +
    scale_fill_manual(values = risk_palette, labels = risk_labels, name = "HRP2 Composite Risk") +
    theme_void() +
    theme(legend.position = "bottom",
          plot.margin=grid::unit(c(0,0,0,0), "mm"))
}
