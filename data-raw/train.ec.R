## code to prepare `train.clust` dataset goes here

# SETUP -------------------------------------------------------------------

library(tidyverse)
library(densityClust)
# library(identidrift)
# data(train)

# GET CLICK DATA ----------------------------------------------------------

# train.ec <- lapply(train, getClickData)

# choose channel with greatest dBPP
# train.ec <- list_rbind(lapply(train.ec, choose_ch))

train.ec <- list_rbind(lapply(train, getClickData))
# ASSIGN TO CLUSTERS ------------------------------------------------------------------

dist <- train.ec %>%
  # drop metadata
  select(-c(species, eventId, UID:noiseLevel, BinaryFile, eventLabel,
            detectorName, db, Click_Detector_101_ici, All_ici)) %>%
  # drop variables to avoid creating artifacts in the cluster plot.
  select(duration:peak, Q_10dB:centerkHz_3dB) %>%
  # perform logarithmic transform for non-normally distributed variables
  mutate(log_duration = log(duration), log_Q_3dB = log(Q_3dB), log_Q_10dB = log(Q_10dB), .keep="unused") %>%
  #scale
  scale() %>%
  # calculate euclidean distances
  dist(method="euclidean")

set.seed(123)

# Perform density clustering
train.clust <- densityClust(dist)
train.clust <- findClusters(train.clust, rho=25, delta=5)

# If figure needed
plotDensityClust(train.clust)

# Add cluster assignment to click data
train.ec$clust <- train.clust$clusters

# SAVE --------------------------------------------------------------------

use_data(train.ec, overwrite = TRUE)
