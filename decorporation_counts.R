library(ggplot2)
library(reshape2)
library(plyr)
library(readr)
counts <- read_csv("~/Projects/Decorporation/Development/decorporation/Data/ExpandedLSC_man.csv", 
                            col_types = cols(Group = col_factor(levels = c("Background", 
                                                                           "A", "B", "C", "D", "E", "F", "G", 
                                                                           "H", "I", "J", "K", "L", "M", "N", 
                                                                           "O")), 
                                             Sample = col_factor(levels = c("Background", "Organ", "PE1", "PE2", 
                                                                            "PE3", "Urine", "Feces")), 
                                             Source = col_factor(levels = c("Background", "Aliquot1", "Aliquot2", 
                                                                            "Aliquot3", "Day1", "Day2", "Spleen", 
                                                                            "Kidneys", "ART", "Liver", "Heart", 
                                                                            "Lungs", "Thymus", "Soft", "Skel")), 
                                             Type = col_factor(levels = c("Background", "Mouse", "Excreta", "Standard"))))
                                                               
# add a column for correcting the CPM
counts <- cbind(counts, counts$CPM)
colnames(counts) <- c(colnames(counts)[-ncol(counts)], "correctedCPM")

# for each group, normalize the CPM to the mean of the standards
for(i in seq(1:length(levels(counts$Group)))){
  corr <- mean(counts$CPM[ which(counts$Group == levels(counts$Group)[i] & counts$Type == "Standard")])
  counts$correctedCPM[ which(counts$Group == levels(counts$Group)[i])] <- 
  counts$correctedCPM[ which(counts$Group == levels(counts$Group)[i])] * 100 / corr
  print(i)
}

# temporary ballpark adjustment of the PE bottle dilutions
counts$correctedCPM[ which(counts$Type == "Excreta")] <- counts$correctedCPM[ which(counts$Type == "Excreta")] * 12

# change the Group levels to compounds
levels(counts$Group) <- c("Background", "Control", "DOTA", "HOPO", "Bbn", 
                               "Scn-HOPO", "Scn-Bbn", "IgG-Scn-HOPO", "IgG-Scn-Bbn",
                               "Fab-Scn-HOPO", "Fab-Scn-Bbn", "TrenCAM", "TrenSAL", 
                               "DOTP", "HHHHH", "Me-3,2-HOPO")
levels(counts$Group)

#---- BEGIN PLOTTING ----
w = 0.65
fwid = 9
fhei = 6
theme_set(theme_bw())
theme_update(plot.title = element_text(hjust = 0.5))


ggplot(counts[ which(counts$Type == "Standard"), ], 
       aes(x = Group, y = CPM)) + 
  geom_boxplot(aes(fill = Group)) + 
  scale_x_discrete(labels = LETTERS[1:15]) +
  ylab("Counts / min") +
  ggtitle('"Plastic Mouse" Standards') + 
  ggsave(filename = 'Figures/standards.png',
         width = fwid, height = fhei, units = "in")

ggplot(counts[ which(counts$Type == "Standard"), ], 
       aes(x = Group, y = CPM, by = Sample)) + 
  geom_boxplot(aes(fill = Group)) + 
  ylab("Counts / min") +
  scale_x_discrete(labels = LETTERS[1:15]) +
  ggtitle('"Plastic Mouse" Standards by Injection') + 
  ggsave(filename = 'Figures/standards_reproducibility.png',
         width = fwid, height = fhei, units = "in")
                                                                                                                                                                                                                                                                                                                                        
ggplot(counts[ which(counts$Type == "Mouse" | counts$Type == "Excreta"), ] , 
       aes(x = Group, y = correctedCPM)) + 
  geom_col(aes(fill = Source, alpha = Sample)) + 
  scale_alpha_manual(values = c(1, 0.4, 1)) +
  facet_wrap(~Type) + 
  ylab("Standard-Corrected Counts / min") +
  scale_x_discrete(labels = LETTERS[1:15]) +
  ggtitle('Retained vs. Excreted Activity (not finalized scaling of excreta)') + 
  ggsave(filename = 'Figures/retained_excreted.png',
         width = fwid, height = fhei, units = "in")

ggplot(counts[which(counts$Source == "ART" | 
                      counts$Source == "Liver"), ], 
       aes(x = Group, y = correctedCPM)) + 
  geom_boxplot(aes(fill = Group)) + 
  facet_wrap(~Source) + 
  ylab("Standard-Corrected Counts / min") +
  scale_x_discrete(labels = LETTERS[1:15]) +
  ggtitle('Majority Retained Activity') + 
  ggsave(filename = 'Figures/major_retained.png',
         width = fwid, height = fhei, units = "in")

ggplot(counts[which(counts$Source != "ART" & 
                      counts$Source != "Liver" & 
                      counts$Source != "Skel" &
                      counts$Type == "Mouse"), ], 
       aes(x = Group, y = correctedCPM)) + 
  geom_boxplot(aes(fill = Group)) + 
  facet_wrap(~Source) + 
  ylab("Standard-Corrected Counts / min") +
  scale_x_discrete(labels = LETTERS[1:15]) +
  ggtitle('Minority Retained Activity (w/o Skeleton)') + 
  ggsave(filename = 'Figures/minor_retained.png',
         width = fwid, height = fhei, units = "in")

ggplot(counts[which(counts$Source == "Skel"), ], 
       aes(x = Group, y = correctedCPM)) + 
  geom_boxplot(aes(fill = Group)) + 
  scale_x_discrete(labels = LETTERS[1:15]) +
  ylab("Standard-Corrected Counts / min") +
  ggtitle('Retained Skeletal Activity') + 
  ggsave(filename = 'Figures/skeleton.png',
         width = fwid, height = fhei, units = "in")

ggplot(counts[which(counts$Source == "Day1" | 
                      counts$Source == "Day2"), ], 
       aes(x = Group, y = correctedCPM)) + 
  geom_col(aes(fill = Group, alpha = Sample), color = "black") + 
  scale_alpha_manual(values = c(0.4, 1)) +
  facet_wrap(~Source) + 
  ylab("Standard-Corrected Counts / min") +
  scale_x_discrete(labels = LETTERS[1:15]) +
  ggtitle('Excreted Activity') + 
  ggsave(filename = 'Figures/excreted.png',
         width = fwid, height = fhei, units = "in")

 ggplot(counts[ which(counts$Type == "Mouse"), ], 
        aes(x = Source, y = correctedCPM)) + 
   geom_boxplot(aes(fill = Source)) + 
   facet_wrap(~Group) + 
   ylab("Standard-Corrected Counts / min") +
   scale_x_discrete(labels = c("Sp","K","A","Lv","H","Ln","T","Sf","Sk")) + 
   ggtitle('Retained Activity by Organ') + 
   ggsave(filename = 'Figures/activity_byorgan.png',
          width = fwid, height = fhei, units = "in")
