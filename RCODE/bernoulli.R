library(R2jags)
library(reshape2)

load("NBA2009.RData")

rm(list = (ls()[ls() != "final"]))

# final = final[final$team == unique(final$team)[1:30] , ]

THEfinal = final

for(teamnum in 1:30)

final = THEfinal


final = final[final$team == "SAS" , ]


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

# save.image("CHAINs.RData")







