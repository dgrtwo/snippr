#' Add a snippet to a .snippets file.
#'
#' @param name of the snippet to add
#' @param text text of the snippet to add, as a character vector
#'
#' @template language
#'
#' @examples
#'
#' \dontrun{
#'
#' # add a .r snippet
#' snippet_add("dplyr", "${1:object} <- ${1:object} %>%\n${2:function}")
#'
#' # update the snippet, adding whitespace
#' snippet_add("dplyr", "${1:object} <- ${1:object} %>%\n${2:function}")
#'
#' # add an HTML snippet
#' snippet_add("copyright", "<span style = 'font-size: 10px'>Copyright 2015</span>", language = "html")
#'
#' }
#'
#' @export
snippet_add <- function(name, text, language = "r",
                        path = snippets_path(language)) {
    current <- snippets_read(path = path)
    if (!is.null(current[[name]])) {
        message("Replacing existing snippet ", name)
    }
    current[[name]] <- snippet_prepare(text)

    # replace contents of file
    snippets_write(current, path = path)
}


#' Add a list of snippets to a .snippets file.
#'
#' Add multiple snippets, in the form of a named list, to a .snippets file.
#'
#' @param snippets list of snippets to add
#' @template language
#'
#' @examples
#'
#' \dontrun{
#'
#' # add a .r snippet
#' snippets_add(list(dplyr = "${1:object} <- ${1:object} %>%\n${2:function}"))
#'
#' # add an HTML snippet
#' snp <- "<span style = 'font-size: 10px'>Copyright 2015</span>"
#' snippet_add(list("copyright", snp, language = "html"))
#'
#' }
#'
#' @export
snippets_add <- function(snippets, language = "r",
                         path = snippets_path(language)) {
    current <- snippets_read(path = path)
    current <- modifyList(current, snippets)
    snippets_write(current, path = path)
}
