1-exp(-80000/(365^2))
1-exp(-80000/(365))

pexp(80000, (1/365)*(1/365))
pexp(80000, (1/365))

1-dbinom(0, 80000, (1/365)*(1/365))
1-dbinom(0, 80000, (1/365))

punif(15, 0, 30, lower.tail = FALSE)
punif(10, 0, 30, lower.tail = FALSE)

# X ~ Normal(500, 100²) va che conta i punteggi
# Y ~ Binomiale(pNorm) va che conta i successi
p<-pnorm(600, 500, 100)
dbinom(5, 5, p)
p2<-pnorm(640, 500, 100, lower.tail = FALSE)
dbinom(3, 5, p2)


g<-pgeom(7, 0.25)
m<-pgeom(7, 0.69)
dgeom(0, 0.25)+dgeom(1, 0.25)


pgeom(7, 0.25)*0.27 + pgeom(7, 0.69)*0.73 
# 0.9989

# P(S) = P(S|G)P(G) + P(S|M)P(M)
