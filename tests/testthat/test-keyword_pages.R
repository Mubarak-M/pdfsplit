test_that('number of page extracted', {
  file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
  res <- keyword_pages(file, "test")

  expect_equal(length(res), 2)
})
