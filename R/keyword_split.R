#' Extract pdf pages based on keyword
#'
#' Uses pdf splitting capability of the pdftools package to extract pages from
#' a pdf file based on user specified keyword(s).
#'
#' @param path A direct path to a pdf file
#' @param keyword The keyword(s) to be used foe extracting pages. Multiple
#'        keywords can be specified with a character vector.
#' @param ignore_case TRUE/FALSE Indicates whether keyword is case sensitive.
#'                    Default is FALSE meaning that the case of the keyword is
#'                    matched exactly.
#' @param keyword_combination "OR"/"AND" Determines how multiple keywords in
#'                            keyword vector are matched. "OR" means match any
#'                            keyword in the keyword vector. "AND" means match
#'                            all keywords must be matched.
#' @param combine_pages TRUE/FALSE Indicates if you all matched pages should be
#'                      output as a single pdf or as individual pdf document.
#'                      Default is TRUE.
#' @param file_output Specify path of the output file(s).
#'                    Default is NULL and files will be saved to input path.
#'
#' @return Path to pdf file containing extracted page(s) when combine_pages = TRUE.
#'         Otherwise, TRUE when extractions are successful.
#' @export
#'
#' @examples
#' # Single keyword
#' file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
#' pdf_file <- file.path(getwd(), "output.pdf")
#' keyword_split(file,keyword = "test", file_output = pdf_file)
#' unlink(pdf_file)
#'
#' # Multiple keywords
#' file <- system.file("extdata", "1406.4806.pdf", package = "pdfsplit")
#' pdf_file <- file.path(getwd(), "output.pdf")
#' keyword_split(file,keyword = c("test","performance"),keyword_combination = "OR",
#'  file_output = pdf_file)
#' unlink(pdf_file)
#'
#'
keyword_split <- function(path, keyword, ignore_case = FALSE,
                      keyword_combination = "OR",
                      combine_pages = TRUE,
                      file_output = NULL){
  if(!grepl(".pdf$", path))
    stop("input must be a pdf file")
  if(length(path) != 1)
    stop("only one input file allowed")
  file_text <- pdftools::pdf_text(path)
  if(length(keyword)==1){
    pages <- which(grepl(keyword,file_text,ignore.case = ignore_case))
    if(length(pages)<1)
      stop(paste("no match found for ", keyword))
  }else{
    temp_page <- lapply(keyword
                        , function(x) which(grepl(x,file_text,ignore.case = ignore_case)))
    if(keyword_combination=="AND"){
      pages <- do.call(intersect, temp_page)
    }else{
      pages <- unique(sort(unlist(temp_page)))
    }
    if(length(pages)<1)
      stop(paste0("match not found for keyword(s) ",
                  keyword[which(lapply(temp_page, function(x) length(x)[[1]])<1)]))
  }

  if(combine_pages){
    pdftools::pdf_subset(path, pages = pages, output = file_output)
  }else{
    temp_pdf <- pdftools::pdf_subset(path, pages = pages)
    pdftools::pdf_split(temp_pdf, output = file_output)
    file.remove(temp_pdf)
  }


}
