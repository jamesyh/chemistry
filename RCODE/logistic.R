library(R2jags)


load("NBA2009.RData")

dim(final)

data = final





X = final[,3:255]
n = nrow(X)
p = ncol(X)
result = final$result

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
chains2 <- as.data.frame(as.matrix(sims))

index = cbind( names(chains2)[grepl('beta\\[',names(chains2))] , 
               as.numeric( gsub('\\]','',gsub('beta\\[','',names(chains2)[grepl('beta\\[',names(chains2))]))) )

index = index[order( as.numeric( index[,2] ) ) , ]

newchains2 = chains2[,c(index[,1] , names(chains2)[!grepl('beta\\[',names(chains2))] ) ]


names(newchains2)[grepl("beta\\[",names(newchains2))] = names(X)





# save.image("DATAMAIN2009.RData")






