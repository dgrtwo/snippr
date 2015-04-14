#' Parse the current snippets file into a list of snippets.
#'
#' @template language
#'
#' @return A named list of snippets, each of which is a single string
#' that includes tabs at the start of each line.
#'
#' @import stringr
#' @import dplyr
#'
#' @export
snippets_read <- function(language = "r", path = snippets_path(language)) {
    lines <- readLines(path)
    snippets_parse(lines)
}


#' Parse a character vector of snippets.
#'
#' @param txt character vector of snippets
#'
#' @import stringr
snippets_parse <- function(txt) {
    # if it's not already split by newlines, do so
    lines <- do.call(c, stringr::str_split(txt, "\\n"))
    d <- dplyr::data_frame(line = lines,
                           snippet = str_match(line, "^snippet (.*)")[, 2],
                           group = cumsum(!is.na(snippet)))
    snippets <- d %>% split(d$group) %>%
        lapply(function(d) paste(d$line[-1], collapse = "\n"))
    # remove missing snippets
    snippets <- Filter(function(s) s != "", snippets)
    names(snippets) <- d$snippet[!is.na(d$snippet)]
    snippets
}
