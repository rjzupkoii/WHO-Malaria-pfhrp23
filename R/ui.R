# ui.R
#
# Define the UI for the single page application
library(magrittr)
library(markdown)
library(shiny)
library(shiny.i18n)
library(shinyBS)
library(shinycssloaders)


# Define the choice labels that will be shared
choices_list <- list("Optimistic" = 1, "Central" = 2, "Worst" = 3)

# Define our translations and default language
i18n <- Translator$new(translation_csvs_path = "../UI")
i18n$set_translation_language("en")

ui <- fluidPage(
  # Make sure the UI can react to language changes
  shiny.i18n::usei18n(i18n),

  # Import the stylesheet
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),

  # Set the main application title
  titlePanel(i18n$t("WHO hrp2/3 deletions projections")),

  # Sidebar panel for inputs
  sidebarPanel(

    bsCollapse(id = "side_panel", open = "Treatment Coverage",
      bsCollapsePanel("Treatment Coverage",
        wellPanel(
          selectInput("pr_seek_treatment",
                      label = i18n$t("Probability Seeking Treatment for Malaria Fever"),
                      choices = choices_list, selected = 2),
          selectInput("pr_treatment_rdt_outcome",
                      label = i18n$t("Probability of being treated based only on RDT outcome"),
                      choices = choices_list, selected = 1),
          helpText(includeMarkdown("../UI/treatment.md")),
          )),

      bsCollapsePanel("Malaria Prevalence",
        wellPanel(
          selectInput("malaria_prevalence",
                      label = i18n$t("Assumed malaria prevalence"),
                      choices = choices_list, selected = 3),
          helpText(uiOutput("ui_prevalence")),
          )),

      bsCollapsePanel("HRP3 Antigen Effects",
        wellPanel(
          selectInput("hrp3_antigen",
                      label = i18n$t("HRP3 Antigen Effects"),
                      choices = choices_list, selected = 2),
          helpText(includeMarkdown("../UI/antigen.md")),
        ))
    ),

    # Additional controls
    br(),
    wellPanel(
      selectInput("language",
                  label = i18n$t("Change Language"),
                  choices = list("English" = "en", "Français" = "fr"), 
                  selected = i18n$get_translation_language())
    )
  ),

  # Main panel for displaying the maps
  mainPanel(
    tabsetPanel(
      tabPanel("Innate Rank",
        plotOutput("plot_innate", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_innate")
      ),

      tabPanel("Composite Risk",
        plotOutput("plot_composite", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_composite")
      ),

      tabPanel("HRP2 Frequency",
        plotOutput("plot_frequency", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        includeMarkdown("../UI/frequency.md")
      ),

      tabPanel("Explainer", uiOutput("ui_explainer"))
    )
  )
)