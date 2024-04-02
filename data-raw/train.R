## code to prepare `train` dataset goes here

# SETUP -------------------------------------------------------------------

library(PAMpal)
library(banter)
library(tidyverse)

# RAW DATA FILE STRUCTURE ---------------------------------------------------

#get file structure
basedir <- "C:/Users/jackv/Documents/thesis-data/TrainingData"
bindir <- file.path(basedir, "binaries")
dbdir <- file.path(basedir, "db")

#db names by species
db <- list(ks = c("PG2_02_09_CCES_023_Ksp - Copy", "PG2_02_09_CCES_022_Ksp - Copy"),
          pd = c("Bangarang_Dalls - Copy", "CalCURSeas_Dalls - Copy", "PASCAL_Dalls_TowedArray - Copy"),
          pp = c("CalCURSeas_Harbor - Copy", "OPPS_008_Harbor - Copy", "OPPS_010_Harbor - Copy"))

#full paths
db <- lapply(db, index_dbdir, dbdir)


# MAKE ACOUSTIC STUDIES ---------------------------------------------------

#make acoustic studies from NBHF training set
train <- mapply(NBHFstudy, db, names(db), MoreArgs = list(bins = bindir))

#set Species
train <- lapply(train, \(x) setSpecies(x, method="manual", value=id(x)))

#remove duplicate events
train <- lapply(train, rm_dup_evs)

#choose just one detector
train <- lapply(train, drop_detectors, keep="Click_Detector_101")

#remove clicks with duration == 0 which must be false positives
train <- lapply(train, \(x) filter(x, duration!=0))

#add ICI to events
train <- lapply(train, calculateICI)

#remove channel 2 detections from drifting buoy recordings for harbor porpoise
e <- events(train$pp)
for (i in str_which(names(e), "OPPS")){
  e[[i]] <- filter(e[[i]], Channel == 2)
}
events(train$pp) <- e

#remove channel 2 detections from drifting buoy recordings for kogia
train$ks <- filter(train$ks, Channel==2)

# SAVE --------------------------------------------------------------------

usethis::use_data(train, overwrite=TRUE)
