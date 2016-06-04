#' ---
#' title: "Test drive an R package"
#' author: "Jenny Bryan"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---

#' <!-- README.md is generated from README.Rmd. Please edit that file -->

#+ setup, echo = FALSE
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "README-"
)

#' The Occasion: you want to try an experimental version of an R package without
#' messing with your main R library. From a GitHub pull request or branch or tag
#' or what have you.
#'
#' Main idea: create a temporary library and make sure it sits in front of the
#' usual `.libPaths()` for the duration of the experiment = installation and
#' usage.
#'
#' Here we go. I assume we're in a fresh R session.

# read ?devtools::install_github for how to specify PR, SHA, etc.
ghspec <- "jennybc/googlesheets#194"
pkg <- "googlesheets"

(tmp_lib <- "~/tmp/tmp_library")
# (tmp_lib <- file.path(tempdir(), ".lib"))
if (!dir.exists(tmp_lib)) dir.create(tmp_lib)

withr::with_libpaths(tmp_lib, devtools::install_github(ghspec, force = TRUE), "prefix")
library(pkg, lib.loc = tmp_lib, character.only = TRUE)

#' Reveal/confirm version.
sip <- devtools::session_info(pkg)$packages
subset(sip, package == pkg)

## NOW DO WHATEVER YOU WANT.

#' Notes:
#'
#' * Where to create your temporary library? The [first time I
#' gisted](https://gist.github.com/jennybc/4ffc1607d07ed3b025dc) this, Jeroen
#' pointed out that maybe I should literally use `tempdir()`. The advantage is
#' it'll automatically get deleted when you quit R. I tried that a few times,
#' but went back to doing this below `~/tmp`. Why? Because things go sideways
#' often enough that I want to look at the library and the path to temporary
#' directories is god awful. Plus, I might want to go away and come back a few
#' times in future sessions. I think `~/tmp` is the right compromise for me.
#'
#' * I'm using `devtools::install_github()` to install and I have the impression
#' that you can't specify the library (have not re-checked this in a while).
#' Hence the `withr::with_libpaths()` business. But now there are new
#' lightweight installers, like
#' [`cloudyr/ghit`](https://github.com/cloudyr/ghit) and
#' [`MangoTheCat/remotes`](https://github.com/MangoTheCat/remotes). Maybe I
#' should use one of those? It looks like `ghit` does have a `lib =` argument.
