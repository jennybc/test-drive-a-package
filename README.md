Test drive an R package
================
Jenny Bryan
2016-06-04

<!-- README.md is generated from README.Rmd. Please edit that file -->
The Occasion: you want to try an experimental version of an R package without messing with your main R library. From a GitHub pull request or branch or tag or what have you.

Main idea: create a temporary library and make sure it sits in front of the usual `.libPaths()` for the duration of the experiment = installation and usage.

Here we go. I assume we're in a fresh R session.

``` r
# read ?devtools::install_github for how to specify PR, SHA, etc.
ghspec <- "jennybc/googlesheets#194"
pkg <- "googlesheets"

(tmp_lib <- "~/tmp/tmp_library")
#> [1] "~/tmp/tmp_library"
# (tmp_lib <- file.path(tempdir(), ".lib"))
if (!dir.exists(tmp_lib)) dir.create(tmp_lib)

withr::with_libpaths(tmp_lib, devtools::install_github(ghspec, force = TRUE), "prefix")
#> Using GitHub PAT from envvar GITHUB_PAT
#> Using GitHub PAT from envvar GITHUB_PAT
#> Downloading GitHub repo daroczig/googlesheets@upload-to-folder
#> from URL https://api.github.com/repos/daroczig/googlesheets/tarball/upload-to-folder
#> Installing googlesheets
#> Using GitHub PAT from envvar GITHUB_PAT
#> '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
#>   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#>   '/private/var/folders/vt/4sdxy0rd1b3b65nqssx4sx_h0000gn/T/RtmpgqiDuD/devtoolsaa3821ffdde9/daroczig-googlesheets-ee6a538'  \
#>   --library='/Users/jenny/tmp/tmp_library' --install-tests
#> 
library(pkg, lib.loc = tmp_lib, character.only = TRUE)
```

Reveal/confirm version.

``` r
sip <- devtools::session_info(pkg)$packages
subset(sip, package == pkg)
#>  package      * version    date       source                        
#>  googlesheets * 0.2.0.9000 2016-06-04 github (daroczig/googlesheets)

## NOW DO WHATEVER YOU WANT.
```

Notes:

-   Where to create your temporary library? The [first time I gisted](https://gist.github.com/jennybc/4ffc1607d07ed3b025dc) this, Jeroen pointed out that maybe I should literally use `tempdir()`. The advantage is it'll automatically get deleted when you quit R. I tried that a few times, but went back to doing this below `~/tmp`. Why? Because things go sideways often enough that I want to look at the library and the path to temporary directories is god awful. Plus, I might want to go away and come back a few times in future sessions. I think `~/tmp` is the right compromise for me.

-   I'm using `devtools::install_github()` to install and I have the impression that you can't specify the library (have not re-checked this in a while). Hence the `withr::with_libpaths()` business. But now there are new lightweight installers, like [`cloudyr/ghit`](https://github.com/cloudyr/ghit) and [`MangoTheCat/remotes`](https://github.com/MangoTheCat/remotes). Maybe I should use one of those? It looks like `ghit` does have a `lib =` argument.
