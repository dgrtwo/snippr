# test tools for working with snippet text and files

context("Snippet files")

test_that("snippet_prepare can prepare text for a .snippets file", {
    snippet_text <- "myfunc <- function() {\n\ta <- 1\n}"
    snippet_result <- "\tmyfunc <- function() {\n\t\ta <- 1\n\t}"
    expect_equal(snippet_prepare(snippet_text), snippet_result)

    # if there already are tabs, no need to add any
    expect_equal(snippet_prepare(snippet_result), snippet_result)

    # might be given as separate lines
    snippet_text <- c("myfunc <- function() {", "\ta <- 1", "}")
    expect_equal(snippet_prepare(snippet_text), snippet_result)
})


test_directory <- system.file("test_data", package = "snippr")
test_file <- file.path(test_directory, "test.snippets")

test_that("snippet_read can read a file of snippets", {
    snippets <- snippets_read(path = test_file)
    expect_equal(length(snippets), 4)
    expect_equal(names(snippets), c("lib", "req", "sg", "sm"))
})


test_that("can add and remove snippets", {
    tmp <- ".test.snippets"
    if (file.exists(tmp)) {
        unlink(tmp)
    }
    file.copy(test_file, tmp)

    expect_equal(length(snippets_read(path = tmp)), 4)
    fun <- "\t${1:name} <- function(${2:variables}) {\n\t\t${0}\n\t}\n"
    snippet_add("fun", fun, path = tmp)
    sn <- snippets_read(path = tmp)
    expect_equal(length(sn), 5)
    expect_equal(sn$fun, fun)

    # change the function to use = instead of <-
    fun2 <- "\t${1:name} <- function(${2:variables}) {\n\t\t${0}\n\t}\n"
    expect_message(snippet_add("fun", fun2, path = tmp), "Replacing existing snippet fun")
    sn <- snippets_read(path = tmp)
    expect_equal(length(sn), 5)
    expect_equal(sn$fun, fun2)

    # remove the "fun" snippet
    snippet_remove("fun", path = tmp)
    sn <- snippets_read(path = tmp)
    expect_equal(length(sn), 4)
    expect_true(is.null(sn$fun))

    # use snippets_add to add multiple
    snippets_add(list(myfun = fun, myfun2 = fun2), path = tmp)
    sn <- snippets_read(path = tmp)
    expect_equal(length(sn), 6)
    expect_equal(sn$myfun, fun)
    expect_equal(sn$myfun2, fun2)

    # clean up
    unlink(tmp)
})
