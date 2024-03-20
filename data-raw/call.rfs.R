## code to prepare `calls.rf` dataset goes here

# SETUP -------------------------------------------------------------------

library(tidyverse)
library(randomForest)
library(rfPermute)
# library(identidrift)
# data(train.ec)


# DATA PREP ---------------------------------------------------------------

datarf <- train.ec %>%
  # drop metadata
  select(-c(eventId, UID:noiseLevel, BinaryFile, eventLabel, detectorName, db,
            Click_Detector_101_ici, All_ici)) %>%
  mutate(species = as.factor(species), clust = as.factor(clust))

# Balanced sample size will be min of all classes, considering both species AND
# clust as the response var

ss <- min(balancedSampsize(datarf$species), balancedSampsize(datarf$clust))

# TRAIN RFs -----------------------------------------

# Cluster as response variable


clustrf <- randomForest(formula = clust ~ .,
                       data = select(datarf, -species),
                       sampsize = rep(ss, 3),
                       proximity = TRUE,
                       importance = TRUE)

# Species as response variable

sprf <- randomForest(formula = species ~ .,
                    data = select(datarf, -clust),
                    sampsize = rep(ss, 3),
                    proximity = TRUE,
                    importance = TRUE)

call.rfs <- list(species = sprf, cluster = clustrf)

usethis::use_data(call.rfs, overwrite = TRUE)
