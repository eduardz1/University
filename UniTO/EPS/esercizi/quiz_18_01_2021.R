## es 1

# X ~ Exp(ratio = 1/3)

1-pexp(7.5, 1/3) # 0.082085


pexp(7.5, 1/3) # 0.917915
dgeom(3, 0.917915)

# 3] 1/p -> 1/0.917915 -> 1.089425
# 4] 7*E(X) = 7*3 = 21, var mm²

force(dataset18feb)
table(dataset18feb$genere)
# 34 M e 24 F

summary(dataset18feb$tempiPRE[dataset18feb$genere == "M"], na.rm = "T")
# mean 279.7
sd(dataset18feb$tempiPRE[dataset18feb$genere == "M"], na.rm = "T")
# sd 37.44477

quantile(dataset18feb$tempiPRE[dataset18feb$genere == "M"], na.rm = "T", 0.16)
# 249.6

boxplot(dataset18feb$tempiPRE ~ dataset18feb$genere)

# H0: mPRE - mPOST == 0
# H1: mPOST - mPRE <  0
test<-t.test(dataset18feb$tempiPRE, dataset18feb$tempiPOST, paired = TRUE, alternative = "greater")
# 0.001764


library(UsingR)
data("OrchardSprays")
hist(OrchardSprays$decrease)

data("iris")
mean(iris$Sepal.Width)
hist(iris$Sepal.Width)
skewness
