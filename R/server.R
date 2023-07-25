# server.R
#
# Define the back-end functionality for the app.
library(rjson)
library(shiny)
library(shiny.i18n)
library(yaml)

source("plotting.R")

# Define the path to the map data
data_file <- "data/data.RData"
translations_file <- "lang/translation.yml"

# Function to parse the user inputs and produce the visual maps
parse_input <- function(input, output) {
  regions_mapping <- list("Global" = 1, "Africa" = 2, "Asia" = 3, "Latin America and the Caribbean" = 4)

  # Parse the parameters from the input
  parameters <- list(
    # Note the language to render in
    language = input$language,

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
    plot_risk_map(parameters, data_file, translations_file)
  }, height = 0.7 * as.numeric(input$dimension[2]),
     width = 0.6 * as.numeric(input$dimension[1])
  )

  output$plot_prospective <- renderPlot({
    plot_prospective_map(parameters, data_file, translations_file)
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

    # Read our YAML translations
    translations <- read_yaml(file(translations_file))

    # Update the various select inputs for the drop down choices
    choices_translated <- list()
    for (ndx in 1:3) {
      choices_translated[[translations[[input$language]]$choices[[ndx]]]] <- ndx
    }
    updateSelectInput(session, "treatment_seeking", choices = choices_translated, selected = input$treatment_seeking)
    updateSelectInput(session, "rdt_deleted", choices = choices_translated, selected = input$treatment_seeking)
    updateSelectInput(session, "rdt_nonadherence", choices = choices_translated, selected = input$treatment_seeking)
    updateSelectInput(session, "microscopy_usage", choices = choices_translated, selected = input$treatment_seeking)
    updateSelectInput(session, "microscopy_prevalence", choices = choices_translated, selected = input$treatment_seeking)
    updateSelectInput(session, "fitness", choices = choices_translated, selected = input$treatment_seeking)

    # Update the region selection drop down choices
    regions_translated <- list()
    for (ndx in 1:4) {
      regions_translated[[translations[[input$language]]$regions[[ndx]]]] <- ndx
    }
    updateSelectInput(session, "region", choices = regions_translated, selected = input$region)

    # Update the various markdown texts
    output$ui_prospective <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/prospective.md", sep = ""))
    })
    output$ui_explainer <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/explainer.md", sep = ""))
    })
    output$ui_fitness <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/fitness.md", sep = ""))
    })
    output$ui_innate <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/innate.md", sep = ""))
    })
    output$ui_prevalence <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/prevalence.md", sep = ""))
    })
    output$ui_treatment <- renderUI({
      includeMarkdown(paste("lang/", input$language, "/treatment.md", sep = ""))
    })

    # Regenerate the map
    parse_input(input, output)
  })

}