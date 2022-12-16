# define function for scraping facilities from hsd
scrape_hsd<-function(NAME,ABB){

  # define cities
  cc<-paste('https://www.homelessshelterdirectory.org/',
            gsub(' ','',tolower(NAME)),
            '.html',sep='')
  cc<-read_html(cc)
  cc<-cc %>% html_table()
  cc<-as.data.frame(cc)
  cc<-subset(cc,!is.na(in.City)&in.City>0)
  cities<-cc$City
  cc<-paste('https://www.homelessshelterdirectory.org/',
            gsub(' ','',tolower(NAME)),
            '.html',sep='')
  cc<-readLines(cc)
  cc<-cc[grepl('href',cc)&!grepl('img',cc)]
  cc<-cc[grepl(paste('\\/city\\/',tolower(ABB),'\\-',sep=''),cc)]
  cc<-data.frame(
    url=gsub('^.+\\=\\"|\\">.+','',cc),
    city=trimws(gsub('<.*?>','',cc))
  )
  cc<-cc[!duplicated(cc),]
  cc<-cc[!grepl('Homeless Shelters in',cc$city),]
  cc<-cc$url[is.element(cc$city,cities)]
  
  # define facilities
  ff<-lapply(cc,function(city){ 
    ff<-readLines(city,warn=FALSE)
    ff<-ff[grepl('\\/shelter\\/',ff)&grepl('h4',ff)]
    ff<-ff[!grepl('\\+listing\\.',ff)]
    ff<-gsub('^.+\\=\\"|\\">.+','',ff)
  })
  ff<-do.call(c,ff)
  ff<-ff[!duplicated(ff)]
  
  # obtain facility names and addresses
  ff<-lapply(ff,function(facility){ 
    ff<-readLines(facility,warn=FALSE)
    name<-grep('entry\\_title',ff,value=TRUE)
    name<-trimws(gsub('<.*?>','',name))
    cut<-grep('<strong>Address',ff)
    address<-ff[cut+1]
    address<-trimws(gsub('<.*?>','',address))
    l2<-ff[cut+2]
    l2<-trimws(gsub('<.*?>','',l2))
    city<-gsub('\\,\\s.+$','',l2)
    state<-gsub('^.+\\,\\s+','',l2)
    state<-gsub('\\s+\\-\\s+.+$','',state)
    zip<-as.numeric(gsub('[A-Za-z]|\\s|\\-|\\,','',l2))
    data.frame(name=name,address=address,city=city,
               state=state,zip=zip,url=facility)
  })
  ff<-do.call(rbind,ff)
  ff<-subset(ff,state==ABB)
  ff<-ff[order(ff$city),]
  
  # return object
  ff
  
}