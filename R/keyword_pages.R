#' Identify pdf pages for keyword
#'
#' Leverage pdf_text from pdftools to search the pages a keyword
#' is located in a pdf file
#'
#' @param path A direct path to a pdf file
#' @param keyword The keyword(s) to be used foe extracting pages. Multiple
#'        keywords can be specified with a character vector.
#' @param ignore_case TRUE/FALSE Indicates whether keyword is case sensitive.
#'                    Default is FALSE meaning that the case of the keyword is
#'                    matched exactly.
#'
#' @param simplify TRUE/FALSE Indicates whether to return a list for
#'                  multiple keywords or return a data frame.Default is FALSE
#'
#' @return A list of keyword and the pdf pages they are located.
#' Returns a dataframe when simplify is TRUE for multiple keywords.
#' @export
#'
#' @examples
#' # Single keyword
#' file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
#' keyword_pages(file, "test", simplify = FALSE)
#'
#' # Multiple keywords
#' file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
#' keyword_pages(file, c("test", "performance"))
#'
#' ## Simplified output
#' keyword_pages(file, c("test", "performance"), simplify = TRUE)
keyword_pages <- function(path,
                          keyword,
                          ignore_case = FALSE,
                          simplify = FALSE) {
  if (!grepl(".pdf$", path))
    stop("input must be a pdf file")
  if (length(path) != 1)
    stop("only one input file allowed")
  file_text <- pdftools::pdf_text(path)
  if (length(keyword) == 1) {
    pages <-
      list(keyword = keyword, pages = which(grepl(keyword, file_text, ignore.case = ignore_case)))
    return(pages)
    if (length(pages) < 1)
      stop(paste("no match found for ", keyword))
  } else{
    temp_page <- lapply(keyword
                        , function(x)
                          list(keyword = x, pages = which(
                            grepl(x, file_text, ignore.case = ignore_case)
                          )))
    if (simplify) {
      pages_df <-
        data.frame(Keyword = rep(NA, length(keyword)),
                   pages = rep(NA, length(keyword)))

      for (i in 1:length(temp_page)) {
        pages_df$Keyword[i] = temp_page[[i]]$keyword
        pages_df$pages[i] = paste0(temp_page[[i]]$pages, collapse = ",")

      }
      return(pages_df)

    } else{
      return(temp_page)
    }

  }
}
