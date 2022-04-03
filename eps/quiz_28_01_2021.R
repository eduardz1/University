## es 1

n_sensors<-10
# Xi ~ Exp(rate)
# restituisce il tempo di rottura del sensore i
Xi_mean<-320 # giorni
Xi_rate = 1/Xi_mean

# Z ~ Binom(N=10, p)
# restituisce il numero di sensori attivi dato che:
# active only if at least 6 sensors are active (>=)
n_min<-6

# A = "il sistema di controllo è attivo"

# 1] probabilità che uno si rompa prima di 480 giorni
pexp(480, Xi_rate) # 0.7768698


# 2] probabilità che il sistema sia attivo a 480 giorni
# P(Z >= n_min) == 1 - P(Z < n_min)
# Binom(10, p) con p->"P che il singolo sensore sia attivo a 480gg"
p<-1-pexp(480, Xi_rate)
1-pbinom(5, 10, p) # we convert [6, +inf) in [0, 5] so that it can be calculated
# 0.0111669 is the probability that the system will still work after 480 days


# 3] new sensors with mean 380 but only half of them are like new
#    probability that a random sensor breaks before 480 days?
# Y ~ Bernulli(p) with p=0.5
p_s1<-pexp(480, Xi_rate)
p_s2<-pexp(480, (1/380))

p<-(p_s1+p_s2)/2
p # 0.7470551



## 2
force(data)
str(data)
data_AC<-data$var[data$gruppo != "B"]
data_AC<-data_AC[!is.na(data_AC)]
mean(data_AC) # 163.2952
median(data_AC) # 115.8989

quantile(data_AC, 0.6) # inferiore
# 3] 149.9388
# complementare da fare se leggo superiore

table(data$gruppo)
sum<-132 + 144
144/sum
# 4] 0.5217391

box<-boxplot(data$var[data$gruppo == "C"])
box$stats# 5] falso

# H0: mA - mC == 0
# H1: mA - mC != 0

a<-as.numeric(data$var[data$gruppo == "A"])
c<-as.numeric(data$var[data$gruppo == "C"])
t.test(a, c, alternative="two.sided")
# p-value 0.1551
# Il test non porta sufficiente evidenza per abbandonare l'ipotes nulla

