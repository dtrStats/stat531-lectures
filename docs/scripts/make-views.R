# Generates data/views.parquet: a simulated streaming-views log for the arrow demo.
# Every row is one viewing event of a title from movies.csv. The data are SIMULATED.
# Usage (from the project root):  Rscript scripts/make-views.R
library(tidyverse)

set.seed(531)
n_rows <- 4e6

movies <- read_csv("data/movies.csv", show_col_types = FALSE) |>
  distinct(title, .keep_all = TRUE) |>
  filter(!is.na(runtime))

# More popular titles are watched more often
p <- movies$imdb_num_votes^0.6
views <- tibble(
  view_id   = seq_len(n_rows),
  title     = sample(movies$title, n_rows, replace = TRUE, prob = p),
  user_id   = sample.int(250000, n_rows, replace = TRUE),
  country   = sample(c("US", "CA", "UK", "DE", "BR", "IN", "JP", "AU"), n_rows, replace = TRUE,
                     prob = c(.38, .08, .12, .09, .10, .12, .07, .04)),
  device    = sample(c("TV", "Phone", "Laptop", "Tablet"), n_rows, replace = TRUE,
                     prob = c(.45, .25, .22, .08)),
  view_date = as.Date("2024-01-01") + sample.int(366, n_rows, replace = TRUE) - 1L
)
rt <- movies$runtime[match(views$title, movies$title)]
views <- views |>
  mutate(
    minutes   = round(pmin(rt, rt * rbeta(n_rows, 2, 1.2)), 1),
    completed = minutes >= 0.9 * rt
  ) |>
  arrange(view_date, view_id)

if (requireNamespace("arrow", quietly = TRUE)) {
  arrow::write_parquet(views, "data/views.parquet")   # default snappy compression, readable by every arrow build
  message("Wrote data/views.parquet")
} else {
  write_csv(views, "views_tmp.csv")
  message("arrow not installed: wrote views_tmp.csv instead")
}
