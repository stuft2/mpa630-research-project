#Assignment 4
#Author: Allie Sensinger, Alan Canfield, Bailey Whitaker, Lori Sheets, Spencer Tuft
#Date: 04/2026

#####----------------------------------------------#####
#0. SYSTEM SETUP

if(!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}

p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl, Hmisc, fixest, performance)

# Load ANES data set
dt <- read_csv("anes_all_cleaned_vars.csv")

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

#####----------------------------------------------#####

#1. Regression 1: LPM model

lpm = feols(conservative ~ educ+female+age, data = dt, vcov = "hetero")
summary(lpm)


#2. Regression 2: Logit Model

logit <- feglm(conservative ~ educ + female + age,
               data = dt,
               family = binomial(link = "logit"))

summary(logit, vcov = "hetero")

#transform coefficients
b <- coef(logit)["educHigher education complete"]
exp_b <- exp(b)
pct_change <- (exp_b - 1) * 100


#3. Robustness check:
#a) Collinearity
check_collinearity(lpm)

#b) Change of controls:
controls = feols(conservative ~ educ+female+age+conservative+reelected+married, data = dt, vcov = "hetero")
summary(controls)