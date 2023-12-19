## code to prepare `pdstudy` dataset goes here
#setup -- is this section needed?
library(PAMpal)
source('R/cleaner-helpers.R')
#get file structure
basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
pddrifts <- c("Bangarang_Dalls - Copy", "CalCURSeas_Dalls - Copy", "PASCAL_Dalls_TowedArray - Copy")
#make study
pd_mtc <- index_dbdir(pddrifts, dbdir) %>%
  acoustudy(bindir, "pd", 384000, 100, 160)
#remove duplicate events
pd_mtc <- rm_dup_evs(pd_mtc)
# remove duplicate detectors
pd_mtc <- rm_dup_dets(pd_mtc)
#remove false positive click detections
pd_mtc <- rm_fps(pd_mtc)
#save
usethis::use_data(pd_mtc, overwrite=TRUE)

