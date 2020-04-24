#' @title carbonace shinyapp
#' @description shinyapp to convert shinyAce to images for code sharing
#' @param init character, intial script to initialize shinyAce with.
#' @param viewer which [viewer][shiny::viewer] to open the app in.
#' @return NULL
#' @details The app has an RStudio addin, which you can highlight text in the editor
#' and the app will initialize with the contents.
#' @examples
#' if(interactive()){
#'  carbonace:::carbonace()
#'  }
#' @rdname carbonace
#' @export
#' @import snapper
#' @import shiny
#' @importFrom shinyAce updateAceEditor getAceModes getAceThemes aceEditor
#' @importFrom shinyjqui jqui_resizable
carbonace <- function(init = "x <- 1",viewer = shiny::browserViewer()){

  server <- function(input, output, session) {

    shiny::observe({
      shinyAce::updateAceEditor(
        session,
        "ace",
        theme = input$theme,
        mode = input$mode,
        tabSize = input$tab_size,
        fontSize = input$font_size,
        useSoftTabs = as.logical(input$soft),
        showInvisibles = as.logical(input$invisible)
      )
    })

    shiny::observeEvent(input$reset, {
      shinyAce::updateAceEditor(session, "ace", value = init)
    })

    shiny::observeEvent(input$clear, {
      shinyAce::updateAceEditor(session, "ace", value = "")
    })
  }

  ace <- shinyAce::aceEditor(
    outputId = "ace",
    selectionId = "selection",
    wordWrap = TRUE,
    value = init,
    placeholder = "Show a placeholder when the editor is empty ...")

  # define UI for application that demonstrates a simple Ace editor
  ui <- shiny::pageWithSidebar(
    shiny::headerPanel(title = "Share your pretty shinyAce code!",
                       windowTitle = 'carbonace'),
    shiny::sidebarPanel(id = 'side',
                 snapper::load_snapper(),
                 shiny::selectInput("mode", "Mode: ", choices = shinyAce::getAceModes(), selected = "r"),
                 shiny::selectInput("theme", "Theme: ", choices = shinyAce::getAceThemes(), selected = "ambience"),
                 shiny::numericInput("tab_size", "Tab size:", 4),
                 shiny::numericInput("font_size", "Font size:", 12),
                 shiny::radioButtons("soft", NULL, c("Soft tabs" = TRUE, "Hard tabs" = FALSE), inline = TRUE),
                 shiny::radioButtons("invisible", NULL, c("Hide invisibles" = FALSE, "Show invisibles" = TRUE), inline = TRUE),
                 shiny::actionButton("reset", "Reset text"),
                 shiny::actionButton("clear", "Clear text"),
                 snapper::preview_button(ui = '#ace',label = 'Preview Image'),
                 snapper::download_button(ui = '#ace',label = 'Download Image')
    ),
    shiny::mainPanel(
      shinyjqui::jqui_resizable(ace),
      snapper::snapper_div()
    )
  )

  shiny::runGadget(ui, server, viewer = viewer)

}
