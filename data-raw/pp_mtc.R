## code to prepare `ppstudy` dataset goes here
#setup -- is this section needed?
library(PAMpal)
source('R/cleaner-helpers.R')
#get file structure
basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ppdrifts <- c("CalCURSeas_Harbor - Copy", "OPPS_008_Harbor", "OPPS_010_Harbor")
#make study
pp_mtc <- index_dbdir(ppdrifts, dbdir) %>%
  acoustudy(bindir, "pp", 384000, 100, 160)
#remove duplicate events
pp_mtc <- rm_dup_evs(pp_mtc)
# remove duplicate detectors
pp_mtc <- rm_dup_dets(pp_mtc)
#remove false positive click detections
pp_mtc <- rm_fps(pp_mtc)
#save
usethis::use_data(pp_mtc, overwrite=TRUE)

