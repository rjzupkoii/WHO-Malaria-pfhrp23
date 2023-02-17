# server.R
#
# Define the back-end functionality for the app.
library(rjson)
library(shiny)

source("plotting.R")

# Define the server logic required for the application
server <- function(input, output) {

  # TODO Replace the stub plots with the actual maps
  output$plot_innate <- renderPlot({
    plot_map(filename="../data/hrp2_scenario_maps.rds")
  })
  output$plot_composite <- renderPlot({
    plot_map(filename="../data/hrp2_scenario_maps.rds")
  })
  
}