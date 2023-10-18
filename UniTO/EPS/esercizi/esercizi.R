# exp distribution
pexp(2.2, 1.5, lower.tail = FALSE)
pexp(1.73, 1.5)
1/1.5


# norm distribution
m<-3.8
sd<-0.3
pnorm(4.1, m,sd)
pnorm(4.25, m, sd)-pnorm(3.95, m, sd)


 mu<--2
 var<-4
 sd<-sqrt(var)
 pnorm(0, mu, sd, lower.tail = FALSE)
 
 
 pexp(200, 1/100, lower.tail = FALSE)
 # P(X>200 | X=130) = P(X>70)
 pexp(70, 1/100, lower.tail = FALSE)
 
 
 mu<-300
 sd<-290
 
 mus<-250
 sds<-135
 
 5*mu + mus
 
 # Var(aX) = a²Var(X)
 # Var(sd) = sqrt(sd) 
 # Var(sds) = sqrt(sds)
 # Var(5*sd) = 25Var(sd)
 sdt<-sqrt(25*(sd²) + (sds²))
sdt 

# P(X<300)
p_perdita<-pnorm(0, mu, sd)

# P(X>=3) -> 1-P(X<2)
pbinom(2,5,1-p_perdita, lower.tail = FALSE)


mu<-160
t<-480

# P(X1>=480) -> 1-P(X1<479)
p<-1-pexp(480, 1/160)
p

# P(X>=1) -> 1-P(X=0)
1-dbinom(0, 6, p)


mu<-36.4
var<-0.5
sd<-sqrt(var)

mu2<-36.5
var2<-0.6
sd2<-sqrt(var2)

pnorm(37, mu, sd, lower.tail = FALSE)
1-(pnorm(37,mu, sd, lower.tail = F)*pnorm(37, mu2, sd2, lower.tail = F))


a<-4
b<-18
punif(9, 4, 18, lower.tail = F)

# P(X>=1)-> 1-P(X=0)
p<-punif(9, 4, 18)
1-dbinom(0, 5, p)
m<-(a+b)/2
m
var<-((b-a)*(b-a))/12
var

m<-60
var<-71
sd<-sqrt(var)
# P(X>=80)
pnorm(80, m, sd, lower.tail = F)
# P(X>=1) -> 1-P(X=0)
p<-1-pnorm(80, m, sd, lower.tail = F)
1-dbinom(0, 2, p)


mu<-8
pexp(16, 1/mu, lower.tail = F)
pexp(12, 1/mu) - pexp(4, 1/mu)
# 1/delta² -> 1/(1/8²)
1/(1/(8*8))


mu<--1
var<-9
sd<-sqrt(var)
pnorm(-5, mu, sd)
pnorm(-1.5, mu, sd, lower.tail = F)
pnorm(1, mu, sd)
pnorm(3, mu, sd) - pnorm(1, mu, sd)
dnorm(1, mu, sd)

library(UsingR)
data(cars)
str(cars)
std_speed<-cars$speed*1.6093
str(std_speed)
hist(std_speed)
summary(std_speed)
quantile(std_speed, 0.95)
boxplot(std_speed)

std_dist<-cars$dist*0.3048
plot(std_dist ~ std_speed)

t.test(std_dist, conf.level = 0.95)
str(std_dist)


data(mtcars)
str(mtcars)
std_wt<-mtcars$wt*453.59
hist(std_wt)
summary(std_wt)
quantile(std_wt, 0.9)
boxplot(std_wt)
quantile(std_wt)

skewness<-sum(((std_wt-mean(std_wt))/sd(std_wt))^3)/length(std_wt)
skewness
std_mpg<-mtcars$mpg*0.4251
plot(std_mpg ~ std_wt)

t.test(std_mpg, conf.level = 0.99)
str(std_mpg)
