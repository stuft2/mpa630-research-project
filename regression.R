##### ----------------------------------------------#####
# Assignment 4
# Author: Allie Sensinger, Alan Canfield, Bailey Whitaker, Lori Sheets, Spencer Tuft
# Date: 04/2026
##### ----------------------------------------------#####

if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}

p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl, Hmisc, fixest, performance)

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

summary(logit, vcov = "hetero")

# Transform the bachelor's degree logit coefficient into a percent change in odds
b <- coef(logit)["educationBachelor's degree"]
exp_b <- exp(b)
pct_change <- (exp_b - 1) * 100

# 3. Robustness checks

# a) Collinearity
check_collinearity(lpm)

# b) Change of controls
dt <- dt |>
  mutate(
    marital = relevel(factor(marital_simple), ref = "Married")
  )

controls <- feols(
  trust_binary ~ income + race + education + sex + age_clean + marital + party,
  data = dt,
  vcov = "hetero"
)

summary(controls)
