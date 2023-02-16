# hrp23_scenarios.R
# 
# Main entry point for the R Shiny app.
library(shiny)

source('ui.R')
source('server.R')

shinyApp(ui = ui, server = server)