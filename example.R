library(loreplotr)

# source("./R/loreplotr.R")

data("mtcars")

mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")

t <- mtcars %>% loreplotr("mpg", "cyl")
t

t <- t + scale_fill_manual(values = c("#DC9362", "#6BE19F", "#A373E5"))
t
