# Terrorism and organized crime in Colombia
# G Duncan, S Sosa, J Fortou

# Load libraries ####

library(tidyverse)

# Load data ####

terr_data <- read_rds(here("output", "terr_data.rds"))

# Figures ####

# Set ggplot2 theme for plots
theme_set(theme_light(base_size = 14))

# Plot terrorist acts from GTD by actor over time
terr_data %>%
  ggplot(aes(year, gtd_terroristacts)) +
  geom_col() +
  geom_vline(data = filter(terr_data, actor == "Paramilitaries"), 
             aes(xintercept = 1997), 
             linetype = "dashed") +
  lemon::facet_rep_wrap(~ actor, repeat.tick.labels = TRUE) +
  labs(x = "Year", y = "Number of terrorist acts") +
  ggsave("output/fig1.png", units = "in", width = 6.5, height = 7)

# Plot number of massacres from CNMH by actor over time
terr_data %>%
  filter(actor != "Cali Cartel") %>%
  ggplot(aes(year, cnmh_massacres)) +
  geom_col() +
  geom_vline(data = filter(terr_data, actor == "Paramilitaries"), 
             aes(xintercept = 1997), 
             linetype = "dashed") +
  lemon::facet_rep_wrap(~ actor, ncol = 1, repeat.tick.labels = TRUE) +
  labs(x = "Year", y = "Number of massacres") +
  ggsave("output/fig2.png", units = "in", width = 6.5, height = 7)

# Clear console and environment
rm(list = ls())
cat("\14")
