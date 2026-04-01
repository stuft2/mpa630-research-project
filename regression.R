#Assignment 4
#Author: Allie Sensinger, Alan Canfield, Bailey Whitaker, Lori Sheets, Spencer Tuft
#Date: 04/2026

#####----------------------------------------------#####
#0. SYSTEM SETUP

if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}

p_load(dplyr, readr, fixest)

# Load cleaned ANES data
dt <- read_csv("anes_all_cleaned_vars.csv", show_col_types = FALSE)

# Set categorical references for the main regression
dt <- dt |>
  mutate(
    income = relevel(factor(income_category), ref = "$100,000+"),
    race = relevel(factor(race_clean), ref = "White, non-Hispanic"),
    education = relevel(factor(education_category), ref = "High school graduate"),
    sex = relevel(factor(sex_clean), ref = "Male"),
    party = relevel(factor(party_clean), ref = "Independent")
  )

#####----------------------------------------------#####

# 1. Main regression: LPM using trust_binary
lpm <- feols(trust_binary ~ income + race + education, data = dt, vcov = "hetero")
summary(lpm)


# 2. Confirmation model: logit with the same specification
logit <- feglm(
  trust_binary ~ income + race + education,
  data = dt,
  family = binomial(link = "logit"),
  vcov = "hetero"
)

summary(logit)


# 3. Controls summary for variables of interest
controls_summary <- dt |>
  select(age_clean, sex, party, state_clean) |>
  summary()

print(controls_summary)
