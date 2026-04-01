if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl)

# Load ANES data set
anes <- read_csv("anes_all_cleaned_vars.csv")
# --- Recode variables to match class structure ---

# female dummy (1 = Female, 0 = Male)
dt$female <- ifelse(dt$sex_clean == "Female", 1,
                    ifelse(dt$sex_clean == "Male",   0, NA))

# conservative dummy (1 = any conservative ideology, 0 = liberal/moderate)
dt$conservative <- ifelse(dt$ideology_clean %in%
                            c("Conservative", "Extremely conservative", "Slightly conservative"), 1,
                          ifelse(dt$ideology_clean %in%
                                   c("Liberal", "Extremely liberal", "Slightly liberal", "Moderate"), 0, NA))

# education as factor with reference = High school graduate
dt$educ <- relevel(factor(dt$education_category), ref = "High school graduate")

# race as factor with reference = White, non-Hispanic
dt$race <- relevel(factor(dt$race_clean), ref = "White, non-Hispanic")


# trust in government: numeric (1–5) and binary (0/1)
# trust_numeric: 1=Never, 5=Always (higher = more trust)
# trust_binary:  1 = trusts government at least sometimes, 0 = never

# congress approval: binary (1 = approve, 0 = disapprove)
dt$congress_approval <- ifelse(dt$congress_binary_numeric == 1, 1,
                               ifelse(dt$congress_binary_numeric == 2, 0, NA))

# Inspect key variables
unique(dt$educ)
summary(dt$trust_numeric)
hist(dt$trust_numeric)
table(dt$trust_binary, useNA = "ifany")
table(dt$race, useNA = "ifany")
table(dt$female, useNA = "ifany")