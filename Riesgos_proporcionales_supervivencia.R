### Comprobar si se verifica la condicion de "riesgos proporcionales"
library(pacman)
p_load(survival)
p_load(survminer)
p_load(Hmisc)
p_load(rms)


## Para un sola curva de supervivencia:
# Kaplan-Meier
data(lung)

fit <- survfit(surv_object ~ 1, data = vacantib, type = "kaplan-meier")
summary(fit1)
ggsurvplot(fit1, xlab = "Dosis", ylab = "Survival probability")
# estimacion de la media y cuantiles de los tiempos de supervivencia
print(fit1, print.rmean = TRUE, rmean = 4)
quantile(fit1, c(0.05, 0.5, 0.95))

# Funcion de riesgo acumulado
H <- round(cumsum(fit1$n.event/fit1$n.risk)*100 , 2); H
ggplot(data.frame(x = log(fit1$time), y = log(H))) + geom_point(aes(x, y)) +
  xlab("log(Time)") + ylab("log(Cumulated Hazard)") + 
  geom_smooth(aes(x, y), method = "lm", se = F, linetype = 3, size = 0.3)

ggplot(data.frame(x = log(fit1$time), y = 5.25*log(-log(fit1$surv)))) + geom_point(aes(x, y)) +
  xlab("log(Time)") + ylab("log(-log(Survival))") + 
  geom_smooth(aes(x, y), method = "lm", se = F, linetype = 3, size = 0.3)

plot(log(fit1$time), log(-log(fit1$surv)))
plot(fit1, fun = "cloglog")