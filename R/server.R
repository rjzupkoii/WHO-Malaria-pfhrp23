# server.R
#
# Define the back-end functionality for the app.
library(rjson)
library(shiny)
library(shiny.i18n)

source("plotting.R")

# Define the path to the map data
map_data_path <- "../data/R6_map.rds"


# Function to parse the user inputs and produce the visual maps
parse_input <- function(input, output) {

  # Parse the parameters from the input
  parameters <- list(
    # Note the region to render
    region = names(risk_regions)[strtoi(input$region)],

    # Note the other settings from the UI
    treatment_seeking = names(risk_categories)[strtoi(input$treatment_seeking)],
    rdt_deleted = names(risk_categories)[strtoi(input$rdt_deleted)],
    rdt_nonadherence = names(risk_categories)[strtoi(input$rdt_nonadherence)],
    microscopy_usage = names(risk_categories)[strtoi(input$microscopy_usage)],
    microscopy_prevalence = names(risk_categories)[strtoi(input$microscopy_prevalence)],
    fitness = names(risk_categories)[strtoi(input$fitness)]
  )

  # Render the maps to the output object
  output$plot_innate <- renderPlot({
    plot_risk_map(parameters, map_data_path)
  }, height = 500, width = 500)

  output$plot_frequency <- renderPlot({
    plot_frequency_map(parameters, map_data_path)
  }, height = 500, width = 500)

  # TODO Placeholder for the composite risk map
  output$plot_composite <- renderPlot({
    plot_risk_map(parameters, map_data_path)
  }, height = 500, width = 500)
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