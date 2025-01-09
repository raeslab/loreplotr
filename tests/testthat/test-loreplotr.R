library(loreplotr)

test_that("loreplotr works", {
  data("mtcars")
  mtcars$cyl <- paste("cyl", mtcars$cyl, sep="_")

  expect_no_error(loreplotr(mtcars, "mpg", "cyl"))
  expect_error(loreplotr(mtcars, "mpg", "unknowncol")) # One column doesn't exist
  expect_error(loreplotr(mtcars, "unknowncol", "cyl")) # Other column doesn't exist
  expect_error(loreplotr(mtcars, "xyz", "unknowncol")) # Both columns doesn't exist

  # Test Binary version
  mtcars$cyl <- gsub("cyl_4", 0, mtcars$cyl)
  mtcars$cyl <- gsub("cyl_6", 0, mtcars$cyl)
  mtcars$cyl <- gsub("cyl_8", 1, mtcars$cyl)

  mtcars$cyl <- as.numeric(mtcars$cyl)
  expect_no_error(loreplotr(mtcars, "mpg", "cyl"))

})
