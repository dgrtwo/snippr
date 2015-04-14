#' Write a list of snippets to a file.
#'
#' This overwrites the file if it exists. To append/edit a snippet, use
#' \code{\link{snippet_add}} instead.
#'
#' @param snippets named list of snippets
#' @param path path to the file to write to
#'
#' @export
snippets_write <- function(snippets, path) {
    snippet_txt <- paste0("snippet ", names(snippets), "\n",
                              as.character(snippets), collapse = "\n")
    writeLines(snippet_txt, path)
}
