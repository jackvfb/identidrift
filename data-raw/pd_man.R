## code to prepare `pd_man` dataset goes here
## code to prepare `pp_man` dataset goes here

basedir <- "C:/Users/jackv/Documents/thesis-data/man2"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")
pddrifts <- c("BNGRNG")

pd_man <- index_dbdir(pddrifts, dbdir) %>%
  acoustudy(bindir, "pd", 500000, 100, 160) %>%
  # dplyr::filter(detectorName=="Click_Detector_5") %>%
  nbhfilter()

usethis::use_data(pp_man, overwrite = TRUE)
