##### ---------------------------------------------------------------------####
# Code for Stats Class - Week 3
# Author: Marylis Fantoni
# E-mail: mfantoni@byu.edu
# Created: Aug 2025
##### ---------------------------------------------------------------------####
# 0.SYSTEM SETUP

if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl)

##### ---------------------------------------------------------------------####
# Import and inspect the dataset

dt <- read_csv("~/Projects/stats/week3/week3_tri2005.csv")

# Inspect the dataset

# Median, Maximum, Mean, Quartiles
summary(dt)

# Quickly shows the structure, column types, and sample values of a data frame
# in a compact, readable format
glimpse(dt)

# All the variable names of the dataset
names(dt)

# what caught your attention from these codes?


##### ---------------------------------------------------------------------####
# Cleaning task 1: keep only the variables of interest

dt2 <- dt |> select(
  "1. YEAR",
  "4. FACILITY NAME",
  "6. CITY",
  "8. ST",
  "9. ZIP",
  "10. BIA",
  "15. PARENT CO NAME",
  "22. INDUSTRY SECTOR CODE",
  "37. CHEMICAL",
  "42. CLEAN AIR ACT CHEMICAL",
  "47. PBT",
  "46. CARCINOGEN",
  "65. ON-SITE RELEASE TOTAL",
  "88. OFF-SITE RELEASE TOTAL",
  "104. OFF-SITE TREATED TOTAL",
  "115. 8.4 - RECYCLING ON SITE",
  "116. 8.5 - RECYCLING OFF SIT",
  "117. 8.6 - TREATMENT ON SITE",
  "118. 8.7 - TREATMENT OFF SITE"
)

# Let's say I want to delete one of the variables I no longer need:
dt2 <- dt2 |> select(-"46. CARCINOGEN")

# Cleaning task 2: Rename the variables

# Example:
dt2 <- dt2 |> rename(year = "1. YEAR")
dt2 <- dt2 |> rename(company = "4. FACILITY NAME")
dt2 <- dt2 |> rename(city = "6. CITY")
dt2 <- dt2 |> rename(state = "8. ST")
dt2 <- dt2 |> rename(indigenous = "10. BIA")
dt2 <- dt2 |> rename(pbt = "47. PBT")
dt2 <- dt2 |> rename(recycling_off = "116. 8.5 - RECYCLING OFF SIT")
dt2 <- dt2 |> rename(recycling_on = "115. 8.4 - RECYCLING ON SITE")

# Cleaning task 3: create a dummy variable for indigenous land
# First check what values are currently there.
unique(dt2$indigenous)

# There are too many NAs, so we need to work around them:
dt2$indigenous_dummy <- ifelse(!is.na(dt2$indigenous), 1, 0)

# How to check if this worked? Filter indigenous_dummy == 1 and check
# the indigenous column.
filtered_correctly <- dt2 |>
  filter(is.na(dt2$indigenous) & dt2$indigenous_dummy == 1) |>
  nrow()
# Check whether the dummy was populated correctly.
cat(
  "Indigenous dummy variable",
  ifelse(filtered_correctly == 0, "was", "was not"),
  "populated correctly"
)

# Now let's flag companies that are on indigenous land and reported PBT.
dt2$indigenous_pbt <- ifelse(dt2$indigenous_dummy == 1 & dt2$pbt == 1, 1, 0)

# There are many ways to create dummy columns. Another option is to use
# a logical variable such as PBT.
dt2 <- dummy_cols(dt2, "pbt")


# Cleaning task 4: Recode values. We want 1 and 0 instead of NO and YES
# for PBT.
dt2 <- dt2 |>
  mutate(pbt_number = recode(pbt,
    "YES" = "1",
    "NO"  = "0"
  ))

# That code created a new variable (pbt_number) and kept the original
# (pbt), but we can change the original instead:
dt2 <- dt2 |>
  mutate(pbt = recode(pbt,
    "YES" = "1",
    "NO"  = "0"
  ))


# Cleaning task 5: Create a new variable that sums the total of
# recycling onsite and offsite.
dt2$total_recycling <- dt2$recycling_off + dt2$recycling_on

# How to check if this worked? Look up the variable values for
# recycling_on and recycling_off.
total_recycling_correct <- dt2 |>
  filter(total_recycling != dt2$recycling_off + dt2$recycling_on) |>
  nrow()
cat(
  "Total recycling variable",
  ifelse(total_recycling_correct == 0, "was", "was not"),
  "populated correctly"
)

# Cleaning task 6: We only want the companies in the state of Utah now:
dt2 <- dt2 |> filter(state == "UT")

# Now let's keep only companies with no recycling that have PBT products
# in Utah.
dt2 <- dt2 |>
  filter(pbt == 1) |>
  filter(total_recycling == 0)


# how would you check if this worked?
num_no_recycle_pbt <- dt2 |>
  filter(pbt == 1) |>
  filter(total_recycling == 0) |>
  nrow()
total_companies <- dt2 |> nrow()
cat(
  "Companies with no recycling and PBT products",
  ifelse(
    num_no_recycle_pbt == total_companies,
    "were",
    "were not"
  ),
  "filtered correctly"
)

##### ---------------------------------------------------------------------####
# YOUR TURN NOW!

# 0) load your dataset for your project (whatever you chose in Assignment 1)


# 1) select 15 variables you are interested in:


# 2) rename these variables for something that makes sense:


# 3) choose three variables to recode the values:


# 4) create three new variables (including at least a dummy and one
# ifelse statement):


# 5) save your new dataset!! hint: look at the code from week 1


# 6) filter the dataset based on some interest you might have:


# 7) describe data checks for at least 3 of the 5 steps:


# 8) describe a prompt you would use for AI if you were not able to
# perform tasks 1-5:
