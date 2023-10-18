## 3.14
install.packages("UsingR")
library("UsingR")
data(normtemp)
plot(normtemp$temperature ~ normtemp$hr)
cor(normtemp$temperature, normtemp$hr)

# The correlation index of Pearson is very low showing close to no correlation
# between the hour of the day and temperature

## 3.15
library("UsingR")
data(fat)
str(fat)
plot(fat$body.fat ~ fat$BMI)
cor(fat$body.fat, fat$BMI)

# The correlation coefficient of Pearson is very close to 1, showing a strong
# correlation between the two variables

## 3.16
library(UsingR)
data("twins")
plot(twins$Foster ~ twins$Biological)
force(twins)
cor(twins$Biological, twins$Foster)
cor(twins$Biological, twins$Foster, method="spearman")

# Both coefficients are really high

## 3.17
?state.x77
force(state.x77)
x77<-data.frame(state.x77)
plot(x77$Population ~ x77$Frost)
cor(x77$Population, x77$Frost)
# -0.3321525 so the correlation is not significant

plot(x77$Population ~ x77$Murder)
cor(x77$Population, x77$Murder)
# 0.3436428 so the correlation is not significant

plot(x77$Population ~ x77$Area)
cor(x77$Population, x77$Area)
# 0.02254384 so the correlation is basically non-existent

plot(x77$Income ~ x77$HS.Grad)
cor(x77$Income, x77$HS.Grad)
# 0.6199323 so there is a measurable direct correlation

## 3.18
library(UsingR)
data("nym.2002")
# I expect there to be an inverse correlation between age and finishing time
# meaning that the younger athletes on average should be faster
cor(nym.2002$age, nym.2002$time)
# 0.1898672 so the correlation is actually very low, how interesting

## 3.19
?state.center
center<-data.frame(state.center)
force(center)
plot(y~x, data=state.center)
# Interestingly we can see the USA's shape in the plot

## 3.20
library("UsingR")
data(batting)
plot(batting$SO ~ batting$HR)
cor(batting$SO, batting$HR)
# There is a strong correlation between the two variables, in particular we can see
# that the two variable are directly proportional. In general thogh there are 
# diminishing returns at the increase in strike outs

## 3.23 pt. 1
library(MASS)
data(wtloss)
plot(wtloss$Weight ~ wtloss$Days)
# The weight decreases during the passing of days, as expected
cor(wtloss$Weight, wtloss$Days)
# The Pearson coefficient is -0.9853149, indicating a strong inverse correlation






