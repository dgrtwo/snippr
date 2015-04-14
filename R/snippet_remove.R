#' Remove a snippet from a .snippets file.
#'
#' Remove a snippet from a .snippets file, raising an error if the
#' snippet is not found in the file.
#'
#' @param name of the snippet to remove
#'
#' @template language
#'
#' @param error whether to raise an error if the snippet is not found
#'
#' @examples
#'
#' \dontrun{
#'
#' # add a .r snippet
#' snippet_add("dplyr", "${1:object} <- ${1:object} %>%\n${2:function}")
#'
#' # remove the snippet
#' snippet_remove("dplyr")
#'
#' }
#'
#' @export
snippet_remove <- function(name, language = "r", path = snippets_path(language),
                           error = TRUE) {
    current <- snippets_read(path = path)
    if (is.null(current[[name]])) {
        if (error) {
            stop("Snippet ", name, " not found to remove")
        }
        return()
    }
    current[[name]] <- NULL

    # replace contents of file
    snippets_write(current, path = path)
}
