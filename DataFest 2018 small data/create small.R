# use create small.R to make small files for testing 
# and for those whose computers can't read the original
library(SOAR)
library(tidyverse)
library(Hmisc)

## using the original data indeed
## create new variable uniqueJobId using companyid and jobid
## info from the video and the QandA files indicate that 
## both company and jobid are needed to identify a specific job

test = indeed %>% 
#  sample_n(30000,replace = FALSE) %>% 
  mutate(UniqueID = str_c(companyId,jobId,sep="-"))
View(test)

## use SOAR to Store indeed since we won't need it 
## while debugging this code
Store(indeed)

## create df with just 1 record for each unique UniqueID
##  use that to create samples w/o replacement 
##  Small (20K), Smaller (10K), Smallest (5K)
##  use left_join for each sample to get all the records from test
##  for each UniqueID in the sample
UniqueJobId = test %>% 
  group_by(companyId, jobId, UniqueID) %>% 
  summarise(Nrecords = n()) %>% 
  select(companyId, jobId, UniqueID, Nrecords)
View(UniqueJobId)
# result has  521,347 entries
Store(test)  # use unclutterworkspace to remove test after making the small files
Small.20K = UniqueJobId %>% 
  ungroup() %>% 
  sample_n(20000,replace = FALSE)
View(Small.20K)
#
Small.10K = UniqueJobId %>% 
  ungroup() %>% 
  sample_n(10000,replace = FALSE)
View(Small.10K)
#
Small.5K = UniqueJobId %>% 
  ungroup() %>% 
  sample_n(5000,replace = FALSE)
View(Small.5K)
# now use left_join for each Small to merge all records in indeed for each 
# unique job
# SOAR automatically brings indeed back into memory "on demand"
# left_join automatically joins on by = c("companyId", "jobId")
indeed.5K = Small.5K %>% 
  left_join(indeed) %>% 
  select (-c(Nrecords,UniqueID)) # remove this from file give to students
View (indeed.5K) ## 140,850 entries
#
indeed.10K = Small.10K %>% 
  left_join(indeed) %>% 
  select (-c(Nrecords,UniqueID)) # remove this from file give to students
View (indeed.10K) ## 284,513 entries
#
indeed.20K = Small.20K %>% 
  left_join(indeed) %>% 
  select (-c(Nrecords,UniqueID)) # remove this from file give to students
View (indeed.20K)  ## 565,148 entries
#
Store(indeed) # move the original data out of memory
# use unclutterWorkspace to clean up
# get rid of test 
Remove(test) # removes from the cache
# use Ls() to verify that only indeed is in the cache
Ls()

unclutterworkspace() # keep this function!!
# write csv files 
# write_csv(df, "df.csv")

write_csv(indeed.5K, "data5K.csv")
write_csv(indeed.10K, "data10K.csv")
write_csv(indeed.20K, "data20K.csv")

library(Hmisc)
#
sink("describe data5K.txt")
  options (width=150)
  describe(indeed.5K)
sink()
#
sink("describe data10K.txt")
  options (width=150)
  describe(indeed.10K)
sink()
#
sink("describe data20K.txt")
  options (width=150)
  describe(indeed.20K)
sink()

# use SOAR (Store) to put the small data files in the cache
# then do not save the workspace on exit
Store(indeed.10K, indeed.20K, indeed.5K)
