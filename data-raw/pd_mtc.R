## code to prepare `pdstudy` dataset goes here

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
pddrifts <- c("Bangarang", "CalCURSeas_Dalls - Copy", "PASCAL_Dalls - Copy")

pd_mtc <- index_dbdir(pddrifts, dbdir) %>%
  acoustudy(bindir, "pd", 384000, 100, 160) %>%
  dplyr::filter(detectorName=="Click_Detector_101") %>%
  nbhfilter()

usethis::use_data(pd_mtc, overwrite = TRUE)
