
# 0. SETUP ---------------------------------------------------------------

#Assignment 4
#Author: Allie Sensinger, Alan Canfield, Bailey Whitaker, Lori Sheets, Spencer Tuft
#Date: 04/2026

#####----------------------------------------------#####
#0. SYSTEM SETUP


if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}

p_load(tidyverse, dplyr, lmtest, sandwich, car, ggplot2)


# 1. LOAD AND INSPECT DATA -----------------------------------------------

dt <- read_csv("anes_all_cleaned_vars.csv")

# Quick look at key variables
cat("\n--- Trust Binary ---\n")
table(dt$trust_binary, useNA = "ifany")

cat("\n--- Race ---\n")
table(dt$race_clean, useNA = "ifany")

cat("\n--- Income Category ---\n")
table(dt$income_category, useNA = "ifany")

cat("\n--- Education Category ---\n")
table(dt$education_category, useNA = "ifany")


# 2. RECODE VARIABLES ----------------------------------------------------

# -- Race: reference = White, non-Hispanic (K-1 dummies)
dt$race <- relevel(factor(dt$race_clean), ref = "White, non-Hispanic")

# -- Education: reference = High school graduate (K-1 dummies)
dt$educ <- relevel(factor(dt$education_category), ref = "High school graduate")

# -- Income: reference = Under $25,000 (lowest income = baseline)
dt$income <- relevel(factor(dt$income_category), ref = "Under $25,000")

# -- Controls
dt$female      <- ifelse(dt$sex_clean == "Female", 1,
                         ifelse(dt$sex_clean == "Male", 0, NA))

dt$conservative <- ifelse(dt$ideology_clean %in%
                            c("Conservative", "Extremely conservative", "Slightly conservative"), 1,
                          ifelse(dt$ideology_clean %in%
                                   c("Liberal", "Extremely liberal", "Slightly liberal", "Moderate"), 0, NA))

# Confirm trust_binary
cat("\n--- Trust Binary Summary ---\n")
summary(dt$trust_binary)
cat("Unique values:", unique(dt$trust_binary), "\n")
# 1 = trusts government at least sometimes, 0 = never trusts


# 3. INSPECT PROPORTIONS OF TRUST BY GROUP --------------------------------
# This gives a first look at differences before modeling

cat("\n--- Trust by Race ---\n")
round(prop.table(table(dt$race_clean, dt$trust_binary, useNA = "no"), margin = 1), 3)

cat("\n--- Trust by Income ---\n")
round(prop.table(table(dt$income_category, dt$trust_binary, useNA = "no"), margin = 1), 3)

cat("\n--- Trust by Education ---\n")
round(prop.table(table(dt$education_category, dt$trust_binary, useNA = "no"), margin = 1), 3)


# 4. LINEAR PROBABILITY MODEL (LPM) --------------------------------------
# DV: trust_binary (0/1) → LPM coefficients = percentage-point change in
#     probability of trusting government vs. the reference category

# -- Model 1: Race only (to see raw race differences)
lpm_race_only <- lm(trust_binary ~ race, data = dt)
cat("\n=== LPM: Race Only ===\n")
coeftest(lpm_race_only, vcov = vcovHC(lpm_race_only, type = "HC1"))

# -- Model 2: Education only
lpm_educ_only <- lm(trust_binary ~ educ, data = dt)
cat("\n=== LPM: Education Only ===\n")
coeftest(lpm_educ_only, vcov = vcovHC(lpm_educ_only, type = "HC1"))

# -- Model 3: Income only
lpm_income_only <- lm(trust_binary ~ income, data = dt)
cat("\n=== LPM: Income Only ===\n")
coeftest(lpm_income_only, vcov = vcovHC(lpm_income_only, type = "HC1"))

# -- Model 4: FULL MODEL — Race + Education + Income + Controls
# This is the main model. Holding all else constant, what are the pp differences?
lpm_full <- lm(trust_binary ~ race + educ + income + female + conservative + age_clean,
               data = dt)

cat("\n=== LPM: FULL MODEL (Race + Education + Income + Controls) ===\n")
coeftest(lpm_full, vcov = vcovHC(lpm_full, type = "HC1"))

cat("\nR-squared (full LPM):", summary(lpm_full)$r.squared, "\n")


# -- HOW TO READ LPM COEFFICIENTS --
# Each coefficient = percentage-point (pp) change in probability of trusting
# government compared to the REFERENCE CATEGORY, holding all controls constant.
#
# Example:
#   raceBlack, non-Hispanic = -0.05
#   → Black respondents are ~5 pp LESS likely to trust govt than White respondents
#     (holding educ, income, gender, ideology, age constant)
#
#   educGraduate degree = 0.08
#   → Graduate-degree holders are ~8 pp MORE likely to trust govt than HS grads
#
#   income$100,000+ = 0.03
#   → Top earners are ~3 pp MORE likely to trust govt than those under $25k


# 5. RE-REFERENCE TO GET ALL PAIRWISE COMPARISONS ------------------------
# Because we can only see K-1 comparisons at once, re-level to get the rest.

# ---- RACE: re-reference to Black ----------------------------------------
dt$race_reref_black <- relevel(factor(dt$race_clean), ref = "Black, non-Hispanic")
lpm_race_black <- lm(trust_binary ~ race_reref_black + educ + income +
                       female + conservative + age_clean, data = dt)
cat("\n=== LPM: Race re-referenced to Black, non-Hispanic ===\n")
coeftest(lpm_race_black, vcov = vcovHC(lpm_race_black, type = "HC1"))

# ---- RACE: re-reference to Hispanic -------------------------------------
dt$race_reref_hisp <- relevel(factor(dt$race_clean), ref = "Hispanic")
lpm_race_hisp <- lm(trust_binary ~ race_reref_hisp + educ + income +
                      female + conservative + age_clean, data = dt)
cat("\n=== LPM: Race re-referenced to Hispanic ===\n")
coeftest(lpm_race_hisp, vcov = vcovHC(lpm_race_hisp, type = "HC1"))

# ---- EDUCATION: re-reference to Graduate degree -------------------------
dt$educ_reref_grad <- relevel(factor(dt$education_category), ref = "Graduate degree")
lpm_educ_grad <- lm(trust_binary ~ race + educ_reref_grad + income +
                      female + conservative + age_clean, data = dt)
cat("\n=== LPM: Education re-referenced to Graduate degree ===\n")
coeftest(lpm_educ_grad, vcov = vcovHC(lpm_educ_grad, type = "HC1"))

# ---- INCOME: re-reference to $100,000+ ----------------------------------
dt$income_reref_top <- relevel(factor(dt$income_category), ref = "$100,000+")
lpm_income_top <- lm(trust_binary ~ race + educ + income_reref_top +
                       female + conservative + age_clean, data = dt)
cat("\n=== LPM: Income re-referenced to $100,000+ ===\n")
coeftest(lpm_income_top, vcov = vcovHC(lpm_income_top, type = "HC1"))


# 6. VERIFY LPM IS REAL (Predicted Probability Check) -------------------
# LPM can sometimes predict probabilities outside [0,1].
# Check whether this is a problem in our data.

lpm_preds <- predict(lpm_full)

cat("\n--- Predicted Probabilities from LPM ---\n")
cat("Min predicted probability:  ", round(min(lpm_preds, na.rm = TRUE), 4), "\n")
cat("Max predicted probability:  ", round(max(lpm_preds, na.rm = TRUE), 4), "\n")
cat("Proportion below 0:         ", mean(lpm_preds < 0, na.rm = TRUE), "\n")
cat("Proportion above 1:         ", mean(lpm_preds > 1, na.rm = TRUE), "\n")

# Histogram of predicted values
hist(lpm_preds, main = "LPM Predicted Probabilities",
     xlab = "Predicted Pr(Trust = 1)", col = "lightblue", breaks = 30)
abline(v = c(0, 1), col = "red", lty = 2)

# If min >= 0 and max <= 1 → LPM predictions are fully valid (no boundary violations).
# If a few go slightly outside, LPM is still considered acceptable for interpretation.
# The logit model in Section 7 resolves this formally.


# 7. ROBUSTNESS CHECK: LOGIT MODEL ----------------------------------------
# Logit always predicts probabilities between 0 and 1 by construction.
# If the sign and significance of coefficients match LPM → results are robust.

logit_full <- glm(trust_binary ~ race + educ + income + female + conservative + age_clean,
                  data = dt, family = binomial(link = "logit"))

cat("\n=== LOGIT: Full Model (Robust SEs) ===\n")
coeftest(logit_full, vcov = vcovHC(logit_full, type = "HC1"))

# Odds ratios and % change in odds
b         <- coef(logit_full)
exp_b     <- exp(b)
pct_change <- (exp_b - 1) * 100

logit_table <- data.frame(
  Coefficient    = round(b, 4),
  OddsRatio      = round(exp_b, 4),
  PctChangeOdds  = round(pct_change, 2)
)

cat("\n--- Logit Odds Ratios ---\n")
print(logit_table)

# McFadden pseudo R-squared
pseudo_r2 <- 1 - logit_full$deviance / logit_full$null.deviance
cat("\nMcFadden Pseudo R-squared:", round(pseudo_r2, 4), "\n")

# HOW TO READ LOGIT ODDS RATIOS:
#   OR > 1 → higher odds of trusting government vs. reference group
#   OR < 1 → lower odds of trusting government vs. reference group
#   e.g., OR = 0.70 for Black → 30% lower odds than White, non-Hispanic


# 8. MULTICOLLINEARITY CHECK ---------------------------------------------

cat("\n--- VIF: Full LPM ---\n")
vif(lpm_full)
# All values well below 10 = no multicollinearity problem.


# 9. SUMMARY OF SIGNIFICANT FINDINGS --------------------------------------
# After running the above, look for:
#   - p < 0.05 in coeftest() → statistically significant
#   - Sign of coefficient → direction (positive = more likely to trust)
#   - Magnitude → practical significance in pp (LPM) or odds (logit)
#
# Key comparisons from K-1 coding:
#   RACE     (ref = White): Black, Hispanic, Asian/PI, Native Am., Multiple races
#   EDUCATION (ref = HS grad): Less than HS, Some college, Bachelor's, Graduate
#   INCOME   (ref = Under $25k): $25k-$49k, $50k-$99k, $100k+
#
# Re-reference (Section 5) to get pairwise comparisons that are not vs. the baseline,
# e.g., Black vs. Hispanic, Graduate vs. Bachelor's, etc.

cat("\n\n====================================================\n")
cat("ANALYSIS COMPLETE.\n")
cat("Key sections:\n")
cat("  Section 4: Main LPM (full model) - percentage-point effects\n")
cat("  Section 5: Re-referenced models for all pairwise race/educ/income comparisons\n")
cat("  Section 6: LPM validity check (predicted probabilities)\n")
cat("  Section 7: Logit robustness check + odds ratios\n")
cat("  Section 8: VIF multicollinearity check\n")
cat("====================================================\n")
=======

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
>>>>>>> e7c4d9628e8957e4cfd96969bbe4e602807040eb
