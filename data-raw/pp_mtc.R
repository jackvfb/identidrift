## code to prepare `ppstudy` dataset goes here

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ppdrifts <- c("CalCURSeas_Harbor - Copy", "OPPS_008 - Copy", "OPPS_010_NBHF - Copy")

pp_mtc <- index_dbdir(ppdrifts, dbdir) %>%
  acoustudy(bindir, "pp", 384000, 100, 160)

pp_mtc <- filter(pp_mtc, detectorName=="Click_Detector_101") #remove duplicate detectors
pp_mtc <- rm_dup_ev(pp_mtc) #remove duplicate events
pp_mtc <- nbhfilter(pp_mtc) # remove false positives

usethis::use_data(pp_mtc, overwrite = TRUE)

