if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl)

# Load ANES data set
anes <- read_csv("anes_timeseries_2024_csv_20250808.csv")

# 1) select the variables we are interested in AND
# 2) rename these variables for something that makes sense:
dt <- anes |>
  select(
    household_income                     = V241566x,
    race_ethnicity                       = V241501x,
    educational_attainment               = V241463,
    age                                  = V241458x,
    sex                                  = V241550,
    marital_status                       = V241461x,
    party_identification                 = V241227x,
    registered_state                     = V242058x,
    trust_federal_government             = V241229,
    government_run_by_big_interests      = V241231,
    government_wastes_tax_money          = V241232,
    corrupt_gov                          = V241233,
    generalized_social_trust             = V241234,
    ideological_self_placement           = V241177,
    approval_of_congress                 = V241129x,
    approval_of_congress_binary          = V241127,
    national_economy_retrospective       = V241294x,
    elections_make_government_responsive = V241235
  )

library(tidyverse)

# helper: simple mode (lowercase name)
get_mode <- function(v) {
  v <- v[!is.na(v)]
  if (length(v) == 0) {
    return(NA_character_)
  }
  ux <- unique(v)
  ux[which.max(tabulate(match(v, ux)))]
}

dt_clean <- dt |>
  # 1) trust federal government
  mutate(
    trust_clean = case_when(
      trust_federal_government == 1 ~ "Always",
      trust_federal_government == 2 ~ "Most of the time",
      trust_federal_government == 3 ~ "About half the time",
      trust_federal_government == 4 ~ "Some of the time",
      trust_federal_government == 5 ~ "Never",
      TRUE ~ NA_character_
    ),
    trust_numeric = ifelse(trust_federal_government %in% 1:5,
      trust_federal_government, NA_real_
    ),
    trust_binary = case_when(
      trust_federal_government %in% c(1, 2) ~ 1,
      trust_federal_government %in% c(4, 5) ~ 0,
      TRUE ~ NA_real_
    )
  ) |>
  # 2) government run by big interests
  mutate(
    big_interests_clean = case_when(
      government_run_by_big_interests == 1 ~ "Run by big interests",
      government_run_by_big_interests == 2 ~ "For benefit of all",
      TRUE ~ NA_character_
    ),
    big_interests_numeric = ifelse(government_run_by_big_interests %in% 1:2,
      government_run_by_big_interests, NA_real_
    )
  ) |>
  # 3) government wastes tax money
  mutate(
    waste_clean = case_when(
      government_wastes_tax_money == 1 ~ "Waste a lot",
      government_wastes_tax_money == 2 ~ "Waste some",
      government_wastes_tax_money == 3 ~ "Don't waste very much",
      TRUE ~ NA_character_
    ),
    waste_numeric = ifelse(government_wastes_tax_money %in% 1:3,
      government_wastes_tax_money, NA_real_
    )
  ) |>
  # 4) household income
  mutate(
    income_clean = ifelse(household_income %in% 1:28, household_income, NA_real_),
    income_category = case_when(
      household_income %in% 1:8 ~ "Under $25,000",
      household_income %in% 9:14 ~ "$25,000-$49,999",
      household_income %in% 15:22 ~ "$50,000-$99,999",
      household_income %in% 23:28 ~ "$100,000+",
      TRUE ~ NA_character_
    )
  ) |>
  # 5) race / ethnicity
  mutate(
    race_clean = case_when(
      race_ethnicity == 1 ~ "White, non-Hispanic",
      race_ethnicity == 2 ~ "Black, non-Hispanic",
      race_ethnicity == 3 ~ "Hispanic",
      race_ethnicity == 4 ~ "Asian/Pacific Islander, non-Hispanic",
      race_ethnicity == 5 ~ "Native American/Other, non-Hispanic",
      race_ethnicity == 6 ~ "Multiple races, non-Hispanic",
      TRUE ~ NA_character_
    )
  ) |>
  # 6) educational attainment
  mutate(
    education_clean = ifelse(educational_attainment %in% 1:16 |
      educational_attainment == 95,
    educational_attainment, NA_real_
    ),
    education_category = case_when(
      educational_attainment %in% 1:8 ~ "Less than high school",
      educational_attainment == 9 ~ "High school graduate",
      educational_attainment %in% 10:12 ~ "Some college/Associate",
      educational_attainment == 13 ~ "Bachelor's degree",
      educational_attainment %in% 14:16 ~ "Graduate degree",
      TRUE ~ NA_character_
    )
  ) |>
  # 7) ideological self-placement
  mutate(
    ideology_clean = case_when(
      ideological_self_placement == 1 ~ "Extremely liberal",
      ideological_self_placement == 2 ~ "Liberal",
      ideological_self_placement == 3 ~ "Slightly liberal",
      ideological_self_placement == 4 ~ "Moderate",
      ideological_self_placement == 5 ~ "Slightly conservative",
      ideological_self_placement == 6 ~ "Conservative",
      ideological_self_placement == 7 ~ "Extremely conservative",
      TRUE ~ NA_character_
    ),
    ideology_numeric = ifelse(ideological_self_placement %in% 1:7,
      ideological_self_placement, NA_real_
    )
  ) |>
  # 8) approval of congress
  mutate(
    congress_approval_clean = case_when(
      approval_of_congress == 1 ~ "Approve strongly",
      approval_of_congress == 2 ~ "Approve not strongly",
      approval_of_congress == 3 ~ "Disapprove not strongly",
      approval_of_congress == 4 ~ "Disapprove strongly",
      TRUE ~ NA_character_
    ),
    congress_approval_numeric = ifelse(approval_of_congress %in% 1:4,
      approval_of_congress, NA_real_
    )
  ) |>
  # 9) age
  mutate(
    age_clean = ifelse(age >= 18 & age <= 80, age, NA_real_)
  ) |>
  # 10) sex
  mutate(
    sex_clean = case_when(
      sex == 1 ~ "Male",
      sex == 2 ~ "Female",
      TRUE ~ NA_character_
    )
  ) |>
  # 11) marital status
  mutate(
    marital_clean = case_when(
      marital_status == 1 ~ "Married: spouse present",
      marital_status == 2 ~ "Married: spouse absent",
      marital_status == 3 ~ "Widowed",
      marital_status == 4 ~ "Divorced",
      marital_status == 5 ~ "Separated",
      marital_status == 6 ~ "Never married",
      TRUE ~ NA_character_
    ),
    marital_simple = case_when(
      marital_status %in% c(1, 2) ~ "Married",
      marital_status %in% c(3, 4, 5) ~ "Previously married",
      marital_status == 6 ~ "Never married",
      TRUE ~ NA_character_
    )
  ) |>
  # 12) national economy retrospective
  mutate(
    economy_clean = case_when(
      national_economy_retrospective == 1 ~ "Much better",
      national_economy_retrospective == 2 ~ "Somewhat better",
      national_economy_retrospective == 3 ~ "About the same",
      national_economy_retrospective == 4 ~ "Somewhat worse",
      national_economy_retrospective == 5 ~ "Much worse",
      TRUE ~ NA_character_
    ),
    economy_numeric = ifelse(national_economy_retrospective %in% 1:5,
      national_economy_retrospective, NA_real_
    )
  ) |>
  # 13) elections make government responsive
  mutate(
    elections_responsive_clean = case_when(
      elections_make_government_responsive == 1 ~ "A good deal",
      elections_make_government_responsive == 2 ~ "Some",
      elections_make_government_responsive == 3 ~ "Not much",
      TRUE ~ NA_character_
    ),
    elections_responsive_numeric = ifelse(elections_make_government_responsive %in% 1:3,
      elections_make_government_responsive, NA_real_
    )
  ) |>
  # 14) generalized social trust
  mutate(
    social_trust_clean = case_when(
      generalized_social_trust == 1 ~ "Always",
      generalized_social_trust == 2 ~ "Most of the time",
      generalized_social_trust == 3 ~ "About half the time",
      generalized_social_trust == 4 ~ "Some of the time",
      generalized_social_trust == 5 ~ "Never",
      TRUE ~ NA_character_
    ),
    social_trust_numeric = ifelse(generalized_social_trust %in% 1:5,
      generalized_social_trust, NA_real_
    )
  ) |>
  # 15) approval of congress (binary)
  mutate(
    congress_approval_category = case_when(
      approval_of_congress_binary == 1 ~ "Approve",
      approval_of_congress_binary == 0 ~ "Disapprove",
      TRUE ~ NA_character_
    ),
    congress_binary = ifelse(approval_of_congress_binary %in% 1:2,
      approval_of_congress_binary, NA_real_
    )
  ) |>
  # 16) party identification
  mutate(
    party_clean = case_when(
      party_identification == 1 ~ "Strong Democrat",
      party_identification == 2 ~ "Not very strong Democrat",
      party_identification == 3 ~ "Independent-Democrat",
      party_identification == 4 ~ "Independent",
      party_identification == 5 ~ "Independent-Republican",
      party_identification == 6 ~ "Not very strong Republican",
      party_identification == 7 ~ "Strong Republican",
      TRUE ~ NA_character_
    ),
    party_numeric = ifelse(party_identification %in% 1:7,
      party_identification, NA_real_
    )
  ) |>
  # 17) registered state
  mutate(
    state_clean = ifelse(registered_state > 0, registered_state, NA_real_)
  )


# drop raw columns
dt_clean <- dt_clean |>
  select(matches("_clean$|_numeric$|_binary$|_category$|_simple$"))

# filter to complete cases on key variables
dt_complete <- dt_clean |>
  filter(
    !is.na(trust_numeric),
    !is.na(income_clean),
    !is.na(race_clean),
    !is.na(education_clean)
  )

# diagnostics
cat("Original rows:", nrow(dt), "\n")
cat("Clean rows:", nrow(dt_complete), "\n")
cat("Rows removed:", nrow(dt) - nrow(dt_complete), "\n")
cat("Percent retained:", round(nrow(dt_complete) / nrow(dt) * 100, 1), "%\n")

# quick summary
print(summary(dt_complete |> select(trust_numeric, income_clean, age_clean, ideology_numeric)))

# simple mode summary table
vars <- names(dt_complete)
results <- data.frame(
  variable = character(),
  n_nonmissing = integer(),
  mean = numeric(),
  median = numeric(),
  mode = character(),
  stringsAsFactors = FALSE
)
for (v in vars) {
  vec <- dt_complete[[v]]
  n_nonmiss <- sum(!is.na(vec))
  if (is.numeric(vec)) {
    mean_val <- ifelse(n_nonmiss > 0, round(mean(vec, na.rm = TRUE), 3), NA)
    median_val <- ifelse(n_nonmiss > 0, median(vec, na.rm = TRUE), NA)
  } else {
    mean_val <- NA
    median_val <- NA
  }
  mode_val <- get_mode(vec)
  results <- rbind(results, data.frame(
    variable = v,
    n_nonmissing = n_nonmiss,
    mean = mean_val,
    median = median_val,
    mode = mode_val,
    stringsAsFactors = FALSE
  ))
}
print(results, right = FALSE, row.names = FALSE)

# save outputs (adjust path if needed)
write.csv(dt_complete, "anes_clean.csv", row.names = FALSE)
write.csv(dt_clean, "anes_all_cleaned_vars.csv", row.names = FALSE)
cat("\n=== Files saved to Desktop ===\n")
cat("1. anes_clean.csv - Complete cases only\n")
cat("2. anes_all_cleaned_vars.csv - All cases with cleaned variables\n")
