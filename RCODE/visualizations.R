library(ggplot2)
library(gridExtra)


load("allteamsbad.RData")

rm(list = (ls()[!ls() %in%  c("CHEMISTRYLINEUP","CHEMISTRYPLAYERS","THEfinal")]))

fixFisrts = function(sub){
  names(sub)[1] = "Theta"
  return(list(sub))
  
}

CHEMISTRYLINEUP = sapply(CHEMISTRYLINEUP,fixFisrts)


CHEMISTRYLINEUP = do.call(rbind, CHEMISTRYLINEUP)
CHEMISTRYPLAYERS = do.call(rbind, CHEMISTRYPLAYERS)



CHEMISTRYPLAYERS$Theta = exp(CHEMISTRYPLAYERS[,1] + CHEMISTRYPLAYERS[,2] + CHEMISTRYPLAYERS[,3] + CHEMISTRYPLAYERS[,4] 
                             + CHEMISTRYPLAYERS[,5] + CHEMISTRYPLAYERS[,6])/(1 + exp(CHEMISTRYPLAYERS[,1] + CHEMISTRYPLAYERS[,2] + CHEMISTRYPLAYERS[,3] + CHEMISTRYPLAYERS[,4] 
                                                                                + CHEMISTRYPLAYERS[,5] + CHEMISTRYPLAYERS[,6]))

CHEMISTRYPLAYERS$Team = gsub("lineup","",CHEMISTRYPLAYERS$LINEUPID)
CHEMISTRYPLAYERS$Team = gsub("Linewup","",CHEMISTRYPLAYERS$Team)
CHEMISTRYPLAYERS$Team = gsub("[0-9]","",CHEMISTRYPLAYERS$Team)


index = unique( CHEMISTRYPLAYERS[,c("LINEUPID","player1","player2","player3","player4","player5","Team")] )

for(i in index$LINEUPID){
  
  index[index$LINEUPID == i , "Count"] = sum(THEfinal[,i])
  
  
}

for(i in unique(index$Team)){
  
  
  index[index$Team == i , "Total"] = sum(THEfinal$team == i)
  
}

index$Percent = index$Count/index$Total




index = index[order(as.numeric(index$Count) , decreasing = T), ]

index[1:10,]


for( i in index$LINEUPID[2]){
  
  ThetaLinuep = sample(CHEMISTRYLINEUP[CHEMISTRYLINEUP$LINEUPID == i , "Theta"])
  ThetaPlayer = sample(CHEMISTRYPLAYERS[CHEMISTRYPLAYERS$LINEUPID == i , "Theta"])
  
  theta2 = density(ThetaLinuep)
  theta1 = density(ThetaPlayer)
  
  xmax = max(c(theta1$x,theta2$x))
  xmin = min(c(theta1$x,theta2$x))
  
  ymax = max(c(theta1$y,theta2$y))
  ymin = min(c(theta1$y,theta2$y))
  
  plot(density(ThetaLinuep) , xlim = c(xmin,xmax) , ylim = c(ymin,ymax),lwd = 4, col = "blue")
  lines(density(ThetaPlayer), lwd = 4 , col = 'red')

 
  }



# save.image("goodchemistry.RData")
# save.image("badchemistry.RData")

lineup = data.frame(`Theta Samples` = CHEMISTRYLINEUP[CHEMISTRYLINEUP$LINEUPID == i , "Theta"] , Model = "Lineup" )
player = data.frame(`Theta Samples` = CHEMISTRYPLAYERS[CHEMISTRYPLAYERS$LINEUPID == i , "Theta"] , Model = "Player" )


df = rbind(lineup,player)

ggplot(df, aes(x=Theta.Samples, fill=Model)) +
  geom_density(alpha=0.4)+
  labs(title="Boston Chemistry",x="Theta Samples", y = "Density")

rownames(index) = NULL

for( i in 2:6){ index[,i] = gsub("Player","",index[,i]) }


# grid.table(index[1:10,2:10], row = NULL) #  1060 520


