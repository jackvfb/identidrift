## code to prepare `nbhf_studies` dataset goes here

#setup
library(PAMpal)
library(tidyverse)

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

#make acoustic studies from NBHF training set
train <- mapply(NBHFstudy, db, names(db), MoreArgs = list(bins = bindir))

#remove duplicate events
train <- lapply(train, rm_dup_evs)

#choose just one detector
train <- lapply(train, choose_named_det)

#remove clicks with duration == 0 which must be false positives
train <- lapply(train, \(x) filter(x, duration!=0))

#add ICI to events
train <- lapply(train, calculateICI)

# get echolocation click Data
train.ec <- lapply(train, getClickData)

#choose channel with greatest dBPP
train.ec <- list_rbind(lapply(train.ec, choose_ch))

#save
usethis::use_data(train, overwrite=TRUE)
usethis::use_data(train.ec, overwrite=TRUE)
