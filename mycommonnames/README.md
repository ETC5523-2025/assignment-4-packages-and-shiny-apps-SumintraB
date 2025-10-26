
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mycommonnames

<!-- badges: start -->
<!-- badges: end -->

An R package for exploring the most common first names in America using
U.S. Social Security data.

## Overview

`mycommonnames` is an R package for exploring long-term trends in U.S.
baby-name popularity (1880–2021).  
It provides a clean dataset (`names`), a Shiny app for interactive
exploration, and a vignette that demonstrates name-trend analysis.

## Installation

You can install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("yourusername/mycommonnames")
```

## Example

How to load the data and run the app:

``` r
library(mycommonnames)

# View the first few rows of the dataset
head(names)

# Launch the interactive app
launch_app()
```
