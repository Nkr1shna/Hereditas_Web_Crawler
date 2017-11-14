library(RCurl)
library(XML)
library(rvest)
library(stringr)

crawl <- function(){
rl <- "https://hereditasjournal.biomedcentral.com"
src <- getURL(paste(rl,"/articles",sep = ""), followlocation=TRUE)
doc <- htmlParse(src, asText=TRUE)
#how many pages are in the journal
pageination <- xpathSApply(doc, "//*[@data-test='pagination-text']", xmlValue)
page_num <- substr(pageination[1],nchar(pageination[1]),nchar(pageination[1]))
# Store web url
URL = paste0(rl,"/articles?searchType=journalSearch&sort=PubDate&page=",1:page_num)

allAddr = c()
for (i in 1:page_num) {
  hereditas_articles <- read_html(URL[i])
  
  addr <- hereditas_articles %>%
    html_nodes("h3 a") %>%
    html_attr('data-event-label')
  
  allAddr = c(allAddr,addr)
}

name_address <- list(paste0(allAddr,".html"), allAddr)
return(name_address)
}

