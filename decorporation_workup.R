# this is our first R script in decorporation

#library(rJava)
#library(xlsx)
library(ggplot2)
library(reshape2)
library(plyr)

weights <- read.csv(file = "Data/decorporation536 weights.csv")


# --- MAKING COLUMNS ----

# adding groups column to weights 

groups <- matrix(LETTERS[1:15])
groups <- cbind(groups, groups, groups, groups)
groups <- as.vector(t(groups))
weights <- cbind(groups, weights)
colnames(weights) <- c("group", "number", "day.0.weight", "day.2.weight")

# melting weights into 1 column

mweights <- melt(weights, id= c("group", "number"))

# converting weights to change and % change 

weights <- cbind(weights, weights$day.2.weight-weights$day.0.weight, 
                 (weights$day.2.weight/weights$day.0.weight)*100)
colnames(weights) <- c(colnames(weights[1:4]), "change", "percent")

# adding column for arms

arm <- matrix(LETTERS[1:15])
arm <- cbind(arm, arm, arm, arm)
arm <- as.vector(t(arm))
weights <- cbind(weights, arm)
weights$arm <- as.character(weights$arm)
weights$arm[ which(groups =="B" | groups =="K" | groups =="L" | groups =="M" 
                   | groups =="N" | groups =="O") ] <- "DOTA/TREN" 
weights$arm[ which(groups =="A") ] <- "Control" 
weights$arm[ which(groups == "C" | groups =="D" | groups =="E" | groups =="F" | groups =="G"
                   | groups =="H" | groups =="I" | groups =="J") ] <- "Scn" 


#--- BEGIN PLOTTING OF DATA ----

w = 0.65
fwid = 9
fhei = 6
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))

# weights by day and group

ggplot(mweights, aes(x=group, y=value))+
  geom_boxplot(aes(fill=group))+
  facet_wrap(~variable)

ggplot(mweights, aes(x=variable, y=value))+
  geom_boxplot(aes(fill=variable))+
  facet_wrap(~group)+
  scale_fill_brewer()

# gross weight change

ggplot(weights, aes(x=groups, y=change))+
  geom_boxplot(aes(fill=groups))

# percent weight change

ggplot(weights, aes(x=groups, y=percent))+
  geom_boxplot(aes(fill = groups))

p1 <- c("#6600FF", "#9966FF", "#6633CC", "#333366", "#333399", "#3333CC", "#3333FF", "#003399", 
        "#006699", "#336666", "#339999", "#33CCCC", "#33FFFF", "#33CC99", "#66FFCC") 
p2 <- c("#FF9900", "#FF9933", "#FFCC33", "#FFCC99", "#FF9999", "#FFCCCC", "#FFCC00", "#FFFF33", 
        "#CCFF00", "#CCFFCC", "#99FFCC", "#66FFCC", "#00FFFF", "#33CCCC", "#339999") 

ggplot(weights, aes(x=groups, y=percent))+
  geom_point(aes(color=groups))+
  scale_color_manual(values = p2)

# percent weight change by arms

dota <- weights[ which(weights$arm == "Control" | weights$arm == "DOTA/TREN"), ]

ggplot(dota, aes(x=group, y=percent))+
  geom_boxplot(aes(fill = arm))+
  scale_fill_brewer(palette = "GnBu")
  
scn <- weights[ which(weights$arm == "Control" | weights$arm == "Scn"), ]

ggplot(scn, aes(x=group, y=percent))+
  geom_boxplot(aes(fill=arm))+
  scale_fill_brewer(palette = "BuGn")
