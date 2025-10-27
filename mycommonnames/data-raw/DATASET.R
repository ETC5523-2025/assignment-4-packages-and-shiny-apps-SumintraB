## code to prepare `DATASET` dataset goes here

library(babynames)
library(dplyr)
library(usethis)

names <- babynames |>
  rename(name = name,
         year = year,
         sex  = sex,
         count = n,
         proportion = prop)

use_data(names, overwrite = TRUE)

