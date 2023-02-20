# server.R
#
# Define the back-end functionality for the app.
library(rjson)

source("plotting.R")

parse_input <- function(input, output) {
  parameters <- list(
    prev = names(risk_categories)[strtoi(input$malaria_prevalence)],
    treat = names(risk_categories)[strtoi(input$pr_seek_treatment)],
    fitness = names(risk_categories)[strtoi(input$pr_treatment_rdt_outcome)],
    hrp3 = names(risk_categories)[strtoi(input$hrp3_antigen)]
  )

  # TODO Replace the stub plots with the actual maps
  output$plot_innate <- renderPlot({
    plot_map(
      prev = parameters$prev,
      treat = parameters$treat,
      fitness = parameters$fitness,
      hrp3 = parameters$hrp3,
      filename = "../data/hrp2_scenario_maps.rds")
  })
  output$plot_composite <- renderPlot({
    plot_map(filename = "../data/hrp2_scenario_maps.rds")
  })
}

# Define the server logic required for the application
server <- function(input, output) {

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

}