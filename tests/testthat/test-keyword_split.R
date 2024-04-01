test_that("file extension check works", {
  expect_error(keyword_split("file.png", "keyword"), "input must be a pdf file")
})
