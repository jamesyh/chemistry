library(tidyverse)

csvfiles = readLines("http://www.basketballgeek.com/downloads/2009-2010/")

csvfiles = data.frame( file = csvfiles[6:1220]  )


csvfiles = separate(csvfiles , "file" , c("1","2" ) ,sep = "\'")


for(i in 188:nrow(csvfiles)) {

  if(i %in% c(181,184,187)) next

  sub =  read.csv( paste0("http://www.basketballgeek.com/downloads/2009-2010/",csvfiles[i,2]) )

  sub$fileName = csvfiles[i,2]
  
  if(i == 1) catch = sub
  else catch = rbind(catch , sub)
  
  print(i)
  }




catch = catch[catch$etype == "shot" , ]

away = catch[,c("a1","a2","a3","a4","a5","player","result","type","fileName","team")]
home = catch[,c("h1","h2","h3","h4","h5","player","result","type","fileName","team")]

for(i in 1:ncol(away)){ away[,i] = as.character( away[,i] ) }
for(i in 1:ncol(away)){ home[,i] = as.character( home[,i] ) }


inLineupAway = function(x ){
  
  result = away[x,"player"] %in% away[x,1:5]
  
  return(result)
  
}


inLineupHome = function(x){
  
  result =  home[x,"player"] %in% home[x,1:5]
  
  return(result)
  
}


away = away[sapply(1:nrow(away), inLineupAway) , ]
home = home[sapply(1:nrow(home), inLineupHome) , ]

away$Place = "away"
home$Place = "home"

names(home)[1:5] = c("player1","player2","player3","player4","player5")
names(away)[1:5] = c("player1","player2","player3","player4","player5")


both = rbind(away,home)

for(x in 1:nrow(both)){
  
  both[x,1:5] = both[x,1:5][ order( both[x,1:5] ) ]
  

  
}






both$result =  as.numeric( ifelse(both$result == "made",1,0) )


lakers = both[both$team == "LAL" , ]


index = unique( lakers[ , c("player1","player2","player3","player4","player5","team")] )

index$lineup = paste(index$team,"lineup" , 1:nrow(index))

lakers$lineup = NA

for( i in 1:nrow(index)) {
  
  lakers[ lakers$player1 == index[i,1] & 
            lakers$player2 == index[i,2] &
            lakers$player3 == index[i,3] &
            lakers$player4 == index[i,4] &
            lakers$player5 == index[i,5] &
            lakers$team == index[i,6] , "lineup" ] = index[i,7]
  
}


teams = unique(lakers$team)



players = unique(c(lakers$player1,lakers$player2,lakers$player3,lakers$player4,lakers$player5))
playersID = paste("Player" , 1:length(players) )


for(i in players){
  
  lakers[,i] = 0
  
  lakers[ grepl( i , paste(lakers$player1,lakers$player2,lakers$player3,lakers$player4,lakers$player5) ) , i ] = 1
  
  lakers[,i] as.factor(lakers[,i])
  
  
}


names(lakers) = gsub(" ","",names(lakers))
head(lakers)


sub = lakers[ , -which(names(lakers) %in% c("player1","player2","player3","player4","player5","player","type","fileName","team","Place"  )) ]


sub = sub[sub$lineup %in% names(table(sub$lineup)[table(sub$lineup) > 10]) , ]


model = glm(result ~ . , data = sub , family = "binomial")
summary(model)


model$coefficients
