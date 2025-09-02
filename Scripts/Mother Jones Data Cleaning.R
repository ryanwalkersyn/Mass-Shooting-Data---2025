install.packages("tidyverse")
install.packages("scales")
install.packages("here")
library(tidyverse)
library(scales)
library(here)


# Open source data from "Mother Jones - www.motherjones.com"
## !!!! NOT INCLUDED IN REPOSITORY !!!!
## mass_shooting_events <- read.csv(here("Data", "Data/Mother Jones - Mass Shootings Database, 1982 - 2025.csv"))


#### Data Cleaning ####
# Column Name
# Action Taken

# case - Chr
# N/A

# location - Chr
# N/A

# date - Chr
# convert to date
mass_shooting_events$date <- mass_shooting_events$date %>% mdy()

# summary - Chr
# N/A

# fatalities - Int
# N/A

# injured - Int
# N/A

# total_victims - Int
# N/A

# location.1 - Chr
# standardize rename to location_type
mass_shooting_events <- mass_shooting_events %>% rename(location_type = location.1)
mass_shooting_events <- mass_shooting_events %>% mutate(location_type = toupper(location_type))

# age_of_shooter - Chr
# convert to int
mass_shooting_events$age_of_shooter <- mass_shooting_events$age_of_shooter %>% as.integer()

# prior_signs_mental_health_issues - Chr
# convert to logical and rename to MH_issues_bool
mass_shooting_events <- mass_shooting_events %>% rename(MH_issues_bool = prior_signs_mental_health_issues)
mass_shooting_events <- mass_shooting_events %>% mutate(MH_issues_bool = toupper(MH_issues_bool))
mass_shooting_events <- mass_shooting_events %>% mutate(MH_issues_bool = case_when(
  MH_issues_bool == "YES" ~ TRUE,
  MH_issues_bool == "NO" ~ FALSE,
  TRUE ~ NA
))

# mental_health_details - CHR
# rename to MH_details
mass_shooting_events <- mass_shooting_events %>% rename(MH_details = mental_health_details)

# weapons_obtained_legally
# convert to logical and rename to W_legal
mass_shooting_events <- mass_shooting_events %>% rename(W_legal = weapons_obtained_legally)
mass_shooting_events <- mass_shooting_events %>% mutate(W_legal = toupper(W_legal))
mass_shooting_events <- mass_shooting_events %>% mutate(W_legal = case_when(
  W_legal == "YES" ~ TRUE,
  W_legal == "NO"~ FALSE,
  TRUE ~ as.logical("N/A")
))

# where_obtained - Chr
# rename to W_obtained
mass_shooting_events <- mass_shooting_events %>% rename(W_obtained = where_obtained)

# weapon_type - Chr
# standardize toupper and rename to W_type
mass_shooting_events <- mass_shooting_events %>% rename(W_type = weapon_type)
mass_shooting_events <- mass_shooting_events %>% mutate(W_type = toupper(W_type))

# weapon_details - Chr
# rename to W_details
mass_shooting_events <- mass_shooting_events %>% rename(W_details = weapon_details)

# race - Chr
# toupper
mass_shooting_events <- mass_shooting_events %>% mutate(race = toupper(race))

# gender
# convert data to M, F, O where M = Male, F = Female, O = Other
# trans individuals who identify as M or F will be recorded as their gender identity

mass_shooting_events <- mass_shooting_events %>% mutate(
  gender = case_when(
    gender == "M" ~ "M",
    gender == "F" ~ "F",
    gender == "Male" ~ "M",
    gender == "Female" ~ "F",
    TRUE ~ "O"
  )
)

# sources - Chr
# N/A

# mental_health_sources - Chr
# rename to MH_sources
mass_shooting_events <- mass_shooting_events %>% rename(MH_sources = mental_health_sources)

# sources_additional_age - Chr
# N/A

# latitude - Chr
# convert to numeric
mass_shooting_events <- mass_shooting_events %>% mutate(latitude = as.numeric(latitude))

# longitude - Chr
# convert to numeric
mass_shooting_events <- mass_shooting_events %>% mutate(longitude = as.numeric(longitude))

# type - Chr
# standardize to MASS and SPREE
mass_shooting_events <- mass_shooting_events %>% mutate(type = toupper(type))

# year - int
# removed for redundancy  
mass_shooting_events <- mass_shooting_events %>% select(-c(year))

# Annunciation Catholic Church data input
event <- data.frame(
  case = "Annunciation Catholic Church",
  location = "Minneapolis, MN",
  date = ymd("2025-08-27"),
  summary = "Robin Westman, trans individual, age 23, legally changed their name from Robert to Robin in 2019, killed two children and injured 17 others at a catholic school before dying to a self inflicted gunshot wound. Writings indicate deep interest in mass shootings and desire to kill, expressed tiredness in being trans in their diary before the attack",
  fatalities = 2L,
  injured = 17L,
  total_victims = 19L,
  location_type = "SCHOOL",
  age_of_shooter = 23,
  MH_issues_bool = NA,
  MH_details = "-",
  W_legal = TRUE,
  W_obtained = "-",
  W_type = "RIFLE, SHOTGUN, PISTOL",
  W_details = "-",
  race = "WHITE",
  gender = "O",
  sources = "https://www.foxnews.com/us/guns-used-minneapolis-church-school-shooter-robin-westman-were-purchased-legally-police-say",
  MH_sources = "-",
  sources_additional_age = "https://geohack.toolforge.org/geohack.php?pagename=Annunciation_Catholic_Church_shooting&params=44_54_17_N_93_17_9_W_type:event_region:US-MS",
  latitude = 44.904722,
  longitude = -93.285833,
  type = "MASS"
)
mass_shooting_events <- rbind(mass_shooting_events, event)
rm(event)

#### Export Clean Data ####
write.csv(mass_shooting_events, "../Data/Clean Shooting Events.csv")
