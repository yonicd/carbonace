#' @title carbonace shinyapp
#' @description shinyapp to convert shinyAce to images for code sharing
#' @param init character, intial script to initialize shinyAce with.
#' @param viewer which [viewer][shiny::viewer] to open the app in. Default: shiny::paneViewer()
#' @param ace_opts user specific settings tp pass to the [aceEditor][shinyAce::aceEditor].
#'  Default: [ace_settings()][ace_settings]
#' @return NULL
#' @details
#'
#'   - The app has an RStudio addin, which you can highlight text in the editor
#' and the app will initialize with the contents.
#'
#'   - use [ace_settings()][ace_settings] to set user specific values for the editor.
#'
#'   Default options are:
#'
#' | **Field** | **Value** |
#' | --- | --- |
#' | theme                    | "ambience" |
#' | mode                     | 'r' |
#' | fontSize                 | 12 |
#' | tabSize                  | 4 |
#' | value                    | init |
#' | wordWrap                 | TRUE |
#' | autoScrollEditorIntoView | TRUE |
#' | maxLines                 | Inf |
#' | placeholder              | "Show a placeholder when the editor is empty ..." |
#'
#' @examples
#' if(interactive()){
#'  carbonace:::carbonace()
#'
#'  # Use ace_settings to change initial theme
#'  # carbonace:::carbonace(ace_opts = ace_settings(theme = 'chrome'))
#'  }
#' @rdname carbonace
#' @export
#' @import snapper
#' @import shiny
#' @importFrom shinyAce updateAceEditor getAceModes getAceThemes aceEditor
#' @importFrom shinyjqui jqui_resizable
carbonace <- function(init = "x <- 1", viewer = shiny::paneViewer(), ace_opts = ace_settings()){

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

  opts <- pkg_opts(init)

  if(length(ace_opts)>0){

    for(i in names(ace_opts)){
      opts[[i]] <- ace_opts[[i]]
    }

  }

  ace <- do.call(shinyAce::aceEditor,opts)

  # define UI for application that demonstrates a simple Ace editor
  ui <- shiny::pageWithSidebar(
    shiny::headerPanel(title = "Share your pretty shinyAce code!",
                       windowTitle = 'carbonace'),
    shiny::sidebarPanel(id = 'side',
                 snapper::load_snapper(),
                 shiny::selectInput("mode", "Mode: ", choices = shinyAce::getAceModes(), selected = opts$mode),
                 shiny::selectInput("theme", "Theme: ", choices = shinyAce::getAceThemes(), selected = opts$theme),
                 shiny::numericInput("tab_size", "Tab size:", opts$tabSize),
                 shiny::numericInput("font_size", "Font size:", opts$fontSize),
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
