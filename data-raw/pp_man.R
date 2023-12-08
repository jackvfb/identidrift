## code to prepare `pp_man` dataset goes here

basedir <- "C:/Users/jackv/Documents/thesis-data/man2"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")
ppdrifts <- c("OPPS_008", "OPPS_010")

pp_man <- index_dbdir(ppdrifts, dbdir) %>%
  acoustudy(bindir, "pp", "auto", 100, 160) %>%
  # dplyr::filter(detectorName=="Click_Detector_5") %>%
  nbhfilter()

usethis::use_data(pp_man, overwrite = TRUE)
