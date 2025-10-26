#' U.S. Baby Names, 1880–2021
#'
#' This dataset contains annual counts and proportions of baby names
#' registered in the United States from 1880–2021.
#'
#' @format A tibble with 1 924 665 rows and 5 columns:
#' \describe{
#'   \item{name}{First name of the baby}
#'   \item{year}{Year of registration}
#'   \item{sex}{"F" or "M"}
#'   \item{count}{Number of babies with this name}
#'   \item{proportion}{Proportion of all babies that year with this name}
#' }
#' @source Social Security Administration via the \pkg{babynames} package.
"names"
