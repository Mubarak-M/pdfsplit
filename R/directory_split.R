#' Wrapper for pdf split function
#'
#' This will apply the pdf_split function over all PDF files within a
#' directory.
#'
#' @param directory The directory to all pdf files to apply the pdf_split function.
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
#' @param dir_output Specify path to the directory to store output file(s).
#'                    Default is NULL and files will be saved to
#'                    output directory created within input directory.
#'
#' @return Path to pdf file containing extracted page(s) when combine_pages = TRUE.
#'         Otherwise, TRUE when extractions are successful.
#' @export
#'
#' @examples
#'
#' directory <- system.file("extdata", package = "pdfsplit")
#' dir_outs <- file.path(getwd(),"output")
#' dir.create(dir_outs)
#' directory_split(directory,keyword = "test", dir_output = dir_outs)
#' unlink(dir_outs,recursive = TRUE)
directory_split <- function(directory,keyword,
                            ignore_case = FALSE,
                            keyword_combination = "OR",
                            combine_pages = TRUE,
                            dir_output = NULL) {
  if(grepl(".pdf$", directory))
    stop("input must be a directory")
  files_dir <- list.files(path = directory, pattern = ".pdf",
                          full.names = TRUE, recursive = FALSE)
  files_names <- list.files(path = directory, pattern = ".pdf",
                            full.names = FALSE, recursive = FALSE)
  if(is.null(dir_output)){
    dir_output <- paste0(directory,"/output")
    dir.create(dir_output)
  }

  lapply(seq_along(files_dir), function(xx) {
    tryCatch({
      pdf_split(files_dir[xx], keyword = keyword,
                ignore_case = ignore_case,
                keyword_combination = keyword_combination,
                combine_pages = combine_pages,
                file_output = paste0(dir_output,"/",
                                     gsub(".pdf$","_output.pdf",files_names[xx])))
    }, error = function(e) {
      cat("\033[31m")
      cat(paste("Error processing file:", files_dir[xx]), "\n")
      cat(paste("Error message:", e$message), "\n")
      cat("\033[0m")
    })
  })



}
