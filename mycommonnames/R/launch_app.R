#' Launch the mycommonnames Shiny app
#'
#' Opens the interactive name-popularity explorer.
#' @export
launch_app <- function() {
  app_dir <- system.file("shinyapp", package = "mycommonnames")
  shiny::runApp(app_dir, display.mode = "normal")
}

