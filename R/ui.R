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

  # Add the i18n class and translation key to the bsCollapsePanel
  HTML('<script>
       $(document).on("shiny:sessioninitialized", function(event) {
          $("a[id^=\'ui-collapse\']").each(function() {
            $(this).addClass("i18n");
            $(this).attr("data-key", $(this).text());
          });
       });
       </script>'),

  tags$head(
    # Import the stylesheet
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),

    # Don't load a favicon
    tags$link(rel = "icon", href = "data:;base64,=")
  ),

  # Set the main application title
  titlePanel(i18n$t("WHO hrp2/3 deletions projections"),
             windowTitle = "WHO hrp2/3 deletions projections"),

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
          helpText(uiOutput("ui_treatment")),
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
          helpText(uiOutput("ui_antigen")),
        ))
    ),

    # Additional controls
    br(),
    wellPanel(
      selectInput("language",
                  label = i18n$t("Change Language"),
                  choices = list("English" = "en", 
                                 "Français" = "fr",
                                 "Español" = "es"),
                  selected = i18n$get_translation_language())
    )
  ),

  # Main panel for displaying the maps
  mainPanel(
    tabsetPanel(
      tabPanel(i18n$t("Description"), uiOutput("ui_explainer")),
      
      tabPanel(i18n$t("Innate Rank"),
        plotOutput("plot_innate", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_innate")
      ),

      tabPanel(i18n$t("Composite Risk"),
        plotOutput("plot_composite", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_composite")
      ),

      tabPanel(i18n$t("HRP2 Frequency"),
        plotOutput("plot_frequency", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_frequency")
      )

    )
  )
)