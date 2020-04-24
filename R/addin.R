#' @importFrom rstudioapi getSourceEditorContext
carbonace_addin <- function(){
  adi <- rstudioapi::getSourceEditorContext()
  carbonace(init = adi$selection[[1]]$text)
}
