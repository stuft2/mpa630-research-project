# Assignment 3 – Descriptive Statistics: Bar Graphs
# Load libraries
library(ggplot2)
library(dplyr)

# ── Load data ──────────────────────────────────────────────────────────────────
df <- read.csv("anes_all_cleaned_vars.csv",
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

ggsave("graphs/trust_gov.png",
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

ggsave("graphs/trust_by_race.png",
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

ggsave("graphs/trust_by_income.png",
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

ggsave("graphs/trust_by_education.png",
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

ggsave("graphs/trust_by_age.png",
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

ggsave("graphs/trust_by_party.png",
       g6, width = 8, height = 5, dpi = 300)

message("✅ All 6 graphs saved ")