# this is our first R script in decorporation

#library(rJava)
#library(xlsx)
library(ggplot2)
library(reshape2)

weights <- read.csv(file = "Data/decorporation536 weights.csv")

#class(weights)
#dim(weights)
#plot(weights)
#weight1 <- weights [1:60, 2]
#weight2 <- weights [1:60, 3]
#plot(weight1)
#plot(weight2)

groups <- matrix(LETTERS[1:15])
groups <- cbind(groups, groups, groups, groups)
groups <- as.vector(t(groups))
weights <- cbind(groups, weights)
colnames(weights) <- c("group", "number", "day.0.weight", "day.2.weight")
#ggplot(weights, aes(x=group, y=day.0.weight)) + 
#  geom_point()

weights <- cbind(weights, weights$day.2.weight-weights$day.0.weight)
colnames(weights) <- c(colnames(weights[1:4]), "change")

mweights <- melt(weights, id= c("group", "number"))

#--- BEGIN PLOTTING OF DATA ----

w = 0.65
fwid = 9
fhei = 6
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))

ggplot(mweights, aes(x=group, y=value))+
  geom_boxplot(aes(fill=group))+
  facet_wrap(~variable)

ggplot(mweights, aes(x=variable, y=value))+
  geom_boxplot(aes(fill=variable))+
  facet_wrap(~group)

ggplot(weights, aes(x=groups, y=change))+
  geom_boxplot(aes(fill=groups))
