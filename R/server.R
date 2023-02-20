# server.R
#
# Define the back-end functionality for the app.
library(rjson)

source("plotting.R")
source("shared.R")

parse_input <- function(input) {
  parameters <- c(
    names(choices_list)[strtoi(input$pr_seek_treatment)],
    names(choices_list)[strtoi(input$pr_treatment_rdt_outcome)],
    names(choices_list)[strtoi(input$malaria_prevalence)],
    names(choices_list)[strtoi(input$hrp3_antigen)]
  )

  # TODO Hand off to rendering
  print(parameters)
}

# Define the server logic required for the application
server <- function(input, output) {

  # The following observers all listen for changes in the form
  observeEvent(input$pr_seek_treatment, {
    parse_input(input)
  })
  observeEvent(input$pr_treatment_rdt_outcome, {
    parse_input(input)
  })
  observeEvent(input$malaria_prevalence, {
    parse_input(input)
  })
  observeEvent(input$hrp3_antigen, {
    parse_input(input)
  })

  # TODO Replace the stub plots with the actual maps
  output$plot_innate <- renderPlot({
    plot_map(filename="../data/hrp2_scenario_maps.rds")
  })
  output$plot_composite <- renderPlot({
    plot_map(filename="../data/hrp2_scenario_maps.rds")
  })

}