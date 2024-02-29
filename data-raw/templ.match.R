## code to prepare `templ.match` dataset goes here

files <- list.files("C:/Users/jackv/Documents/thesis-data/TemplateData",
                    full.names=TRUE)
names <- sapply(files, function (x) {str_remove(basename(x), "_Template.rds")})
obj <- lapply(files, readRDS)
names(obj) <- names
templ.match <- list_rbind(obj, names_to="db") %>% drop_na()

#get key to join template data with species code
key <- train.ec %>%
  distinct(db, species) %>%
  mutate(db=str_remove(basename(db), " - Copy.sqlite3"))

templ.match <- templ.match %>%
  left_join(key, by="db") %>% #join with species
  select(!ends_with("_thresh")) %>%
  pivot_longer(cols=ends_with("_match"), names_to = "best") %>%
  group_by(species) %>%
  group_by(UID) %>%
  slice_max(value, n=1) #select highest single match score for each clicks

usethis::use_data(templ.match, overwrite = TRUE)
