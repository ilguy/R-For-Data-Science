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

parse_double("1,23", locale = locale(decimal_mark = ","))

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

# Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

parse_date("2010-10-01")

library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

parse_date("01/02/15", "%m/%d/%y")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

guess_parser("2010-10-01")

challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)
tail(challenge)

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(
                        x = col_double(),
                        y = col_logical()
                      ))
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

tail(challenge)

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df

type_convert(df)

write_csv(challenge, "challenge.csv")

challenge

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
