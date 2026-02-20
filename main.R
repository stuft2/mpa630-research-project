# 0) load your dataset for your project (whatever you chose in Assignment 1)
anes <- read.csv("20250808.csv")
library(dplyr)

# 1) select 15 variables you are interested in AND
# 2) rename these variables for something that makes sense:
data <- anes |>
  select(
    trust_fed_gov = "V241229",
    gov_run_by_big_interests = "V241231",
    gov_wastes_tax_money = "V241232",
    household_income_cat = "V241566x",
    race_ethnicity_summary = "V241501x",
    education_attainment = "V241509",
    party_id_7pt = "V241227x",
    ideology_7pt = "V241177",
    congress_approval = "V241129x",
    age = "V241632",
    gender = "V241551",
    sex = "V241550",
    marital_status = "V241505",
    natl_econ_retrospective = "V241294x",
    elections_responsive = "V241235",
    social_trust = "V241234"
  )

# 3) choose three variables to recode the values AND
# 4) create three new variables (including at least a dummy and one
# ifelse statement):
library(dplyr)

trust_items <- c(
  "trust_fed_gov",
  "gov_run_by_big_interests",
  "gov_wastes_tax_money"
)

data_z <- data |>
  # 1) set ANES special codes to NA
  mutate(across(all_of(trust_items), ~ ifelse(.x < 0, NA, .x))) |>
  # 2) make all items point the same direction: higher = more trust
  mutate(
    # trust_fed_gov is typically:
    # 1=Always ... 5=Never (higher = less trust)
    trust_fed_gov_pos = 6 - trust_fed_gov,

    # gov_run_by_big_interests:
    # 1=big interests (low trust), 2=benefit all (high trust)
    gov_run_pos = gov_run_by_big_interests,

    # gov_wastes_tax_money is typically:
    # 1=wastes a lot ... 3=doesn't waste (higher = more trust)
    gov_waste_pos = gov_wastes_tax_money
  ) |>
  # 3) z-score (scale() returns a matrix, so wrap with as.numeric())
  mutate(
    z_trust_fed_gov = as.numeric(scale(trust_fed_gov_pos)),
    z_gov_run       = as.numeric(scale(gov_run_pos)),
    z_gov_waste     = as.numeric(scale(gov_waste_pos))
  ) |>
  # 4) composite z-index (row mean of standardized items)
  mutate(
    trust_index_z = rowMeans(
      cbind(z_trust_fed_gov, z_gov_run, z_gov_waste),
      na.rm = TRUE
    )
  )

# 5) save your new dataset!! hint: look at the code from week 1
write.csv(data_z, "data_z.csv", row.names = FALSE)

# 6) filter the dataset based on some interest you might have:
women_only <- data_z |>
  filter(gender == 2)

# 7) describe data checks for at least 3 of the 5 steps:

# Check that renamed columns exist
expected_cols <- c(
  "trust_fed_gov", "gov_run_by_big_interests", "gov_wastes_tax_money",
  "household_income_cat", "race_ethnicity_summary", "education_attainment",
  "party_id_7pt", "ideology_7pt", "congress_approval", "age", "gender", "sex",
  "marital_status", "natl_econ_retrospective", "elections_responsive",
  "social_trust"
)
stopifnot(
  all(expected_cols %in% names(data))
)

# Check that no negative codes remain in trust items after NA handling
stopifnot(
  all(data_z$trust_fed_gov >= 0 | is.na(data_z$trust_fed_gov))
)
stopifnot(
  all(
    data_z$gov_run_by_big_interests >= 0 |
      is.na(data_z$gov_run_by_big_interests)
  )
)
stopifnot(
  all(
    data_z$gov_wastes_tax_money >= 0 |
      is.na(data_z$gov_wastes_tax_money)
  )
)

# Check that women-only subset has only gender == 2 and non-zero rows
stopifnot(
  nrow(women_only) > 0
)
stopifnot(
  all(women_only$gender == 2)
)

# 8) describe a prompt you would use for AI if you were not able to
# perform tasks 1-5:

# Given the ANES 2024 CSV, write R (dplyr) code to: select and rename the 15
# listed variables; recode the three trust items so higher values mean more
# trust; set special codes (-9, -8, -1) to NA; z-score the three trust items;
# and create a composite trust index as the row mean of those z-scores. Then
# save the resulting dataset to data_z.csv.
#
# Variables:
# trust_fed_gov: "V241229"
# gov_run_by_big_interests: "V241231"
# gov_wastes_tax_money: "V241232"
# household_income_cat: "V241566x"
# race_ethnicity_summary: "V241501x"
# education_attainment: "V241509"
# party_id_7pt: "V241227x"
# ideology_7pt: "V241177"
# congress_approval: "V241129x"
# age: "V241632"
# gender: "V241551"
# sex: "V241550"
# marital_status: "V241505"
# natl_econ_retrospective: "V241294x"
# elections_responsive: "V241235"
# social_trust: "V241234"
