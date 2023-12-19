## code to prepare `ksstudy` dataset goes here

#setup -- is this section needed?
library(PAMpal)
source('R/cleaner-helpers.R')
#get file structure
basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ksdrifts <- c("PG2_02_09_CCES_023_Ksp", "PG2_02_09_CCES_022_Ksp")
#make study
ks_mtc <- index_dbdir(ksdrifts, dbdir) %>%
  acoustudy(bindir, "ks", 384000, 100, 160)
#remove duplicate events
ks_mtc <- rm_dup_evs(ks_mtc)
# remove duplicate detectors
ks_mtc <- rm_dup_dets(ks_mtc)
#remove false positive click detections
ks_mtc <- rm_fps(ks_mtc)
#save
usethis::use_data(ks_mtc, overwrite=TRUE)
