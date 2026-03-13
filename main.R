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

# quick summary
print(summary(dt_clean |> select(trust_numeric, income_clean, age_clean, ideology_numeric)))

# simple mode summary table
vars <- names(dt_clean)
results <- data.frame(
  variable = character(),
  n_nonmissing = integer(),
  mean = numeric(),
  median = numeric(),
  mode = character(),
  stringsAsFactors = FALSE
)
for (v in vars) {
  vec <- dt_clean[[v]]
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
#So much fun

# print(results, right = FALSE, row.names = FALSE)

# save outputs (adjust path if needed)
write.csv(dt_clean, "anes_all_cleaned_vars.csv", row.names = FALSE)
cat("\n=== Files saved to Desktop ===\n")
cat("2. anes_all_cleaned_vars.csv - All cases with cleaned variables\n")
# Assignment 3 – Descriptive Statistics: Bar Graphs
# Load libraries
library(ggplot2)
library(dplyr)

# ── Load data ──────────────────────────────────────────────────────────────────
df <- read.csv("/mnt/user-data/uploads/anes_all_cleaned_vars__3_.csv",
               stringsAsFactors = FALSE)

# ── Shared theme ───────────────────────────────────────────────────────────────
my_theme <- theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold", hjust = 0.5, size = 14),
    plot.subtitle = element_text(hjust = 0.5, size = 11, color = "grey40"),
    axis.title    = element_text(size = 12),
    axis.text.x   = element_text(angle = 25, hjust = 1, size = 10),
    axis.text.y   = element_text(size = 10),
    legend.position = "none",
    panel.grid.major.x = element_blank()
  )

trust_levels <- c("Always", "Most of the time", "About half the time",
                  "Some of the time", "Never")
trust_colors <- c("#2166ac", "#74add1", "#fee090", "#f46d43", "#d73027")


# ── GRAPH 1: Trust in Government (Dependent Variable) ─────────────────────────
trust_data <- df %>%
  filter(!is.na(trust_clean)) %>%
  mutate(trust_clean = factor(trust_clean, levels = trust_levels)) %>%
  count(trust_clean) %>%
  mutate(pct = n / sum(n) * 100)

g1 <- ggplot(trust_data, aes(x = trust_clean, y = pct, fill = trust_clean)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.4, size = 3.5) +
  scale_fill_manual(values = trust_colors) +
  scale_y_continuous(limits = c(0, 55), labels = function(x) paste0(x, "%")) +
  labs(
    title    = "Trust in Federal Government",
    subtitle = "How often can you trust the federal government to do what is right?",
    x        = "Response",
    y        = "Percentage of Respondents"
  ) +
  my_theme

ggsave("/mnt/user-data/outputs/graph1_trust_gov.png",
       g1, width = 7, height = 5, dpi = 300)


# ── GRAPH 2: Trust in Government by Race ──────────────────────────────────────
race_trust <- df %>%
  filter(!is.na(trust_clean), !is.na(race_clean)) %>%
  mutate(
    trust_clean = factor(trust_clean, levels = trust_levels),
    # Shorten long labels
    race_short = case_when(
      race_clean == "White non-Hispanic"                   ~ "White",
      race_clean == "Black non-Hispanic"                   ~ "Black",
      race_clean == "Hispanic"                             ~ "Hispanic",
      race_clean == "Asian/Pacific Islander non-Hispanic"  ~ "Asian/PI",
      race_clean == "Native American/Other non-Hispanic"   ~ "Native Am./Other",
      race_clean == "Multiple races non-Hispanic"          ~ "Multiracial",
      TRUE ~ race_clean
    )
  ) %>%
  group_by(race_short) %>%
  summarise(mean_trust = mean(as.numeric(trust_clean), na.rm = TRUE),
            n = n(), .groups = "drop")

g2 <- ggplot(race_trust, aes(x = reorder(race_short, mean_trust),
                             y = mean_trust, fill = race_short)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = round(mean_trust, 2)), vjust = -0.4, size = 3.5) +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(limits = c(0, 5.2),
                     breaks = 1:5,
                     labels = c("1\n(Always)", "2\n(Most)", "3\n(Half)", "4\n(Some)", "5\n(Never)")) +
  labs(
    title    = "Average Distrust in Government by Race/Ethnicity",
    subtitle = "Higher score = less trust  |  Scale: 1 (Always) to 5 (Never)",
    x        = "Race / Ethnicity",
    y        = "Mean Trust Score"
  ) +
  my_theme

ggsave("/mnt/user-data/outputs/graph2_trust_by_race.png",
       g2, width = 7, height = 5, dpi = 300)


# ── GRAPH 3: Trust in Government by Income Category ───────────────────────────
income_levels <- c("Under $25,000", "$25,000–$49,999",
                   "$50,000–$99,999", "$100,000+")

income_trust <- df %>%
  filter(!is.na(trust_clean), !is.na(income_category)) %>%
  mutate(
    trust_clean     = factor(trust_clean, levels = trust_levels),
    income_category = factor(income_category, levels = income_levels)
  ) %>%
  group_by(income_category) %>%
  summarise(mean_trust = mean(as.numeric(trust_clean), na.rm = TRUE),
            n = n(), .groups = "drop")

g3 <- ggplot(income_trust, aes(x = income_category, y = mean_trust,
                               fill = income_category)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = round(mean_trust, 2)), vjust = -0.4, size = 3.5) +
  scale_fill_brewer(palette = "Blues", direction = 1) +
  scale_y_continuous(limits = c(0, 5.2),
                     breaks = 1:5,
                     labels = c("1\n(Always)", "2\n(Most)", "3\n(Half)", "4\n(Some)", "5\n(Never)")) +
  labs(
    title    = "Average Distrust in Government by Household Income",
    subtitle = "Higher score = less trust  |  Scale: 1 (Always) to 5 (Never)",
    x        = "Household Income Category",
    y        = "Mean Trust Score"
  ) +
  my_theme

ggsave("/mnt/user-data/outputs/graph3_trust_by_income.png",
       g3, width = 7, height = 5, dpi = 300)


# ── GRAPH 4: Trust in Government by Education ─────────────────────────────────
edu_levels <- c("Less than high school", "High school graduate",
                "Some college/Associate", "Bachelor's degree", "Graduate degree")

edu_trust <- df %>%
  filter(!is.na(trust_clean), !is.na(education_category)) %>%
  mutate(
    trust_clean        = factor(trust_clean, levels = trust_levels),
    education_category = factor(education_category, levels = edu_levels)
  ) %>%
  group_by(education_category) %>%
  summarise(mean_trust = mean(as.numeric(trust_clean), na.rm = TRUE),
            n = n(), .groups = "drop")

g4 <- ggplot(edu_trust, aes(x = education_category, y = mean_trust,
                            fill = education_category)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = round(mean_trust, 2)), vjust = -0.4, size = 3.5) +
  scale_fill_brewer(palette = "Purples") +
  scale_y_continuous(limits = c(0, 5.2),
                     breaks = 1:5,
                     labels = c("1\n(Always)", "2\n(Most)", "3\n(Half)", "4\n(Some)", "5\n(Never)")) +
  labs(
    title    = "Average Distrust in Government by Education Level",
    subtitle = "Higher score = less trust  |  Scale: 1 (Always) to 5 (Never)",
    x        = "Education Level",
    y        = "Mean Trust Score"
  ) +
  my_theme

ggsave("/mnt/user-data/outputs/graph4_trust_by_education.png",
       g4, width = 7, height = 5, dpi = 300)


# ── GRAPH 5: Trust in Government by Age Group ─────────────────────────────────
age_trust <- df %>%
  filter(!is.na(trust_clean), !is.na(age_clean)) %>%
  mutate(
    trust_clean = factor(trust_clean, levels = trust_levels),
    age_group   = cut(age_clean,
                      breaks = c(17, 29, 44, 59, 80),
                      labels = c("18–29", "30–44", "45–59", "60–80"))
  ) %>%
  filter(!is.na(age_group)) %>%
  group_by(age_group) %>%
  summarise(mean_trust = mean(as.numeric(trust_clean), na.rm = TRUE),
            n = n(), .groups = "drop")

g5 <- ggplot(age_trust, aes(x = age_group, y = mean_trust, fill = age_group)) +
  geom_col(width = 0.55) +
  geom_text(aes(label = round(mean_trust, 2)), vjust = -0.4, size = 3.5) +
  scale_fill_brewer(palette = "Oranges") +
  scale_y_continuous(limits = c(0, 5.2),
                     breaks = 1:5,
                     labels = c("1\n(Always)", "2\n(Most)", "3\n(Half)", "4\n(Some)", "5\n(Never)")) +
  labs(
    title    = "Average Distrust in Government by Age Group",
    subtitle = "Higher score = less trust  |  Scale: 1 (Always) to 5 (Never)",
    x        = "Age Group",
    y        = "Mean Trust Score"
  ) +
  my_theme +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))

ggsave("/mnt/user-data/outputs/graph5_trust_by_age.png",
       g5, width = 6, height = 5, dpi = 300)


# ── GRAPH 6: Trust in Government by Party Identification ──────────────────────
party_levels <- c("Strong Democrat", "Not very strong Democrat",
                  "Independent-Democrat", "Independent",
                  "Independent-Republican", "Not very strong Republican",
                  "Strong Republican")
party_short  <- c("Strong\nDem", "Weak\nDem", "Lean\nDem",
                  "Indep.", "Lean\nRep", "Weak\nRep", "Strong\nRep")

party_trust <- df %>%
  filter(!is.na(trust_clean), !is.na(party_clean)) %>%
  mutate(
    trust_clean = factor(trust_clean, levels = trust_levels),
    party_clean = factor(party_clean, levels = party_levels)
  ) %>%
  group_by(party_clean) %>%
  summarise(mean_trust = mean(as.numeric(trust_clean), na.rm = TRUE),
            n = n(), .groups = "drop") %>%
  mutate(party_short = party_short[match(party_clean, party_levels)])

party_colors <- c("#2166ac","#74add1","#abd9e9",
                  "#ffffbf",
                  "#fdae61","#f46d43","#d73027")

g6 <- ggplot(party_trust, aes(x = party_short, y = mean_trust, fill = party_clean)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = round(mean_trust, 2)), vjust = -0.4, size = 3.5) +
  scale_fill_manual(values = party_colors) +
  scale_x_discrete(limits = party_short) +
  scale_y_continuous(limits = c(0, 5.2),
                     breaks = 1:5,
                     labels = c("1\n(Always)", "2\n(Most)", "3\n(Half)", "4\n(Some)", "5\n(Never)")) +
  labs(
    title    = "Average Distrust in Government by Party Identification",
    subtitle = "Higher score = less trust  |  Scale: 1 (Always) to 5 (Never)",
    x        = "Party Identification",
    y        = "Mean Trust Score"
  ) +
  my_theme +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5, size = 9))

ggsave("/mnt/user-data/outputs/graph6_trust_by_party.png",
       g6, width = 8, height = 5, dpi = 300)

message("✅ All 6 graphs saved to /mnt/user-data/outputs/")
