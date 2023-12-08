## code to prepare `ksstudy` dataset goes here

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ksdrifts <- c("PG2_02_09_CCES_023_Ksp", "PG2_02_09_CCES_022_Ksp")

ks_mtc <- index_dbdir(ksdrifts, dbdir) %>%
  acoustudy(bindir, "ks", 384000, 100, 160)

ks_mtc <- filter(ks_mtc, detectorName=="Click_Detector_101") #remove duplicate detectors
ks_mtc <- rm_dup_ev(ks_mtc) #remove duplicate events
ks_mtc <- nbhfilter(ks_mtc) # remove false positives

usethis::use_data(ks_mtc, overwrite=TRUE)
