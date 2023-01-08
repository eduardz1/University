## es 8.5
n<-100
p<-0.45
prop.test()
## es 8.6
## es 8.9
## es 8.10

m<-36.4
sd<-sqrt(0.5)
p1<-pnorm(37, m, sd, lower.tail = FALSE) 

m2<-36.5
sd2<-sqrt(0.6)
p2<-pnorm(37, m2, sd2, lower.tail = FALSE)

pbinom(1, 2, (p1+p2)/2)

# P = (MM, MB, BM, BB)
(p1*p2) + (p1*(1-p2)) + ((1-p1)*p2) # 0.4060139