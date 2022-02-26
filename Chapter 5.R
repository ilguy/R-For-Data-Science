# Chapter 5

library(nycflights13)
library(tidyverse)

flights

# Filter() - Pick only certain rows
filter(flights, month == 1, day == 1)

# Assignment with filter
jan1 <- filter(flights, month == 1, day == 1)
jan1

# Pay attention to arithmetic with computers
sqrt(2) ^ 2 == 2
#> [1] FALSE
1 / 49 * 49 == 1
#> [1] FALSE
# Use near
near(sqrt(2) ^ 2,  2)
#> [1] TRUE
near(1 / 49 * 49, 1)
#> [1] TRUE
#> 
filter(flights, month == 11 | month == 12)
# This work the same as above
(nov_dec <- filter(flights, month %in% c(11, 12)))

#These are the same
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# Have to ask R to maintain missing values
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# 5.2.4
filter(flights, arr_delay > 120)

filter(flights, dest == 'IAH' | dest == 'HOU')

flights$carrier
filter(flights, carrier %in% c('UA', 'AA', 'DA'))

filter(flights, is.na(dep_time))

arrange(flights, year, month, day)

arrange(flights, desc(dep_delay))

arrange(flights, desc(is.na(flights)))

# Select
select(flights, year:day)

# All except
select(flights, -(year:day))

# Rename
rename(flights, tail_num = tailnum)

# use everything with select
select(flights, time_hour, air_time, everything())

# End of section 5.4