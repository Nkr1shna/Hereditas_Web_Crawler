source(paste0(getwd(),"/Crawler.R"))
name_address <- crawl()
address <- paste0("http://doi.org/",name_address[[2]])

options(warn=-1)
dir.create("Crawled Files")
#length(name[[1]]) = length of all articles
l <- length(name_address[[1]])
for (i in 1:l) {
  nm = gsub("/","",name_address[[1]][i])
  a = read_html(address[i])
  write_xml(a, paste(getwd(),"/Crawled Files/",nm,sep = ""))
}
