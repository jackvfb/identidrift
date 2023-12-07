## code to prepare `ppstudy` dataset goes here

basedir <- "C:/Users/jackv/Box/Simonis Lab/Analysis/NBHF Training Data"
bindir <- file.path(basedir, "Binaries")
dbdir <- file.path(basedir, "Databases")
ppdrifts <- c("CalCURSeas_Harbor - Copy", "OPPS_008 - Copy", "OPPS_010_NBHF - Copy")

pp_mtc <- index_dbdir(ppdrifts, dbdir) %>%
  acoustudy(bindir, "pp", 384000, 100, 160) %>%
  nbhfilter()

usethis::use_data(pp_mtc, overwrite = TRUE)
