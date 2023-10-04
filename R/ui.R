# ui.R
#
# Define the UI for the single page application
library(magrittr)
library(markdown)
library(shiny)
library(shiny.i18n)
library(shinyBS)
library(shinycssloaders)

# Define the choices and regions lists in the default language
choices_list_en <- list("Optimistic" = 1, "Central" = 2, "Worst" = 3)
regions_list_en <- list("Global" = 1, "Africa" = 2, "Asia" = 3, "Latin America" = 4)


# Define our translations and default language
i18n <- Translator$new(translation_csvs_path = "lang", translation_csv_config = "lang/config.yml")
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
    tags$link(rel = "icon", href = "data:;base64,="),

    # Track the size of the form so we can adjust the plots
    tags$script('
      var dimension = [0, 0];
      $(document).on("shiny:connected", function(e) {
        dimension[0] = window.innerWidth;
        dimension[1] = window.innerHeight;
        Shiny.onInputChange("dimension", dimension);
      });
      $(window).resize(function(e) {
        dimension[0] = window.innerWidth;
        dimension[1] = window.innerHeight;
        Shiny.onInputChange("dimension", dimension);
      });')
  ),

  # Set the main application title
  titlePanel(i18n$t("Deletion Risk Explorer"),
             windowTitle = "Deletion Risk Explorer"),

  # Sidebar panel for inputs
  sidebarPanel(
    bsCollapse(id = "side_panel",

      bsCollapsePanel("Treatment Seeking Rate",
        wellPanel(
          selectInput("treatment_seeking",
                      label = i18n$t("Probability of seeking treatment for malaria fever"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_treatment"))
        )),

      bsCollapsePanel("HRP3 Cross-Reactivity",
        wellPanel(
          selectInput("rdt_deleted",
                      label = i18n$t("Probability of HRP3 cross reacting to yield a positive RDT"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_reactivity"))
        )),

      bsCollapsePanel("Adherence to RDT Outcomes",
        wellPanel(
          selectInput("rdt_nonadherence",
                      label = i18n$t("Probability of adherence to RDT outcomes"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_adherence")),
        )),

      bsCollapsePanel("Microscopy Based Diagnosis",
        wellPanel(
          selectInput("microscopy_usage",
                      label = i18n$t("Probability of using microscopy for malaria diagnosis"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_microscopy")),
        )),

      bsCollapsePanel("Malaria Prevalence",
        wellPanel(
          selectInput("microscopy_prevalence",
                      label = i18n$t("Assumed malaria prevalence for ages 2 to 10"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_prevalence")),
        )),

      bsCollapsePanel("Deletion Fitness",
        wellPanel(
          selectInput("fitness",
                      label = i18n$t("Assumed fitness compared to the wild type"),
                      choices = choices_list_en, selected = 2),
          helpText(uiOutput("ui_help_fitness")),
        ))
    ),

    # Spacer between the control blocks
    br(),

    # Region selection controls
    wellPanel(
      selectInput("region",
                  label = i18n$t("Region"),
                  choices = regions_list_en, selected = 2),
    ),

    # Language controls
    wellPanel(
      selectInput("language",
                  label = i18n$t("Change Language"),
                  choices = list("English" = "en",
                                 "Español" = "es",
                                 "Français" = "fr",
                                 "Português" = "pt"),
                  selected = i18n$get_translation_language())
    )
  ),

  # Main panel for displaying the maps
  mainPanel(
    tabsetPanel(
      tabPanel(i18n$t("Overview"), uiOutput("ui_overview")),
      tabPanel(i18n$t("About the Scores"), uiOutput("ui_scores")),

      tabPanel(i18n$t("Innate Risk Map"),
        plotOutput("plot_innate", width = "100%", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_innate")
      ),

      tabPanel(i18n$t("Prospective Risk Map"),
        plotOutput("plot_prospective", width = "100%", inline = TRUE) %>% withSpinner(color = "#E5E4E2"),
        br(),
        uiOutput("ui_prospective")
      ),

    )
  )
)