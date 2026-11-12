# Builds the three small teaching datasets used in Session 6 (types, anomalies, missingness).
# Run once from the project root:  Rscript scripts/make-s6-data.R
suppressMessages(library(tidyverse))
dir.create("data", showWarnings = FALSE)

# 1. vitals: heart rate and steps with sentinels (-999, -1) and impossible values (0, 300)
set.seed(531)
n <- 1000
vitals <- tibble(hr = round(rnorm(n, 72, 11)), steps = round(rlnorm(n, log(6500), 0.5)))
vitals$hr[sample(n, 30)] <- -999
vitals$hr[sample(n, 8)]  <- 0
vitals$hr[sample(n, 4)]  <- 300
vitals$steps[sample(n, 25)] <- -1
write_csv(vitals, "data/s6_vitals.csv")

# 2. users: ten records that break known rules (counts are known on purpose)
users <- tibble(
  id     = c(1, 2, 3, 3, 5, 6, 7, 8, NA, 10),
  age    = c(34, 29, 151, 45, -2, 38, 52, NA, 41, 27),
  device = c("watch", "band", "ring", "watch", "Watch", "band", "ring", "watch", "band", "phone"),
  zip    = c("97201", "9720", "97214", "97201", "97201-1234", "97005", "97006", "97201", NA, "97211"),
  start  = ymd("2026-01-01") + c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
  end    = ymd("2026-01-01") + c(5, 0, 4, 2, 9, 9, 5, 10, 12, 5)
)
write_csv(users, "data/s6_users.csv")

# 3. steps_sim: a simulation where the TRUE steps are known (real data never gives you this).
#    Legacy devices lose steps more often (missing at random given device).
set.seed(531)
n <- 2000
steps_sim <- tibble(device = sample(c("new", "legacy"), n, replace = TRUE, prob = c(.6, .4)),
                    age    = round(rnorm(n, 40, 12))) |>
  mutate(mu = if_else(device == "new", 8500, 5500) - 60 * (age - 40),
         steps_true = round(pmax(0, rnorm(n, mu, 2000))),
         p = if_else(device == "legacy", 0.55, 0.08),
         steps = if_else(runif(n) < p, NA_real_, steps_true)) |>
  select(device, age, steps_true, steps)
write_csv(steps_sim, "data/s6_steps_sim.csv")
