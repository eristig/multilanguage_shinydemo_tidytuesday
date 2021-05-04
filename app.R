# Load libraries
library(shiny)
library(shiny.i18n)

# call folder with translation file(s)
i18n <- Translator$new(translation_csvs_path = "./data")

# Set default language
i18n$set_translation_language("English")

# Wrap all text to be translated in - i18n$t()

## UI

ui <- fluidPage(
  # Important line of code
  shiny.i18n::usei18n(i18n),
  tags$div(
    style='float: right;',
    # Add dropdown so language can be changed
    selectInput(
      inputId='selected_language',
      label=i18n$t('Change language'),
      choices = i18n$get_languages(),
      selected = i18n$get_key_translation()
    )
  ),

  titlePanel(i18n$t("Hello TidyTuesday Friends")),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  i18n$t("Number of columns:"),
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    mainPanel(
      plotOutput("distPlot"),
      p(i18n$t("Tuesday is my favorite day of the week."))
    )
  )
)

## SERVER

server <- function(input, output, session) {

  observeEvent(input$selected_language, {
    update_lang(session, input$selected_language)
  })

  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins,
         col = "darkgray", border = "white",
         main = i18n$t("Meaningless Histogram"), ylab = i18n$t("Frequency"), xlab = i18n$t("??"))
  })
}

shinyApp(ui = ui, server = server)
