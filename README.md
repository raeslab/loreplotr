# Loreplotr - Logistic Regression Plots in R

## Setup

## Example

```R
library(loreplotr)

data("mtcars")

mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")

t <- mtcars %>% loreplotr("mpg", "cyl")
t

```

![Example loreplot using mtcars dataset](./docs/img/loreplot_cars_example.png)

