library(SOAR)
library(tidyverse)
indeed = read_csv("datafest2018-Updated-April12.csv")
View(indeed)
# use describe to get distributions of each variable
library(Hmisc)
sink("describe indeed.txt")
options(width = 150)
describe(indeed)
sink()
#
# use create small.R to make small files for testing 
# and for those whose computers can't read the original

