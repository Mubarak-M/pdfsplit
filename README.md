
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pdfsplit

<!-- badges: start -->

[![R-CMD-check](https://github.com/Mubarak-M/pdfsplit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Mubarak-M/pdfsplit/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `pdfsplit` package provides functions for extracting pages from PDF
files based on keyword(s). Using the
[pdftools](https://github.com/ropensci/pdftools) package developed by
[rOpenSci](https://ropensci.org/), pdf pages can be extracted from in R
environment without the need for additional setup.

## Installation

You can install the development version of pdfsplit from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Mubarak-M/pdfsplit")
```

## Usage

This package currently offers three functions that are beneficial to
users. The first, `keyword_split`, is designed to extract page(s) based
on keywords from a single PDF file. The second function,
`directory_split`, performs a similar task but operates on an entire
directory of PDF files. The third function, `keyword_pages`, allow users
to identify the pdf pages where keywords are located.

### Example with `keyword_split`

The package includes two PDF files sourced from
[arXiv](https://arxiv.org/) for use as test cases. Here is an example
demonstrating the use of the `keyword_split` function.

#### Extract pages based on a single keyword

``` r
file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
pdf_file <- file.path(getwd(), "output.pdf")
keyword_split(file,keyword = "test", file_output = pdf_file)
```

#### Extract pages based on a single keyword

``` r
file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
pdf_file <- file.path(getwd(), "output.pdf")
keyword_split(file,keyword = c("test","performance"), file_output = pdf_file)
```

### Example with `directory_split`

The `directory_split` function enables users to extract pages using
specified keywords across multiple PDF files in a single function call.
It offers the same functionality found in the `pdf_split` function.
Below is an example demonstrating the extraction within a single
directory.

``` r
directory <- system.file("extdata", package = "pdfsplit")
dir_outs <- file.path(getwd(),"output")
directory_split(directory,keyword = "test", dir_output = dir_outs)
```

### Example with `keyword_pages`

The `keyword_pages` function allows user to identify the pages a keyword
is located in a pdf file.

#### Single keyword

``` r
library(pdfsplit)
file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
keyword_pages(file, "test")
#> $keyword
#> [1] "test"
#> 
#> $pages
#> [1]  3  5  8  9 11
```

#### Multiple keywords

``` r
file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
keyword_pages(file, c("test","performance"))
#> [[1]]
#> [[1]]$keyword
#> [1] "test"
#> 
#> [[1]]$pages
#> [1]  3  5  8  9 11
#> 
#> 
#> [[2]]
#> [[2]]$keyword
#> [1] "performance"
#> 
#> [[2]]$pages
#> [1]  3  4 11 12
```

#### Multiple keywords (Simplified output)

``` r
file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
keyword_pages(file, c("test","performance"), simplify = TRUE)
#>       Keyword      pages
#> 1        test 3,5,8,9,11
#> 2 performance  3,4,11,12
```

## Limitations

The package currently does not support scanned PDF files that require
OCR (Optical Character Recognition) for text recognition.
