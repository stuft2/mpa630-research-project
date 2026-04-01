if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(tidyverse, dplyr, data.table, ggplot2, fastDummies, readxl)

# Load ANES data set
anes <- read_csv("anes_all_cleaned_vars.csv")
