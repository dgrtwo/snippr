<!-- README.md is generated from README.Rmd. Please edit that file -->
snippr: publish, install, and share RStudio code snippets
---------------------------------------------------------

snippr provides tools to manage and install [RStudio code snippets](http://blog.rstudio.org/2015/04/13/rstudio-v0-99-preview-code-snippets/), including installing them from public repositories.

### Setup

You can install `snippr` with the [devtools](https://github.com/hadley/devtools) package:

``` r
devtools::install_github("dgrtwo/snippr")
```

### Sharing and installing snippets

`snippr` lets you share RStudio snippets with others by publishing them as a [GitHub repository](https://github.com/) or a [Gist](https://gist.github.com/).

To share your snippets, create a GitHub repository with one or more `.snippets` file at the top level: see the [dgrtwo/snippets](https://github.com/dgrtwo/snippets) repository for an example. Anyone can then install your snippets using the code:

``` r
library(snippr)
snippets_install_github("dgrtwo/snippets")
```

Note that you may need to restart RStudio for the snippets to load. If you want to install only for one of the languages in the repo, you can use the `language` argument:

``` r
snippets_install_github("dgrtwo/snippets", language = "r")
```

Or you can choose to install only a single snippet:

``` r
snippets_install_github("dgrtwo/snippets", language = "r", name = "S3")
```

If you prefer, you can share one .snippets file as a GitHub Gist (like [this one](https://gist.github.com/dgrtwo/ecc6aec8d37af42cdd83)), and install it with its ID:

``` r
snippets_install_gist("ecc6aec8d37af42cdd83", language = "r")
```

See the vignettes for more.
