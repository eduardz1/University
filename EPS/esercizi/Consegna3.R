library(UsingR)
data("iris")
setosa<-iris$Petal.Width[iris$Species == "setosa"]
setosa
mean(setosa)

virginica<-iris$Petal.Width[iris$Species == "virginica"]
virginica
mean(virginica)

t.test(setosa, virginica, alternative = "less")

length(virginica)
length(setosa)

##
hist(iris$Sepal.Width)
summary(iris$Sepal.Width)
sd(iris$Sepal.Width)
?iris
str(iris$Sepal.Width)
skewness<-sum((iris$Sepal.Width - mean(iris$Sepal.Width))/sd(iris$Sepal.Width))^3/length(iris$Sepal.Width)
skewness
table(iris$Species)

mean(iris$Sepal.Width[iris$Species == "setosa"])
boxplot(iris$Sepal.Width[iris$Species == "setosa"], iris$Sepal.Width[iris$Species == "virginica"])
mean(iris$Sepal.Width[iris$Species == "virginica"])
boxplot(iris$Sepal.Length[iris$Species == "setosa"], iris$Sepal.Length[iris$Species == "virginica"], iris$Sepal.Length[iris$Species == "versicolor"])

## 2
data(OrchardSprays)
force(OrchardSprays)
str(OrchardSprays)

hist(OrchardSprays$decrease)
summary(OrchardSprays$decrease)
var(OrchardSprays$decrease)

quantile(OrchardSprays$decrease, 0.10)
boxplot(OrchardSprays$decrease)

table(OrchardSprays$treatment)
!is.na(OrchardSprays$treatment)

# decrease in volume means that more bees are consuming it
plot(OrchardSprays$treatment, OrchardSprays$decrease)
?OrchardSprays
