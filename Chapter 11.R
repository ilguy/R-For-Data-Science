# Chapter 11 Data Import
library(tidyverse)

heights <- read_csv("https://raw.githubusercontent.com/hadley/r4ds/main/data/heights.csv")

read_csv("a,b,c
         1,2,3
         4,5,6")

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)

read_csv("1,2,3\n4,5,6", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

read_csv("a,b,c\n1,2,.", na = ".")

#11.3
str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1", "231", ".", "456"), na = ".")

x <- parse_integer(c("123", "345", "abc", "123.45"))
