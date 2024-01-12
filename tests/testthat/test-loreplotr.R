library(loreplotr)


test_that("loreplotr works", {
  data("mtcars")
  mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")

  expect_no_error(mtcars %>% loreplotr("mpg", "cyl"))
  expect_error(mtcars %>% loreplotr("mpg", "unknowncol")) # One column doesn't exist
  expect_error(mtcars %>% loreplotr("unknowncol", "cyl")) # Other column doesn't exist
  expect_error(mtcars %>% loreplotr("xyz", "unknowncol")) # Both columns doesn't exist
})
