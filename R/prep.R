# Terrorism and organized crime in Colombia
# G Duncan, S Sosa, J Fortou

# Load libraries ####

library(tidyverse)
library(janitor)
library(here)
library(readxl)

# CNMH data ####

# Terrorism
cnmh_t <- read_csv(here("data", "casos_atentados_terroristas.csv")) %>%
  clean_names()

# Agreggate
cnmh_t_year <- cnmh_t %>%
  mutate(
    actor = case_when(
      descripcion_presunto_responsable %in% c("Autodefensas unidas de colombia auc",
                                              "Urabeños/autodefensas gaitanistas de colombia/águilas negras/clan úsuga") ~ "Paramilitaries",
      descripcion_presunto_responsable == "Farc" ~ "FARC"
    )
  ) %>%
  filter(actor %in% c("Paramilitaries", "FARC")) %>%
  group_by(annoh, actor) %>%
  summarize(
    terroristacts = n(),
    across(total_combatientes_muertos:numero_victimas_caso, ~sum(.x, na.rm = TRUE))
  ) %>%
  ungroup() %>%
  select(year = annoh, actor, terroristacts)

# Massacres
cnmh_m <- read_csv(here("data", "casos_masacres.csv")) %>%
  clean_names()

# Agreggate
cnmh_m_year <- cnmh_m %>%
  mutate(
    actor = case_when(
      descripcion_presunto_responsable %in% c(
        "Autodefensas unidas de colombia auc",
        "Autodefensas campesinas de córdoba y urabá (accu)",
        "Autodefensas campesinas de meta y vichada",
        "Autodefensas campesinas del casanare (buitragueños)",
        "Autodefensas campesinas nueva generación (ong)",
        "Autodefensas campesinas del magdalena medio",
        "Autodefensas campesinas del sur del cesar",
        "Autodefensas de hernán giraldo",
        "Bloque central bolívar",
        "Bloque metro",
        "Los paisas",
        "Los rastrojos",
        "Los tangueros",
        "Urabeños/autodefensas gaitanistas de colombia/águilas negras/clan úsuga"
      ) ~ "Paramilitaries",
      descripcion_presunto_responsable == "Farc" ~ "FARC",
      descripcion_presunto_responsable == "Muerte a secuestradores (mas)" ~ "Medellín Cartel"
    )
  ) %>%
  filter(actor %in% c("Paramilitaries", "FARC", "Medellín Cartel"),
         annoh != 0) %>%
  group_by(annoh, actor) %>%
  summarize(
    massacres = n(),
    numero_victimas_caso = sum(numero_victimas_caso, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(year = annoh, actor, massacres)

# Attacks
cnmh_a <- read_csv(here("data", "casos_ataques_poblaciones.csv")) %>%
  clean_names()

# Agreggate
cnmh_a_year <- cnmh_a %>%
  mutate(
    actor = case_when(
      descripcion_presunto_responsable == "Autodefensas unidas de colombia auc" ~ "Paramilitaries",
      descripcion_presunto_responsable == "Farc" ~ "FARC"
    )
  ) %>%
  filter(actor %in% c("Paramilitaries", "FARC"),
         annoh != 0) %>%
  group_by(annoh, actor) %>%
  summarize(
    attacks = n(),
    numero_victimas_caso = sum(numero_victimas_caso, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(year = annoh, actor, attacks)

# Merge
cnmh_actor_year <- cnmh_m_year %>%
  full_join(cnmh_t_year) %>%
  full_join(cnmh_a_year) %>%
  rename(cnmh_attacks = attacks, 
         cnmh_terroristacts = terroristacts,
         cnmh_massacres = massacres)

# GTD data ####

# Read data
gtd <- read_excel(here("data", "globalterrorismdb_0919dist.xlsx"))

# Subset to colombia
gtd <- gtd %>% filter(country_txt == "Colombia")

# Recode
gtd <- gtd %>%
  mutate(
    year = iyear,
    actor = case_when(
      gname == "Revolutionary Armed Forces of Colombia (FARC)" ~ "FARC",
      gname %in% c("Narco-Terrorists", 
                   "Death to Kidnappers (MAS)",
                   "Medellin Drug Cartel",
                   "The Extraditables") ~ "Medellín Cartel",
      gname == "Cali Narcotics Cartel" ~ "Cali Cartel",
      gname %in% c("Black Eagles",
                   "Peasant Self-Defense Group (ACCU)", 
                   "Paramilitaries",
                   "Right-Wing Paramilitaries", 
                   "United Self Defense Units of Colombia (AUC)",
                   "Gaitanista Self-Defense Forces of Colombia (AGC)",
                   "Los Rastrojos (Colombia)",
                   "Macetos (Paramilitary Group)") ~ "Paramilitaries"
    )
  ) 

# Subset data - only 4 actors
gtd <- gtd %>%
  filter(
    actor %in% c("FARC", "Paramilitaries", "Medellín Cartel", "Cali Cartel")
  )

# Agreggate to actor-year
gtd_actor_year <- gtd %>%
  count(year, actor, name = "gtd_terroristacts")

# Merge CNMH & GTD ####

terr_data <- cnmh_actor_year %>% # CNMH 
  full_join(gtd_actor_year)

# Save dataset ####

write_csv(terr_data, here("output", "terr_data.csv"))
write_rds(terr_data, here("output", "terr_data.rds"))

# Clear console and environment
rm(list = ls())
cat("\14")
