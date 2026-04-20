# Assignment 3 – US Heatmaps: Trust in Federal Government by State
# Required packages: ggplot2, dplyr, maps (or usmap), stringr
# Install if needed: install.packages(c("ggplot2", "dplyr", "maps", "usmap", "viridis"))

if (!require("pacman")) {
  install.packages("pacman")
  library(pacman)
}
p_load(ggplot2, dplyr, maps, viridis, mapproj)

# ── Load data ──────────────────────────────────────────────────────────────────
df <- read.csv("anes_all_cleaned_vars.csv",
               stringsAsFactors = FALSE)

dir.create("heatmaps/descriptive_stats", recursive = TRUE, showWarnings = FALSE)

# ── FIPS code → state name lookup ─────────────────────────────────────────────
# Standard FIPS numeric codes mapped to lowercase state names (matches maps pkg)
fips_to_state <- c(
  "1"  = "alabama",        "2"  = "alaska",         "4"  = "arizona",
  "5"  = "arkansas",       "6"  = "california",      "8"  = "colorado",
  "9"  = "connecticut",    "10" = "delaware",        "11" = "district of columbia",
  "12" = "florida",        "13" = "georgia",         "15" = "hawaii",
  "16" = "idaho",          "17" = "illinois",        "18" = "indiana",
  "19" = "iowa",           "20" = "kansas",          "21" = "kentucky",
  "22" = "louisiana",      "23" = "maine",           "24" = "maryland",
  "25" = "massachusetts",  "26" = "michigan",        "27" = "minnesota",
  "28" = "mississippi",    "29" = "missouri",        "30" = "montana",
  "31" = "nebraska",       "32" = "nevada",          "33" = "new hampshire",
  "34" = "new jersey",     "35" = "new mexico",      "36" = "new york",
  "37" = "north carolina", "38" = "north dakota",    "39" = "ohio",
  "40" = "oklahoma",       "41" = "oregon",          "42" = "pennsylvania",
  "44" = "rhode island",   "45" = "south carolina",  "46" = "south dakota",
  "47" = "tennessee",      "48" = "texas",           "49" = "utah",
  "50" = "vermont",        "51" = "virginia",        "53" = "washington",
  "54" = "west virginia",  "55" = "wisconsin",       "56" = "wyoming"
)

write_summary <- function(data, file_name, title) {
  out_path <- file.path("heatmaps", "descriptive_stats", file_name)
  write.csv(data, out_path, row.names = FALSE)
  message("\n", title)
  print(data)
  message("Saved descriptive statistics to: ", out_path)
}

# ── Aggregate: mean trust score by state ──────────────────────────────────────
# trust_numeric: 1 = Never (low trust) → 5 = Always (high trust)
state_trust <- df %>%
  filter(!is.na(state_clean), !is.na(trust_numeric), state_clean > 0) %>%
  mutate(state_name = fips_to_state[as.character(state_clean)]) %>%
  filter(!is.na(state_name)) %>%
  group_by(state_name) %>%
  summarise(
    mean_trust  = mean(trust_numeric, na.rm = TRUE),
    pct_low     = mean(trust_binary == 0, na.rm = TRUE) * 100,  # % low trust
    n           = n(),
    .groups     = "drop"
  )

mean_trust_summary <- state_trust %>%
  arrange(mean_trust) %>%
  mutate(
    mean_trust = round(mean_trust, 2),
    pct_low = round(pct_low, 1)
  )

# ── US map base ────────────────────────────────────────────────────────────────
us_map <- map_data("state")   # lon/lat polygons, region = lowercase state name

map_trust <- us_map %>%
  left_join(state_trust, by = c("region" = "state_name"))

# ── Shared theme ───────────────────────────────────────────────────────────────
map_theme <- theme_void(base_size = 13) +
  theme(
    plot.title      = element_text(face = "bold", hjust = 0.5, size = 15),
    plot.subtitle   = element_text(hjust = 0.5, size = 11, color = "grey40",
                                   margin = margin(b = 8)),
    plot.caption    = element_text(hjust = 0.5, size = 9, color = "grey55",
                                   margin = margin(t = 8)),
    legend.position = "bottom",
    legend.key.width  = unit(2.5, "cm"),
    legend.key.height = unit(0.4, "cm"),
    legend.title    = element_text(size = 10, face = "bold"),
    legend.text     = element_text(size = 9),
    plot.margin     = margin(10, 10, 10, 10)
  )

# ══════════════════════════════════════════════════════════════════════════════
# MAP 1: Mean Trust Score by State
# Higher score = MORE trust (scale 1–5)
# ══════════════════════════════════════════════════════════════════════════════
map1 <- ggplot(map_trust, aes(x = long, y = lat, group = group, fill = mean_trust)) +
  geom_polygon(color = "white", linewidth = 0.3) +
  coord_map("albers", lat0 = 30, lat1 = 45) +
  scale_fill_viridis(
    option    = "plasma",
    direction = -1,
    name      = "Mean Score",
    limits    = c(1, 5),
    breaks    = 1:5,
    labels    = c("1\n(Never)", "2\n(Some of\nthe time)",
                  "3\n(About half)", "4\n(Most of\nthe time)", "5\n(Always)"),
    na.value  = "grey80"
  ) +
  labs(
    title    = "Average Trust in Federal Government by State",
    subtitle = "Higher score indicates more trust  |  ANES 2024",
    caption  = "Note: States in grey had insufficient sample size after cleaning.\nScale: 1 = Never trust, 5 = Always trust"
  ) +
  map_theme

ggsave("heatmaps/mean_trust.png",
       map1, width = 10, height = 6.5, dpi = 300, create.dir = TRUE)
write_summary(mean_trust_summary, "mean_trust_summary.csv",
              "Descriptive statistics for Map 1: Average Trust in Federal Government by State")
message("✅ Map 1 saved.")

# ══════════════════════════════════════════════════════════════════════════════
# MAP 2: % of Respondents with LOW Trust (Some of the time / Never)
# ══════════════════════════════════════════════════════════════════════════════
map2 <- ggplot(map_trust, aes(x = long, y = lat, group = group, fill = pct_low)) +
  geom_polygon(color = "white", linewidth = 0.3) +
  coord_map("albers", lat0 = 30, lat1 = 45) +
  scale_fill_viridis(
    option   = "inferno",
    direction = 1,
    name     = "% Low Trust",
    limits   = c(0, 100),
    breaks   = seq(0, 100, 20),
    labels   = paste0(seq(0, 100, 20), "%"),
    na.value = "grey80"
  ) +
  labs(
    title    = "Share of Low-Trust Respondents by State",
    subtitle = "Low trust = responded 'Some of the time' or 'Never'  |  ANES 2024",
    caption  = "Note: States in grey had insufficient sample size after cleaning.\ntrust_binary = 0 (Low Trust) includes 'Some of the time' and 'Never' responses."
  ) +
  map_theme

ggsave("heatmaps/pct_low_trust.png",
       map2, width = 10, height = 6.5, dpi = 300, create.dir = TRUE)
low_trust_summary <- state_trust %>%
  arrange(desc(pct_low)) %>%
  transmute(
    state_name,
    n,
    pct_low = round(pct_low, 1),
    mean_trust = round(mean_trust, 2)
  )
write_summary(low_trust_summary, "pct_low_trust_summary.csv",
              "Descriptive statistics for Map 2: Share of Low-Trust Respondents by State")
message("✅ Map 2 saved.")

# ══════════════════════════════════════════════════════════════════════════════
# MAP 3: Diverging map — above/below national average trust
# ══════════════════════════════════════════════════════════════════════════════
nat_avg <- mean(df$trust_numeric, na.rm = TRUE)   # ~2.44 after reverse-coding

map_trust <- map_trust %>%
  mutate(trust_dev = mean_trust - nat_avg)  # positive = more trust than avg

trust_deviation_summary <- state_trust %>%
  mutate(
    trust_dev = mean_trust - nat_avg,
    mean_trust = round(mean_trust, 2),
    trust_dev = round(trust_dev, 2),
    national_mean = round(nat_avg, 2)
  ) %>%
  arrange(desc(trust_dev))

map3 <- ggplot(map_trust, aes(x = long, y = lat, group = group, fill = trust_dev)) +
  geom_polygon(color = "white", linewidth = 0.3) +
  coord_map("albers", lat0 = 30, lat1 = 45) +
  scale_fill_gradient2(
    low      = "#d73027",   # red   = less trusting than average
    mid      = "#f7f7f7",
    high     = "#2166ac",   # blue  = more trusting than average
    midpoint = 0,
    name     = "Deviation\nfrom Avg",
    limits   = c(-1.5, 1.5),
    breaks   = c(-1.5, -0.75, 0, 0.75, 1.5),
    labels   = c("−1.5\n(Much less\ntrusting)", "−0.75", "0\n(National avg)",
                 "+0.75", "+1.5\n(Much more\ntrusting)"),
    na.value = "grey80"
  ) +
  labs(
    title    = "Trust Deviation from National Average by State",
    subtitle = sprintf("Blue = more trusting than avg (%.2f)  |  Red = less trusting  |  ANES 2024", nat_avg),
    caption  = "Note: States in grey had insufficient sample size after cleaning.\nDeviation calculated as state mean minus national mean trust score."
  ) +
  map_theme

ggsave("heatmaps/trust_deviation.png",
       map3, width = 10, height = 6.5, dpi = 300, create.dir = TRUE)
write_summary(trust_deviation_summary, "trust_deviation_summary.csv",
              "Descriptive statistics for Map 3: Trust Deviation from National Average by State")
message("✅ Map 3 saved.")

message("\n✅ All 3 heatmaps saved ")
