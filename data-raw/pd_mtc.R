## code to prepare `pdstudy` dataset goes here
library(PAMpal)

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
pddrifts <- c("Bangarang", "CalCURSeas_Dalls - Copy", "PASCAL_Dalls - Copy")

pd_mtc <- index_dbdir(pddrifts, dbdir) %>%
  acoustudy(bindir, "pd", 384000, 100, 160)

pd_mtc <- filter(pd_mtc, detectorName=="Click_Detector_101") #remove duplicate detectors
pd_mtc <- rm_dup_ev(pd_mtc) #remove duplicate events
pd_mtc <- nbhfilter(pd_mtc) # remove false positives

usethis::use_data(pd_mtc, overwrite = TRUE)
