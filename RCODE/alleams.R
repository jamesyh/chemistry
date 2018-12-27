library(R2jags)
library(reshape2)

load("NBA2009.RData")

rm(list = (ls()[ls() != "final"]))


THEfinal = final

CHEMISTRYPLAYERS = list()
CHEMISTRYLINEUP = list()
chemnum = 1


for(teamnum in 1:30){
  
  final = THEfinal
  
  final = final[final$team == unique(final$team)[teamnum] , ]
  
  # final = final[final$team == "SAS" , ]
  
  
  players = final[ , grepl("Player",names(final))]
  players = players[ , names( apply(players,2,sum) != 0 )[apply(players,2,sum) != 0]  ]
  
  lineup = final[ , grepl("lineup",names(final))]
  lineup = lineup[ , names( apply(lineup,2,sum) != 0 )[apply(lineup,2,sum) != 0]  ]
  
  final = final[ , !grepl("Player",names(final))]
  final = final[ , !grepl("lineup",names(final))]
  
  
  final = cbind(final,players)
  final = cbind(final,lineup)
  
  
  
  result = final$result
  
  X = final[,-which(names(final) %in% c("result","filename","team"))]
  X = X[ , grepl("lineup",names(X))]
  
  lineupcount = names( apply(X,2,sum)[!apply(X,2,sum) > 19] )
  
  final = final[ , - which(names(final) %in% lineupcount)]
  
  
  X = final[,-which(names(final) %in% c("result","filename","team"))]
  X = X[ , grepl("lineup",names(X))]
  
  loseem = apply(X , 1 , sum) != 0 
  
  final = final[loseem , ]
  result = result[loseem  ]
  
  X = final
  X = X[ , !grepl("lineup",names(X))]
  thePlayers = X
  
  
  
  X = X[,-which(names(X) %in% c("result","filename","team"))]
  
  n = nrow(X)
  p = ncol(X)
  
  modelJAGS <- 
    "model {
  for(i in 1:n){
  result[i] ~ dbern(theta[i]);
  logit(theta[i]) <- beta0 + inprod(X[i,],beta)
  }
  
  for (j in 1:p) {
  beta[j]~dnorm(0,0.001)
  }
  
  
  beta0 ~ dnorm(0,1);
  
}"

  
  writeLines(modelJAGS,"Logistic.txt")
  
  
  data.jags <- c('result','X','n','p')
  parms <- c('beta0','beta')
  
  logisticReg.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,model.file="Logistic.txt",n.iter=10000,n.burnin=2000,n.chains=1,n.thin=1) 
  
  sims <- as.mcmc(logisticReg.sim)
  players <- as.data.frame( as.matrix(sims) )
  
  
  
  index = cbind( names(players)[grepl('beta\\[',names(players))] , 
                 as.numeric( gsub('\\]','',gsub('beta\\[','',names(players)[grepl('beta\\[',names(players))]))) )
  index = index[order( as.numeric( index[,2] ) ) , ]
  newplayers = players[,c(index[,1] , names(players)[!grepl('beta\\[',names(players))] ) ]
  names(newplayers)[grepl("beta\\[",names(newplayers))] = names(X)
  
  
  
  X = final
  X = X[ , grepl("lineup",names(X))]
  theLineup = X
  newX = cbind(result,X)
  newX = melt(newX,id="result")
  newX = newX[newX$value != 0 ,]
  lineup = newX$variable
  n = nrow(X)
  p = length(unique(newX$variable))
  
  modelJAGS <- 
    " model{
  for(i in 1:n){
  
  result[i] ~ dbern(theta[lineup[i]]) 
  
  
  }
  
  for(i in 1:p) {
  
  theta[i] ~ dbeta(1,1)
  
  }
  
  
  
  }"

  
  writeLines(modelJAGS,"bern.txt")
  
  data.jags <- c('result','lineup','n','p')
  parms <- c('theta')
  bern.sim <- jags(data=data.jags,inits=NULL,parameters.to.save=parms,model.file="bern.txt",n.iter=10000,n.burnin=2000,n.chains=1,n.thin=1) 
  sims <- as.mcmc(bern.sim)
  lineups <- as.data.frame( as.matrix(sims) )
  index = cbind( names(lineups)[grepl('theta\\[',names(lineups))] , 
                 as.numeric( gsub('\\]','',gsub('theta\\[','',names(lineups)[grepl('theta\\[',names(lineups))]))) )
  index = index[order( as.numeric( index[,2] ) ) , ]
  newlineups = lineups[,c(index[,1] , names(lineups)[!grepl('theta\\[',names(lineups))] ) ]
  names(newlineups)[grepl("theta\\[",names(newlineups))] = names(X)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  X = final
  
  
  
  Xplayers = X[ , grepl("Player",names(X))]
  Xlineup = X[ , grepl("lineup",names(X))]
  
  indexplayers = unique(Xplayers)
  indexplayers$beta0 = 1
  indexplayers$dev = 0
  
  # apply(indexplayers,1,sum)
  
  
  indexlineup = unique(Xlineup)
  indexlineup$beta0 = 1
  indexlineup$dev = 0
  
  # apply(indexlineup,1,sum)
  
  
  #newplayers = newplayers[ , -which(names(newplayers) %in% c("result"))]
  
  i = 2
  
  set.seed(1320432)
  
  catch = NA
  
  for(i in 1:nrow(indexlineup)){
    sub = newplayers[ , indexplayers[i,] == 1 ]
    sublineup = newlineups[ , indexlineup[i,] == 1 ]
    
    theta11 = exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,6])/ (1 + exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,6]))
    theta22 = sublineup[,1]
    
    
    theta11 = sample(theta11)
    theta22 = sample(theta22)
    
    catch[i] = mean(theta22 > theta11)
    
    
    
  }
  
  
  # chem = c(1:length(catch))[catch > .95]
  chem = c(1:length(catch))[catch < .05]
  
  
  
  
  i = 13
  
  for( i in chem){
    
    print( paste(i ,  sum( final[ , names(indexlineup)[i] ] ) ) )
    
    
    sub = newplayers[ , indexplayers[i,] == 1 ]
    sublineup = newlineups[ , indexlineup[i,] == 1 ]
    
    theta11 = exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,6])/ (1 + exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,6]))
    theta22 = sublineup[,1]
    
    theta2 = density(theta22)
    theta1 = density(theta11)
    
    xmax = max(c(theta1$x,theta2$x))
    xmin = min(c(theta1$x,theta2$x))
    
    ymax = max(c(theta1$y,theta2$y))
    ymin = min(c(theta1$y,theta2$y))
    
    plot(density(theta22) , xlim = c(xmin,xmax) , ylim = c(ymin,ymax))
    lines(density(theta11))
    
    
    print(mean(theta22 > theta11))
    
    
    sub$LINEUPID = names(sublineup)[1]
    sublineup$LINEUPID = names(sublineup)[1]
    
    for(nam in 1:5){
      sub[,paste0("player",nam)] = names(sub)[nam]
      sublineup[,paste0("player",nam)] = names(sub)[nam]
      
    }
    
    names(sub)[1:5] = paste0('Player',1:5)
    
    
    
    CHEMISTRYLINEUP[chemnum] = list(sublineup)
    CHEMISTRYPLAYERS[chemnum] = list(sub)
    
    chemnum = chemnum + 1
    
  }
  
  
  
}


# save.image("allteamsbad.RData")
