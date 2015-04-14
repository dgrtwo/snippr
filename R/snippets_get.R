#' Retrieve a current snippet
#'
#' @param name snippet name: if missing, returns a list of all snippets
#'
#' @template language
#'
#' @examples
#'
#' \dontrun{
#' snippet_get("fun")
#'
#' # assuming a c_cpp .snippets file exists:
#' snippet_get("cls", language = "c_cpp")
#'
#' # get a list of all snippets
#' snippet_get()
#'
#' }
#'
#' @export
snippets_get <- function(name, language = "r", path = snippets_path(language)) {
    snippets <- snippets_read(language = language, path = path)
    if (missing(name)) {
        snippets
    } else {
        ret <- snippets[[name]]
        if (is.null(ret)) {
            stop("Snippet ", name, " not found")
        }
        ret
    }
}
