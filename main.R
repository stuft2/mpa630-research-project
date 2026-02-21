if(!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl)

# Load ANES data set
anes <- read_csv("anes_timeseries_2024_csv_20250808.csv")

# 1) select the variables we are interested in AND
# 2) rename these variables for something that makes sense:
anes2 <- anes |>
  select(
    household_income                     = V241566x,
    race_ethnicity                       = V241501x,
    educational_attainment               = V241463,
    age                                  = V241458x,
    sex                                  = V241550,
    gender_identity                      = V241551,
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


