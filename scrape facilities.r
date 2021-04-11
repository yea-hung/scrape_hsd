# define state name
NAME<-'Illinois'

# define state abbreviation
ABB<-'IL'

# scrape state page -> cities
cc<-paste('https://www.homelessshelterdirectory.org/',
          gsub(' ','',tolower(NAME)),
          '.html',sep='')
cc<-readLines(cc)
cc<-cc[grepl(paste('state=',ABB,sep=''),cc)&!grepl('h4',cc)]
cc<-gsub('^[^\\"]+\\"','',cc)
cc<-gsub('\\"\\stitle.+$','',cc)
length(cc)
sum(duplicated(cc))

# initiate vector of facility urls
uu<-NULL

# scrape city pages -> facilities
for(city in 1:length(cc)){ 
  
  ff<-cc[city]
  Sys.sleep(1)
  ff<-readLines(ff,warn=FALSE)
  ff<-ff[grepl('shelter\\.cgi',ff)&grepl('h4',ff)]
  if(length(ff)==0){ next }
  ff<-gsub('^.+\\"http','http',ff)
  ff<-gsub('\\">.+$','',ff)
  uu<-c(uu,ff)
  
}

# remove duplicated facility urls
uu<-uu[!duplicated(uu)]
length(uu)

# define filename stub
file.stub<-paste('facilities',tolower(ABB),sep='_')

# initiate data frame of facilities
FF<-NULL

# scrape facility information
for(facility in 1:length(uu)){ # length(uu)

  web<-uu[facility]
  Sys.sleep(0.5)
  ff<-readLines(web,warn=FALSE)
  name<-grep('h3',ff,value=TRUE)[1]
  name
  name<-trimws(gsub('<[^<]+>','',name))
  name<-trimws(gsub('\\-.+$','',name))
  address<-grep('Contact info',ff)+2
  if(length(address)==0){ 
    print(paste('error:',facility))
    break 
  }
  address<-ff[address]
  address<-trimws(gsub('<[^<]+>','',address))
  city<-grep('Contact info',ff)+4
  city<-ff[city]
  city<-trimws(gsub('<[^<]+>','',city))
  FF<-rbind(FF,data.frame(name=name,address=address,city=city,url=web))
    
}

# check data frame of facilities
nrow(FF)

# subset to state's facilities
FF<-subset(FF,grepl(ABB,city))
nrow(FF)

# sort facilities by city
FF<-FF[order(FF$city),]

# output data
saveRDS(FF,paste(file.stub,'.rds',sep=''))
write.csv(FF,paste(file.stub,'.csv',sep=''))