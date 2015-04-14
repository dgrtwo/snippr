# test tools for installing snippets

context("Installing Snippets")

test_directory <- system.file("test_data", package = "snippr")
test_file <- file.path(test_directory, "test.snippets")

tmp <- ".test.snippets"
if (file.exists(tmp)) {
    unlink(tmp)
}
file.copy(test_file, tmp)

gist_id <- "ecc6aec8d37af42cdd83"
test_that("can install snippets from a URL", {
    url <- paste0("https://gist.githubusercontent.com/dgrtwo/", gist_id, "/raw")
    snippets_install_url(url, path = tmp)

    sn <- snippets_get("S3", path = tmp)
    expect_true(grepl("function\\(", sn))
})


test_that("can install snippets from a gist", {
    snippets_install_gist(gist_id, path = tmp)

    sn <- snippets_get("S3", path = tmp)
    expect_true(grepl("function\\(", sn))
})

unlink(tmp)

test_that("can install snippets from a GitHub repository", {
    # temporary directory
    tmpdir <- "tmpdir"
    unlink(tmpdir, recursive = TRUE)
    r_snippets <- file.path(tmpdir, "r.snippets")
    c_cpp_snippets <- file.path(tmpdir, "c_cpp.snippets")

    # create empty snippet files
    dir.create(tmpdir, showWarnings = FALSE)
    writeLines("", r_snippets)
    writeLines("", c_cpp_snippets)

    expect_message(snippets_install_github("dgrtwo/snippets", directory = tmpdir),
                   "Skipping README.md")

    # confirm we now have them
    expect_equal(length(snippets_get(path = r_snippets)), 2)
    expect_equal(length(snippets_get(path = c_cpp_snippets)), 1)

    # reset, install only one language
    writeLines("", r_snippets)
    writeLines("", c_cpp_snippets)

    suppressMessages(snippets_install_github("dgrtwo/snippets", directory = tmpdir, language = "r"))
    expect_equal(length(snippets_read(path = r_snippets)), 2)
    expect_equal(length(snippets_read(path = c_cpp_snippets)), 0)

    # reset, install only one snippet
    writeLines("", r_snippets)
    writeLines("", c_cpp_snippets)
    suppressMessages(snippets_install_github("dgrtwo/snippets", directory = tmpdir,
                                             language = "r", name = "S3"))
    expect_equal(length(snippets_read(path = r_snippets)), 1)

    # clean up
    unlink(tmpdir, recursive = TRUE)
})
