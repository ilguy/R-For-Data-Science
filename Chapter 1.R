# Chapter 1 Code and notes
library(tidyverse)
tidyverse_update()

mpg
?mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))

ggplot(data = mpg)+
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# Notice how color goes outside aes here
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

mpg

# Shading when color is a continuous variable
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cty))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cty))

# Cannot map shape to continuous variable
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty))

?geom_point
vignette("ggplot2-specs")
