#' @param language language of the snippet. Choices are "r", "c_cpp", "html",
#' "css", "java", "javascript", "python", and "sql". Ignored if \code{path}
#' is specified.
#' @param path path to .snippets file
#'
#' @details Note that a .snippets file for a language may not yet exist. If
#' it does not exist, go to Preferences->Code->Edit Snippets in RStudio,
#' make a trivial change to the language of choice (for example, a new
#' empty line), and click Save. This will create the language file in
#' ~/.R/snippets/<language>.snippets with defaults included.
