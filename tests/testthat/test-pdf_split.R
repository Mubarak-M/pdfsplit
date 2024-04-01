test_that("file extension check works", {
  expect_error(pdf_split("file.png", "keyword"), "input must be a pdf file")
})
