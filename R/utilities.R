SNIPPET_DIRECTORY <- file.path("~", ".R", "snippets")

#' Find the path to a .snippets file.
#'
#' Find the path to the snippet file of the given language on this computer
#' (e.g. so that it can be read from or replaced)
#'
#' @param language language of snippet file to find
snippets_path <- function(language = "r") {
    path <- file.path(SNIPPET_DIRECTORY, paste0(language, ".snippets"))

    if (!(file.exists(path))) {
        stop("snippets file ", path, "not found")
    }

    path
}


#' Prepare a snippet for a .snippets file.
#'
#' @param text snippet text
#'
#' @export
snippet_prepare <- function(text) {
    # if any lines don't start with a tab, add a tab to all
    lines <- do.call(c, str_split(text, "\\n"))
    if (!all(str_detect(lines[lines != ""], "^\t"))) {
        lines <- paste0("\t", lines)
    }

    # end with a length 1 character vector
    paste(lines, collapse = "\n")
}


#' GET request to GitHub
#'
#' This function is taken directly from devtools (under GPL)
#'
#' @param path API path
#' @param ... extra arguments passed to httr::GET
#' @param pat GitHub personal access token. If missing, uses
#' \code{github_pat()} from devtools.
#'
#' @import httr
github_GET <- function(path, ..., pat) {
    if (missing(pat)) {
        pat <- devtools::github_pat()
    }
    if (!is.null(pat)) {
        auth <- httr::authenticate(pat, "x-oauth-basic", "basic")
    } else {
        auth <- NULL
    }

    req <- httr::GET("https://api.github.com/", path = path, auth, ...)

    text <- httr::content(req, as = "text")
    parsed <- jsonlite::fromJSON(text, simplifyVector = FALSE)

    if (httr::status_code(req) >= 400) {
        stop("Request failed (", httr::status_code(req), ")\n", parsed$message,
             call. = FALSE)
    }

    parsed
}
