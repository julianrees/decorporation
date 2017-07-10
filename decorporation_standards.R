library(ggplot2)
library(reshape2)
library(plyr)
library(readr)

standards_LSCcounts <- read_csv("Data/standards_LSCcounts.csv", 
                                col_types = cols(CPMA = col_integer(), 
                                                 `Count Time` = col_double(), `S#` = col_integer(), 
                                                 SIS = col_number()), skip = 3)
groups <- matrix(LETTERS[1:15])
groups <- cbind(groups, groups, groups, groups, groups, groups, groups, groups, groups, NA)
groups <- as.vector(t(groups))
standards_LSCcounts <- cbind(groups, standards_LSCcounts)

