test_that("directory check works", {
  expect_error(directory_split("file.pdf", "keyword"), "input must be a directory")
})
