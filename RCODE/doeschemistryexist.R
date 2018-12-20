index = unique(X)
index$beta0 = 1
index$dev = 0

apply(index,1,sum)


index[index == 1] = T
index[index == 0] = F


sub = newchains2[ , index[1,] == 1 ]

theta1 = exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,7])/ (1 + exp(sub[,1] + sub[,2] + sub[,3] + sub[,4] + sub[,5] + sub[,7]))
theta2 = exp(sub[,7] + sub[,6])/ (1 + exp( sub[,7] + sub[,6]))

plot(density(theta1))
lines(density(theta2))
