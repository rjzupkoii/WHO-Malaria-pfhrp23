# server.R
#
# Define the back-end functionality for the app.
library(rjson)
library(shiny)
library(shiny.i18n)

source("plotting.R")

# Define the path to the map data
map_data_path <- "../data/hrp2_scenario_maps.rds"


# Function to parse the user inputs and produce the visual maps
parse_input <- function(input, output) {
  # Parse the parameters from the input
  parameters <- list(
    prev = names(risk_categories)[strtoi(input$malaria_prevalence)],
    treat = names(risk_categories)[strtoi(input$pr_seek_treatment)],
    fitness = names(risk_categories)[strtoi(input$pr_treatment_rdt_outcome)],
    hrp3 = names(risk_categories)[strtoi(input$hrp3_antigen)],

    # Placeholder value for non-malarial fever
    nmf = "central"
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

  # Set the translation object
  i18n <- Translator$new(translation_csvs_path = "../UI")
  i18n$set_translation_language("en")

  # The following observers all listen for changes in the form
  observeEvent(input$pr_seek_treatment, {
    parse_input(input, output)
  })
  observeEvent(input$pr_treatment_rdt_outcome, {
    parse_input(input, output)
  })
  observeEvent(input$malaria_prevalence, {
    parse_input(input, output)
  })
  observeEvent(input$hrp3_antigen, {
    parse_input(input, output)
  })

  # The following observer changes the UI based on the language selected
  observeEvent(input$language, {
    print(paste("Changing language: ", input$language))
    shiny.i18n::update_lang(input$language)

    # Update the various markdown texts
    output$ui_composite <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/composite.md", sep = ""))
    })
    output$ui_explainer <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/explainer.md", sep = ""))
    })
    output$ui_innate <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/innate.md", sep = ""))
    })
    output$ui_prevalence <- renderUI({
      includeMarkdown(paste("../UI/", input$language, "/prevalence.md", sep = ""))
    })
  })

}