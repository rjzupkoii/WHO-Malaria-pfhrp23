# ui.R
#
# Define the UI for the single page application
library(magrittr)
library(markdown)
library(shiny)
library(shinyBS)
library(shinycssloaders)

# Define the choice labels that will be shared
choices_list <- list("Optimistic" = 1, "Central" = 2, "Worst" = 3)

ui <- fluidPage(
  # Import the stylesheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  # Set the main application title
  titlePanel("WHO hrp2/3 deletions projections"),

  # Sidebar panel for inputs
  sidebarPanel(

    bsCollapse(id = "side_panel", open = "Treatment Coverage",
      bsCollapsePanel("Treatment Coverage",
        wellPanel(
          selectInput("pr_seek_treatment",
                      label = "Probability Seeking Treatment for Malaria Fever",
                      choices = choices_list, selected = 2),
          selectInput("pr_treatment_rdt_outcome",
                      label = "Probability of being treated based only on RDT outcome",
                      choices = choices_list, selected = 1),
          helpText(includeMarkdown("../UI/treatment.md")),
          )),

      bsCollapsePanel("Malaria Prevalence",
        wellPanel(
          selectInput("malaria_prevalence",
                      label = "Assumed malaria prevalence",
                      choices = choices_list, selected = 3),
          helpText(includeMarkdown("../UI/prevalence.md")),
          )),

      bsCollapsePanel("HRP3 Antigen Effects",
        wellPanel(
          selectInput("hrp3_antigen",
                      label = "HRP3 Antigen Effects",
                      choices = choices_list, selected = 2),
          helpText(includeMarkdown("../UI/antigen.md")),
        ))
    ),

    # Reserving this space for more controls
    br(),
    wellPanel("Controls Placeholder"
    )
  ),

  # Main panel for displaying the maps
  mainPanel(
    tabsetPanel(
      tabPanel("Innate Rank",
        plotOutput("plot_innate", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        includeMarkdown("../UI/innate.md")
      ),

      tabPanel("Composite Risk",
        plotOutput("plot_composite", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        includeMarkdown("../UI/composite.md")
      ),

      tabPanel("HRP2 Frequency",
        plotOutput("plot_frequency", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        includeMarkdown("../UI/frequency.md")
      ),

      tabPanel("Explainer", includeMarkdown("../UI/explainer.md"))
    )
  )
)