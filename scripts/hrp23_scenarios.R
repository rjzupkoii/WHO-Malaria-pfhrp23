# hrp23_scenarios.R
# 
# Main entry point for the R Shiny app.
library(shiny)

# Define the UI for the single page application
ui <- fluidPage(
  titlePanel("WHO hrp2/3 deletions projections"),
  
  # Sidebar panel for inputs
  sidebarPanel(
    
  ),
  
  # Main panel for displaying the maps
  mainPanel(
    
  )
)

# Define the server logic required for the application
server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)