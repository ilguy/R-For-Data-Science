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

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance, 
                      air_time
                )
# Use mutate to add new rows

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
       )

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
       )

# Only keep the new variables

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          )

transmute(flights,
          dep_time,
          hour = dep_time %/% 100, # Integer division
          minute = dep_time %% 100 # remainder
          )

x <- 1:10
lag(x)
lead(x)

# Cumulative aggregates
# Use RcppRoll package for rolling aggregates
x
cumsum(x)
cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

transmute(flights,
          dep_time,
          dep_time_since_mid = ((dep_time %/% 100) * 60) + (dep_time %% 100) %% 1440)

transmute(flights,
          air_time,
          dep_time_since_mid = ((dep_time %/% 100) * 60) + (dep_time %% 100) %% 1440,
          arr_time_since_mid = ((arr_time %/% 100) * 60) + (arr_time %% 100) %% 1440,
          real_time = arr_time_since_mid - dep_time_since_mid)

flights_airtime <-
  mutate(flights,
         dep_time = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
         arr_time = (arr_time %/% 100 * 60 + arr_time %% 100) %% 1440,
         air_time_diff = air_time - arr_time + dep_time
  )

nrow(filter(flights_airtime, air_time_diff != 0))

#Summarize data
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# Without the pipe function
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
#> `summarise()` ungrouping output (override with `.groups` argument)
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'
#> 
# Using the pipe
delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping  = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# Start with lahman package 5.6.3

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

batters %>%
  arrange(desc(ba))

# 5.6.4
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

not_cancelled %>%
  group_by(dest) %>%
  summarise(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

# Same but with first and last
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

# Filtering with ranks
not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

# Simple count
not_cancelled %>%
  count(dest)

# Use weight in count, this one counts miles a plane flew
not_cancelled %>%
  count(tailnum, wt = distance) %>%
  arrange(desc(n))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time < 500))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(hour_prop = mean(arr_delay > 60))

# 5.6.5
daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year <- summarise(per_month, flights = sum(flights)))

# 5.6.6
daily %>%
  ungroup() %>%
  summarise(flights = n())

# 5.7
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
popular_dests

popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)

# End of Chapter 5