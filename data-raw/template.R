## code to prepare `template` dataset goes here

files <- list.files("C:/Users/jackv/Documents/thesis-data/TemplateData",
                    full.names=TRUE)
names <- sapply(files, function (x) {str_remove(basename(x), "_Template.rds")})
obj <- lapply(files, readRDS)
names(obj) <- names
template <- list_rbind(obj, names_to="db") %>% drop_na()

key <- nbhf_clicks %>%
  distinct(db, species) %>%
  mutate(db=str_remove(basename(db), " - Copy.sqlite3"))

template <- template %>%
  left_join(key, by="db") %>%
  select(!ends_with("_thresh")) %>%
  pivot_longer(cols=ends_with("_match"), names_to = "best") %>%
  group_by(species) %>%
  group_by(UID) %>%
  slice_max(value, n=1)

usethis::use_data(template, overwrite = TRUE)
