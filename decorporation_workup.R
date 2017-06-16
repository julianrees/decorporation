# this is our first R script in decorporation

#library(rJava)
#library(xlsx)
library(ggplot2)
library(reshape2)
library(plyr)

weights <- read.csv(file = "Data/decorporation536 weights.csv")

#class(weights)
#dim(weights)
#plot(weights)
#weight1 <- weights [1:60, 2]
#weight2 <- weights [1:60, 3]
#plot(weight1)
#plot(weight2)

# --- MAKING COLUMNS ----

groups <- matrix(LETTERS[1:15])
groups <- cbind(groups, groups, groups, groups)
groups <- as.vector(t(groups))
weights <- cbind(groups, weights)
colnames(weights) <- c("group", "number", "day.0.weight", "day.2.weight")
#ggplot(weights, aes(x=group, y=day.0.weight)) + 
#  geom_point()

mweights <- melt(weights, id= c("group", "number"))

weights <- cbind(weights, weights$day.2.weight-weights$day.0.weight, (weights$day.2.weight/weights$day.0.weight)*100)
colnames(weights) <- c(colnames(weights[1:4]), "change", "percent")


#as.quoted(c("control", "DOTA/TREN", "Scn")) 
#ddply(.data=weights, .variables = (control, DOTA/TREN, Scn), .fun = mutate)

#arm <- ddply(weights, .(group), mutate)

#ddply(mexp[ which(mexp$ExpNum == i), ]
weights[ which(weights$group == "A"), ]

#--- BEGIN PLOTTING OF DATA ----

w = 0.65
fwid = 9
fhei = 6
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))

# --- WEIGHTS BY DAY AND GROUP ----

ggplot(mweights, aes(x=group, y=value))+
  geom_boxplot(aes(fill=group))+
  facet_wrap(~variable)

ggplot(mweights, aes(x=variable, y=value))+
  geom_boxplot(aes(fill=variable))+
  facet_wrap(~group)+
  scale_fill_brewer()

# --- GROSS WEIGHT CHANGE ----

ggplot(weights, aes(x=groups, y=change))+
  geom_boxplot(aes(fill=groups))

# --- PERCENT WEIGHT CHANGE ----

ggplot(weights, aes(x=groups, y=percent))+
  geom_boxplot(aes(fill=groups))

ggplot(weights, aes(x=groups, y=percent))+
  geom_point(aes(color=groups))+
  scale_color_brewer(palette = "Spectral")
  
