# launch.R
#
# Main entry point for the R Shiny app.
library(shiny)

source("ui.R")
source("server.R")

rm(list = ls())
shinyApp(ui = ui, server = server)