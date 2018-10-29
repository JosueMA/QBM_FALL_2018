# Intro to R workshop
# 29.10.2018
# Rick Scavetta
# QBM Munich

# Clear workspace
rm(list = ls())

# Load packages
library(tidyverse)

# Basic R syntax:
n <- log2(8) # The log2 of 8
n

# A simple workflow
# A built-in data set
PlantGrowth

# Make plots: use the ggplot2 package
# it's already loaded as part of the tidyverse

# Set up a base layer:
# define data set (PlantGrowth) and
# aesthetic mappings (x scale?, y scale?)
p <- ggplot(PlantGrowth, aes(group, weight))

# Now add geometry layers to the base layer
# use +
p +
  geom_boxplot()

# Make stripcharts/dotplots
p +
  geom_point(position = position_jitter(0.15),
             alpha = 0.55) +
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult = 1),
               col = "red")

# Calculate descriptive stats:
mean(PlantGrowth$weight)

# Group-wise mean
# Use the "pipe operator" %>% (type shift + ctrl + m)
# Say "and then"
PlantGrowth %>%
  group_by(group) %>%
  summarise(avg = mean(weight),
            stdev = sd(weight)) -> PlantGrowthSummary

# Stats: t-tests
# Typically, use t.test()
# Here, a short cut with lm()
# i.e. a "linear model"
# here, order matters
plant.lm <- lm(weight ~ group, data = PlantGrowth)

# To get the t-test results:
summary(plant.lm)

# Full anova:
# Here, order doesn't matters
anova(plant.lm)

# Data set
chickwts

# Element 2: Functions
# Everything that happens,
# is because of a function

34 + 6

# This is actually a function:
`+`(34, 6)

# The order of operations
# BEDMAS: Brackets, Exp, Div, Mult, Add, Subtract
2 - 3/4    # 1.25
(2 - 3)/4  # -0.25

# Make some objects:
n <- 34
p <- 6

n + p # 34 + 6

# Generic form of functions:
# fun_name(fun_args)

# fun_args may be named of unnamed
# we can use names or only position
log2(8)
# the same as: use the long form and names
log(x = 8, base = 2)
# long form and position
log(8, 2)
# Typically, you'll see a combination
log(8, base = 2)

# What about this?
log(2, x = 8)
# very unintuitive!! don't do it! :/

# What about this?
log(x, 2)

# But...
x <- 8
log(x, 2)

# And...
x <- 2
log(8, x)

# Unnamed arguments
# e.g. in basic functions

# Combine/concatenate
xx <- c(3, 8, 9, 23)

# also with characters:
myNames <- c("healthy", "tissue", "quantity")

# Sequential numbers:
foo1 <- seq(from = 1, to = 100, by = 7)

# use objects in functions:
foo2 <- seq(1, n, p)

# regular sequence with interval 1
seq(1, 10, 1)
# Shortcut, the colon operator
1:10

# Two major types of math functions
# 1 - aggregration functions
# 1 (or a small number of) output
mean(foo1)
sum(foo1) # addition
prod(foo1) # multiplies
length(foo1)

# 2 - transformations functions
# Number of output is the same as input
# EVERY number is treated in the same way
log(foo1)
sqrt(foo1)
# Z-score
# Additions

# Exercise 6.1 (Predict output) Given foo2,
# can you predict the outcome of the following commands?
# Are they transformation or aggregation functions?

foo2 + 100 # Transformation
foo2 + foo2 # Transformation
sum(foo2) + foo2 # Agg + Trans
1:3 + foo2

##### Super concept :)
##### Vector recycling

1:4 + foo2

# 3 kinds of messages:
# 1 - message - neutral
# 2 - warning - possible error
# 3 - error - full stop :(

# Exercise 6.2:
1.12 * xx - 0.4

# also, e.g. z-scores
(foo1 - mean(foo1))/sd(foo1)
# or just...
scale(foo1)

# Exercise 6.3:
# previously
m <- 1.12
b <- -0.4
m * xx + b

# what if, I had...
m2 <- c(0, 1.12)
# I want to transform xx twice
# once for each m value

m2 * xx + b

# solutions
# repeat each values of m2 for as long as xx is
rep(m2, each = length(xx))

# Iterations:
# e.g. for loops,
# e.g. apply family (old school) lapply, apply, sapply, vapply...
# e.g. mapping with the purrr package (part of tidyverse)
# ~ "describe by"
# .x "place it here"
map(m2, ~ .x * xx + b)

# define a function (part solution)
# do this if you have lots of calculations
# defining functions
equation <- function(x) {
  1.12 * x - 0.4
}

# e.g.
equation(xx)

# () - order, provide args
# [] - position
# {} - defining chunks

# Exercise: Make a function to execute the following:
# xx is essential, m & b are optional
lin(xx) # Default values of m & b
lin(xx, 45, 63) # Any values of m & b
lin(xx, b = 3) # Only m or b

rm(m)
rm(b)
rm(x)

lin <- function(x, slope = 1.12, intercept = -0.4) {
  slope * x + intercept
}

lin(xx) # Default values of m & b
lin(xx, 45, 63) # Any values of m & b
lin(xx, i = 3) # Only m or b

map(m2, ~ lin(xx, .x))
map(0:5, ~ lin(xx, .x))

map2(m2, c(0,100), ~ lin(xx, .x, .y))
# pairs first m2 and first b
# then second m2 and second b

# all combinations of two values
input <- expand.grid(m2, 0:5) # get all combinations
map2(input$Var1, input$Var2, ~ lin(xx, .x, .y))
