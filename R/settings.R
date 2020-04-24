#' @title Set components of aceEditor settings
#' @description Customize non-data components of the the editor.
#' @return list of class c('ace_settings')
#' @details To find further information on the attributes that can be used
#' please refer to [shinyAce](https://github.com/trestletech/shinyAce)
#' @rdname ace_settings
#' @inheritParams shinyAce::aceEditor
#' @param \dots not used
#' @export
ace_settings <- function(value,
                     mode,
                     theme,
                     vimKeyBinding,
                     readOnly,
                     height,
                     fontSize,
                     debounce,
                     wordWrap,
                     showLineNumbers,
                     highlightActiveLine,
                     selectionId,
                     cursorId,
                     hotkeys,
                     code_hotkeys,
                     autoComplete,
                     autoCompleters,
                     autoCompleteList,
                     tabSize,
                     useSoftTabs,
                     showInvisibles,
                     setBehavioursEnabled,
                     autoScrollEditorIntoView,
                     maxLines,
                     minLines,
                     placeholder,
                     ...){

  setting <- find_args(...)

  bad_name <- setdiff(names(setting),names(default_class))

  if(length(bad_name)>0)
    stop(sprintf('%s not a valid element',paste0(bad_name,collapse = ', ')))

  invisible(lapply(names(setting),check_setting,setting))

  structure(setting, class = c("ace_settings"))

}

find_args <- function (...) {
  env <- parent.frame()
  args <- names(formals(sys.function(sys.parent(1))))
  vals <- mget(args, envir = env)
  vals <- vals[!vapply(vals, is_missing_arg, logical(1))]
  utils::modifyList(vals, list(..., ... = NULL))
}

is_missing_arg <- function (x) identical(x, quote(expr = ))

check_setting <- function(e,elements){
  e_val <- elements[[e]]
  if(!inherits(e_val,default_class[e]))
    stop(sprintf('%s must be of class %s',e,default_class[e]))
}

default_class <- c(
  'value'                    = 'character',
  'mode'                     = 'character',
  'theme'                    = 'character',
  'vimKeyBinding'            = 'logical',
  'readOnly'                 = 'logical',
  'height'                   = 'character',
  'fontSize'                 = 'numeric',
  'debounce'                 = 'numeric',
  'wordWrap'                 = 'logical',
  'showLineNumbers'          = 'logical',
  'highlightActiveLine'      = 'logical',
  'selectionId'              = 'character',
  'cursorId'                 = 'character',
  'hotkeys'                  = 'list',
  'code_hotkeys'             = 'list',
  'autoComplete'             = 'character',
  'autoCompleters'           = 'character',
  'autoCompleteList'         = 'list',
  'tabSize'                  = 'numeric',
  'useSoftTabs'              = 'logical',
  'showInvisibles'           = 'logical',
  'setBehavioursEnabled'     = 'logical',
  'autoScrollEditorIntoView' = 'logical',
  'maxLines'                 = 'numeric',
  'minLines'                 = 'numeric',
  'placeholder'              = 'character'
)

pkg_opts <- function(init){
  list(
    outputId                 = "ace",
    selectionId              = "selection",
    theme                    = "ambience",
    mode                     = 'r',
    fontSize                 = 12,
    tabSize                  = 4,
    value                    = init,
    wordWrap                 = TRUE,
    autoScrollEditorIntoView = TRUE,
    maxLines                 = Inf,
    placeholder              = "Show a placeholder when the editor is empty ..."
  )
}
