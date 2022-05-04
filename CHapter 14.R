# Chapter 14
# Strings

library(tidyverse)

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use the single quotes'

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"","\\")
x

writeLines(x)

x <- "\u00b5"
x

c("one", "two", "three")

str_length(c("a", "R for data science", NA))

str_c("x", "y")

str_c("x","y","z")

str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- TRUE

str_c("Good ", time_of_day, " ", name,
      if(birthday) " and HAPPY BIRTHDAY",
      ".")

str_c(c("x", "y", "z"), collapse = ", ")

# 14.2.3
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

str_sub(x, -3, -1)
