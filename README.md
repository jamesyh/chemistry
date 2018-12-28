# Chemistry in 2009-10 NBA Data

# Introduction
People often refer to a group of players as having chemistry or that they play better together than alone. The current warriors have their "death-lineup" which many claim is the best collective group on the floor in today's game. One of my favorite references to chemistry in sports is Ricky Bobby's and his partners "shake-and-bake" where they used team work to win nascar races. For this project, I created two separate Bayesian models to compare chemistry. 

# Model
The main objective in basketball is to get the ball through the net at a higher rate than your opponents. For this project the dependent variable is whether the team scored or not. For model 1, I modeled the dependent variable with a Bernoulli likelihood with the parameter ![theta](https://latex.codecogs.com/gif.latex?%7B%5Ctheta_i%7D) where i goes from 1 to the number of unique five player lineups a team has. For the prior distribution, I used a Beta distributions with parameters 1 and 1. With Model 2, I also chose to use a Bernoulli likelihood to model ![theta](https://latex.codecogs.com/gif.latex?%7B%5Ctheta%7D) but I used logistic regression model as my prior. Each ![beta](https://latex.codecogs.com/gif.latex?%7B%5Cbeta_k%7D) represents a player on the team for k from 1 to l. I used normal distributions as the priors for each ![beta](https://latex.codecogs.com/gif.latex?%7B%5Cbeta). I qualified a lineup as being valid if it appeared in 3 or more games during the season.


Model 1:<br/>
Likelihood<br/>
![first equation](https://latex.codecogs.com/gif.latex?%7By_i%20%24%5Csim%24%20Bern%28%5Ctheta_i%20%29%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%20j%3D1%2C...%2Cm%2Ci%3D1%2C...%2Cn%7D)<br/><br/>
Prior<br/>
![first equation](https://latex.codecogs.com/gif.latex?%7B%5Ctheta_i%20%24%5Csim%24%20Beta%281%2C1%29%20%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%20i%3D1%2C...%2Cn%7D)

Model 2:<br/>
Likelihood<br/>
![first equation](https://latex.codecogs.com/gif.latex?%7By_j%20%24%5Csim%24%20Bern%28%5Ctheta%29%20%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2Cj%3D1%2C...%2Cm%7D)<br/><br/>
Priors<br/>
![first equation](https://latex.codecogs.com/gif.latex?%7Blogit%28%5Ctheta%29%3D%5Cbeta_0&plus;%5Cbeta_1*I_%7Bplayer_1%7D&plus;...&plus;%5Cbeta_k*I_%7Bplayer_k%7D%7D)<br/>
![](https://latex.codecogs.com/gif.latex?%7B%5Cbeta_k%20%24%5Csim%24%20Norm%280%2C1%29%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2C%5C%2Ck%3D1%2C...%2Cl%7D)

# Hypotheses
There are two separate hypotheses that I tested using these two models.

Hypothesis 1: The probability of scoring is greater for the lineup modeled in model 1 than the probability of those same 5 players in model 2.

Hypothesis 2: The probability of scoring is greater for 5 players in model 2 than the probability of the corresponding lineup from model 1.

Hypothesis 1 is essentially asking if a specific set of 5 players play better together than they normally do. Hypothesis 2 is asking if there are 5 players who play worse when they are on the court at the same time.


# Results

The following table shows 10 lineups that prove Hypothesis 1. For these 10 lineups when the 5 players are together the probability of them scoring is greater than when they are not playing together. The column count is the number of times the lineup shot the basketball. Total is the total shots that the team made during the season. Percent shows the percent the lineup made of all the teams shots.

For the plot of the distribution I chose Boston's lineup consisting of Kevin Garnett, Paul Pierce, Rajon Rondo, Rasheed Wallace, and Ray Allen. These players play better together and have chemistry on the court. 

![alt text](https://github.com/jamesyh/chemistry/blob/master/images/chemistry-index.png)
![alt text](https://github.com/jamesyh/chemistry/blob/master/images/boston-chemistry.png)

The following table shows 10 lineups for what i've called anti-chemistry. Which is when the probability of the team scoring goes down when those 5 players are on the floor. These lineups prove hypothesis 2.

For the plot of the distribution, I chose Orlando's lineup of Dwight Howard, Jameer Nelson, Matt Barnes, Rashard Lewis, and Vince Carter.

![alt text](https://github.com/jamesyh/chemistry/blob/master/images/anti-chemistry-index.png)
![alt text](https://github.com/jamesyh/chemistry/blob/master/images/orlando-anti-chemistry.png)
