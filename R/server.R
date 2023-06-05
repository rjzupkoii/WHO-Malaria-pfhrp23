# server.R
#
# Define the back-end functionality for the app.
library(rjson)
library(shiny)
library(shiny.i18n)

source("plotting.R")

# Define the path to the map data
map_data_path <- "../data/data.RData"

# Function to parse the user inputs and produce the visual maps
parse_input <- function(input, output) {
  regions_mapping <- list("Global" = 1, "Africa" = 2, "Asia" = 3, "Latin America and the Caribbean" = 4)
  
  # Parse the parameters from the input
  parameters <- list(
    # Note the region to render
    region = names(regions_mapping)[strtoi(input$region)],

    # Note the other settings from the UI
    treatment_seeking = strtoi(input$treatment_seeking),
    rdt_deleted = strtoi(input$rdt_deleted),
    rdt_nonadherence = strtoi(input$rdt_nonadherence),
    microscopy_usage = strtoi(input$microscopy_usage),
    microscopy_prevalence = strtoi(input$microscopy_prevalence),
    fitness = strtoi(input$fitness)
  )

  # Render the maps to the output object
  output$plot_innate <- renderPlot({
    plot_risk_map(parameters, map_data_path)
  }, height = 0.7 * as.numeric(input$dimension[2]),
     width = 0.6 * as.numeric(input$dimension[1])
  )
  
  output$plot_composite <- renderPlot({
    plot_composite_map(parameters, map_data_path)
  }, height = 0.7 * as.numeric(input$dimension[2]),
     width = 0.6 * as.numeric(input$dimension[1])
  )
}

# Define the server logic required for the application
server <- function(input, output, session) {

  # The following observers all listen for changes in the form
  observeEvent(input$treatment_seeking, {
    parse_input(input, output)
  })
  observeEvent(input$rdt_deleted, {
    parse_input(input, output)
  })
  observeEvent(input$rdt_nonadherence, {
    parse_input(input, output)
  })
  observeEvent(input$microscopy_usage, {
    parse_input(input, output)
  })
  observeEvent(input$microscopy_prevalence, {
    parse_input(input, output)
  })
  observeEvent(input$fitness, {
    parse_input(input, output)
  })
  observeEvent(input$region, {
    parse_input(input, output)
  })
  observeEvent(input$dimension, {
    parse_input(input, output)
  })

  # The following observer changes the UI based on the language selected
  observeEvent(input$language, {
    shiny.i18n::update_lang(input$language)

    # Update the various markdown texts
    output$ui_antigen <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/antigen.md", sep = ""))
    })
    output$ui_composite <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/composite.md", sep = ""))
    })
    output$ui_explainer <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/explainer.md", sep = ""))
    })
    output$ui_frequency <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/frequency.md", sep = ""))
    })
    output$ui_innate <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/innate.md", sep = ""))
    })
    output$ui_prevalence <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/prevalence.md", sep = ""))
    })
    output$ui_treatment <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/treatment.md", sep = ""))
    })
  })

}