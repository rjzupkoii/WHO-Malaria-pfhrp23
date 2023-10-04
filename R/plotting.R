# plotting.R
#
# This file contains all of the logic associated with the generation of plots.
# We assume that the caller (i.e., server.R) will handle all of the processing
# that is specific to the web environment.
library(ggplot2)
library(magrittr)
library(sf)
library(yaml)

# Define the palette for rendering the map
risk_palette <- c("#882255", "#DDCC77", "#88CCEE", "#44AA99", "#FFFFFF")

# Define the labels expected in the underlying data set
existing_labels <- c("High", "Moderate", "Slight", "Marginal", "No Data")

# Define the enumeration that the server can use to filter the risk data
plot_choices_enum <- list(`1` = "best", `2` = "central", `3` = "worst")
plot_regions_enum <- list(`1` = "global", `2` = "africa", `3` = "asia", `4` = "latam")

# Read the map and label data in
global_map <- readRDS("data/map.rds")

# Produce the HRP2 risk map
plot_risk_map <- function(parameters, language_file) {
  # Load the correct labels
  labels <- read_yaml(file(language_file))

  # Load the map
  map <- global_map$plot(
    Micro.2.10 = parameters$microscopy_prevalence,
    ft = parameters$treatment_seeking,
    microscopy.use = parameters$microscopy_usage,
    rdt.nonadherence = parameters$rdt_nonadherence,
    fitness = parameters$fitness,
    rdt.det = parameters$rdt_deleted,
    region = parameters$region,
    risk = "innate",
    print = FALSE
  )

  # Remove any existing scale styling
  map$scales$scales <- list()

  # Apply the styling for the app
  map +
    scale_fill_manual(values = risk_palette,
                      limits = existing_labels,
                      labels = labels[[parameters$language]]$labels,
                      name = labels[[parameters$language]]$risk_map,
                      guide = guide_legend(
                        title.position = "top",
                        title.theme = element_text(
                          size = 14,
                          face = "bold"
                        ),
                        label.theme = element_text(
                          size = 12
                        )
                      )) +
    theme(legend.position = "bottom",
          plot.margin = grid::unit(c(0, 0, 0, 0), "mm"))
}

# Produce the HRP2 prospective risk map
plot_prospective_map <- function(parameters, language_file) {
  # Load the correct labels
  labels <- read_yaml(file(language_file))

  # Load the map and apply the styling
  map <- global_map$plot(
    Micro.2.10 = parameters$microscopy_prevalence,
    ft = parameters$treatment_seeking,
    microscopy.use = parameters$microscopy_usage,
    rdt.nonadherence = parameters$rdt_nonadherence,
    fitness = parameters$fitness,
    rdt.det = parameters$rdt_deleted,
    region = parameters$region,
    risk = "prospective",
    print = FALSE
  )

  # Remove any existing scale styling
  map$scales$scales <- list()

  # Apply the styling for the app
  map  +
    scale_fill_manual(values = risk_palette, 
                      limits = existing_labels,
                      labels = labels[[parameters$language]]$labels,
                      name = labels[[parameters$language]]$prospective_map,
                      drop = FALSE,
                      guide = guide_legend(
                        title.position = "top",
                        title.theme = element_text(
                          size = 14,
                          face = "bold"
                        ),
                        label.theme = element_text(
                          size = 12
                        )
                      )) +
    theme(legend.position = "bottom",
          plot.margin = grid::unit(c(0, 0, 0, 0), "mm"))
}
