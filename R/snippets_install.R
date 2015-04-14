#' Install one or more snippets from a URL.
#'
#' Install one or more snippets by downloading them from a URL.
#'
#' @param url URL to install from
#' @param name name of snippet to install. If NULL, installs all snippets from
#' the URL.
#' @template language
#'
#' @import httr
#'
#' @export
snippets_install_url <- function(url, name = NULL, language = "r", path = snippets_path(language)) {
    req <- httr::GET(url)
    txt <- httr::content(req, as = "text")
    snippets <- snippets_parse(txt)
    if (!is.null(name)) {
        if (is.null(snippets[[name]])) {
            stop("Snippet ", name, " not found")
        }
        snippets <- snippets[name]
    }
    snippets_add(snippets, path = path)
}


#' Install one or more snippets from a GitHub Gist
#'
#' Install one or more snippets uploaded as a GitHub Gist
#'
#' @param gist Identifier of the gist. For example, if the gist is
#' https://gist.githubusercontent.com/dgrtwo/ecc6aec8d37af42cdd83, then
#' the gist ID would be 'ecc6aec8d37af42cdd83'.
#' @param name name of snippet to install. If NULL, installs all snippets from
#' the Gist.
#' @template language
#'
#' @import httr
#'
#' @examples
#'
#' \dontrun{
#' snippets_install_gist('ecc6aec8d37af42cdd83')
#' }
#'
#' @export
snippets_install_gist <- function(gist, name = NULL, language = "r",
                                      path = snippets_path(language)) {
    # need to get redirect to full gist ID (which includes username)
    url <- paste0("https://gist.githubusercontent.com/", gist)
    req <- httr::GET(url)
    url <- file.path(req$url, "raw")

    snippets_install_url(url)
}


#' Install one or more snippets from a GitHub repository
#'
#' Install one or more snippets from a GitHub repository. These should be in
#' the form of one or more <language>.snippets files in the top-level directory.
#' .snippets files that are not
#'
#' @param repo Username and repository name, e.g. "dgrtwo/snippets"
#' @param name name of snippet to install, which must be given along with a language.
#' If NULL, installs all snippets from the language.
#' @param language Language from repo to install. If NULL, installs all snippets
#' @param directory Directory to install snippets to
#'
#' @details The \code{directory} argument is available mainly for testing purposes.
#'
#' @import httr
#'
#' @examples
#'
#' \dontrun{
#'
#' snippets_install_github("dgrtwo/snippets")
#'
#' # install just R or C/C++
#' snippets_install_github("dgrtwo/snippets", language = "r")
#' snippets_install_github("dgrtwo/snippets", language = "c_cpp")
#'
#' # install just a single snippet
#' snippets_install_github("dgrtwo/snippets", language = "r", name = "S3")
#'
#' }
#'
#' @export
snippets_install_github <- function(repo, name = NULL, language = NULL,
                                    directory = SNIPPET_DIRECTORY) {
    if (is.null(language) && !is.null(name)) {
        stop("Cannot provide snippet name without language to ",
             "snippets_install_github")
    }

    # retrieve files
    files <- github_GET(file.path("repos", repo, "contents"))
    if (!is.null(language)) {
        fname <- paste0(language, ".snippets")
        files <- Filter(function(f) f$name == fname, files)
        if (length(files) == 0) {
            stop("Language ", language, " not found in ", repo)
        }
    }
    for (f in files) {
        if (f$type != "file" || !str_detect(f$name, "\\.snippets$")) {
            message("Skipping ", f$name)
            next;
        }
        language <- str_replace(f$name, ".snippets$", "")
        path <- file.path(directory, paste0(language, ".snippets"))

        snippets_install_url(f$download_url, name = name, path = path)
    }
}
