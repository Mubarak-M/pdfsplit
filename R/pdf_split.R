pdf_split <- function(path, keyword, exact_match = FALSE,
                      keyword_combination = "OR",
                      combine_pages = TRUE,
                      file_output = NULL){
  if(!grepl(".pdf$", path))
    stop("input must be a pdf file")
  if(length(path) != 1)
    stop("only one input file allowed")
  file_text <- pdftools::pdf_text(path)
  if(length(keyword)==1){
    pages <- which(grepl(keyword,file_text,ignore.case = exact_match))
    if(length(pages)<1)
      stop(paste("no match found for ", keyword))
  }else{
    temp_page <- lapply(keyword
                        , function(x) which(grepl(x,file_text,ignore.case = exact_match)))
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

?pdftools::pdf_subset()
