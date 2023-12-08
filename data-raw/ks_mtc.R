## code to prepare `ksstudy` dataset goes here

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ksdrifts <- c("PG2_02_09_CCES_023_Ksp", "PG2_02_09_CCES_022_Ksp")

ks_mtc <- index_dbdir(ksdrifts, dbdir) %>%
  acoustudy(bindir, "ks", 384000, 100, 160) %>%
  dplyr::filter(detectorName=="Click_Detector_101") %>%
  nbhfilter()

usethis::use_data(ks_mtc, overwrite=TRUE)
