library(tidyverse)

csvfiles = readLines("http://www.basketballgeek.com/downloads/2009-2010/")

csvfiles = data.frame( file = csvfiles[6:1220]  )


csvfiles = separate(csvfiles , "file" , c("1","2" ) ,sep = "\'")


for(i in 185:nrow(csvfiles)) {

  if(i %in% c(181,184)) next
Sprite98!
    
  sub =  read.csv( paste0("http://www.basketballgeek.com/downloads/2009-2010/",csvfiles[i,2]) )

  sub$fileName = csvfiles[i,2]
  
  if(i == 1) catch = sub
  else catch = rbind(catch , sub)
  
  print(i)
  }

