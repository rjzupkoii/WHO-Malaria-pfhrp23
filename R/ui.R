# ui.R
#
# Define the UI for the single page application

library(shiny)


ui <- fluidPage(
  titlePanel("WHO hrp2/3 deletions projections"),
  
  # Sidebar panel for inputs
  sidebarPanel(
    
  ),
  
  # Main panel for displaying the maps
  mainPanel(
    tabsetPanel(
      tabPanel("Innate Rank"),
      tabPanel("Composite Risk"),
      tabPanel("Explainer", includeMarkdown("explainer.md"))
    )
  )
)