# plotting.R
#
# This file contains all of the logic associated with the generation of plots. 
# We assume that the caller (i.e., server.R) will handle all of the processing
# that is specific to the web environment.
library(ggplot2)

risk_palette = c('#882255', '#DDCC77', '#88CCEE', '#44AA99', '#E5E4E2')
risk_labels  = c('High', 'Moderate', 'Slight', 'Marginal', 'No Data')

plot_map <- function(prev = "central",
                     treat = "central",
                     fitness = "central",
                     hrp3 = "central",
                     nmf = "central",
                     filename = "data/hrp2_scenario_maps.rds") {
  
  # Read the data
  scenario_maps <- readRDS(filename)
  
  # Filter by the requested parameters
  ind <- which(scenario_maps$scenarios$prev == prev &
                 scenario_maps$scenarios$treat == treat &
                 scenario_maps$scenarios$fitness == fitness &
                 scenario_maps$scenarios$hrp3 == hrp3 &
                 scenario_maps$scenarios$nmf == nmf)
  
  # Update the data in the object with the correct scenario data
  map <- scenario_maps$map
  map$hrp2_risk <- scenario_maps$map_data[[ind]]$hrp2_risk
  map$hrp2_freq <- scenario_maps$map_data[[ind]]$hrp2_freq
  
  # Produce the hrp2_risk map
  map %>% ggplot() + 
    geom_sf(aes(fill = factor(hrp2_risk))) + 
    scale_fill_manual(values = risk_palette, labels = risk_labels, name = "hrp3 risk") + 
    theme_void()
}
