# Chapter 10: Tibbles

library(tidyverse)
as_tibble(iris)

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

tb <- tibble(
  `:)` = "Smile",
  ` ` = "space",
  `2000` = "number"
)
tb

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df$x
df[[1]]
df[["x"]]

df %>%
  .$x
df %>% .[["x"]]
