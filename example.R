library(dplyr)
library(ggplot2)
library(loreplotr)

data("mtcars")

mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")

# mtcars$cyl <- gsub("cyl_4", 0, mtcars$cyl)
# mtcars$cyl <- gsub("cyl_6", 0, mtcars$cyl)
# mtcars$cyl <- gsub("cyl_8", 1, mtcars$cyl)
#
# mtcars$cyl <- as.numeric(mtcars$cyl)

t <- mtcars %>% loreplotr("mpg", "cyl", dots_colour="black", dots_size=2, dots_alpha = 1, dots_shape=3)
t

t <- t + scale_fill_manual(values = c("#DC9362", "#6BE19F", "#A373E5"))
t
