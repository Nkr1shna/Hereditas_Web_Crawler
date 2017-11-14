library(stringr)
library(rvest)
articles= list.files('Crawled Files')

#DOI are article names without .html extention and added / at 8th position
DOI = unlist(lapply(articles,function(x){gsub('.html','',str_c(substr(x, 1, 7), "/", substr(x, 8, nchar(x))))}))

articlesHtml<-lapply(articles,function(x){read_html(str_c("Crawled Files/",x))})

Title= sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.ArticleTitle'))})
Title = str_replace_all(Title,"\n[ ]*","")

Authors = sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.Author'))})
Authors = sapply(Authors,function(x){str_replace_all(x,"\\n","")})
Authors = sapply(Authors,function(x){str_replace_all(x,"[0-9]","")})
Authors = sapply(Authors,function(x){str_replace_all(x,"View ORCID ID profile","")})
Authors = sapply(Authors,function(x){str_replace_all(x,"and","")})
Authors = sapply(Authors,function(x){str_replace_all(x,",","")})
Authors = sapply(Authors,function(x){str_replace_all(x,"†","")})
Authors = sapply(Authors,function(x){str_trim(x)})
#Still kept Email author to extract corresponding author and email
CorrespondingAuthor = sapply(Authors,function(x){
    x=x[grep("Email author",x)]
    str_replace_all(x,"Email author","")
})
CorrespondingAuthor = sapply(CorrespondingAuthor,function(x){str_trim(x)})

Authors = sapply(Authors,function(x){str_replace_all(x,"Email author","")})
Authors = sapply(Authors,function(x){str_trim(x)})

CorrespondingAuthorEmail = sapply(articlesHtml,function(x){html_attr(html_nodes(x,css='.EmailAuthor'),"href")})
CorrespondingAuthorEmail = sapply(CorrespondingAuthorEmail,function(x){str_replace_all(x,"mailto:","")})
CorrespondingAuthorEmail = sapply(CorrespondingAuthorEmail,function(x){str_replace_all(x,"%20",",")})
CorrespondingAuthorEmail = sapply(CorrespondingAuthorEmail,function(x){x = paste(x,collapse=",")})


AuthorAffiliations = sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.AffiliationText'))})

PublicationDate = sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.HistoryOnlineDate'))})
PublicationDate = str_replace_all(PublicationDate,"Published: ","")

Abstract = sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.Abstract'))})

Keywords = sapply(articlesHtml,function(x){html_text(html_nodes(x,css='.Keyword'))})
Keywords = sapply(Keywords,function(x){
  if(length(x)==0){
    x=NA
  }
  str_replace_all(x,"\\n[ ]*","")
})


FullText = sapply(articlesHtml,function(x){html_text(html_nodes((html_nodes(x,css='.fulltext')),css=":not(script)"))})
FullText = sapply(FullText,function(x){
  x=paste(x,collapse="")
})



Authors=sapply(Authors, function(x){x=paste(x,collapse="|")})
AuthorAffiliations=sapply(AuthorAffiliations, function(x){x=paste(x,collapse="|")})
CorrespondingAuthor=sapply(CorrespondingAuthor, function(x){x=paste(x,collapse="|")})
CorrespondingAuthorEmail=unlist(lapply(CorrespondingAuthorEmail, function(x){x=paste(x,collapse="|")}))
Abstract=lapply(Abstract, function(x){if(length(x)==0){NA} else{x}})
Abstract=unlist(lapply(Abstract, function(x){str_replace_all(x,"\\n[ ]*"," ")}))
Keywords=sapply(Keywords, function(x){x=paste(x,collapse="|")})


Hereditas <-data.frame(DOI,Title,Authors,AuthorAffiliations,CorrespondingAuthor,CorrespondingAuthorEmail,PublicationDate,Abstract,Keywords,FullText)
write.table(Hereditas, file="Hereditas.txt", sep ="\t", fileEncoding = "UTF-8")
