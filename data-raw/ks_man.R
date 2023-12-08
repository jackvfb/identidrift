## code to prepare `ks_man` dataset goes here

basedir <- "C:/Users/jackv/Documents/thesis-data/man2"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")
ksdrifts <- c("CCES_016", "CCES_018", "CCES_019", "CCES_021", "CCES_023")

ks_man <- index_dbdir(ksdrifts, dbdir) %>%
  acoustudy(bindir, "ks", "auto", 100, 160) %>%
  #dplyr::filter(detectorName=="Click_Detector_5") %>%
  nbhfilter()

usethis::use_data(ks_man, overwrite = TRUE)
