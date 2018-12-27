
# load("CHAINs.RData")

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


chem = c(1:length(catch))[catch > .95]





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
  
  
  
  
}




head(sub)
head(sublineup)


