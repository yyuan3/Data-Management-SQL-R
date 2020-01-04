# Clear out the environment
rm(list = ls())
# Data Management
#
# Class 1 Start Script

# Load relevant libraries, installing them if you haven't already done so
if (!require(tidyverse))
{
  install.packages("tidyverse")
} 
if (!require(ggmap))
{
  install.packages("ggmap")
} 
if (!require(maps))
{
  install.packages("maps")
} 
if (!require(mapproj))
{
  install.packages("mapproj")
} 

library(tidyverse)
library(ggmap)
library(maps)
library(mapproj)


# Read the college dataset.  
college <- read_csv("https://s3.amazonaws.com/itao-datasets/college.csv")

# Perform some data conversion. We'll discuss what this means later
college <- college %>%
  mutate(state=as.factor(state), region=as.factor(region),
         highest_degree=as.factor(highest_degree), control=as.factor(control),
         gender=as.factor(gender), loan_default_rate=as.numeric(loan_default_rate))

# Create a tibble of only private schools
filter(college,
       control == "Private")

# Store the results in a tibble
private_schools <- filter(college,
                          control == "Private")
ps <- filter(college,
             control == "private")
# The above doesn't work because R is case sensitive

# What's in the variable?
table(college$control)

# Private schools in Indiana
filter(college,
       control == "Private" &
         state == "IN")

# What about private schools in Indiana with more than 5000 undergrads
filter(college,
       control == "Private" &
         state == "IN" &
         undergrads > 5000)

# Private schools where the tuition is more than half of the annual
# salary of the average faculty member
filter(college,
       control == "Private" &
         tuition > 6 * faculty_salary_avg)

# Logical OR
# Private schools in Indiana or schools that have an average SAT
# score above 1500
# An IN student who scored 1505 and is looking at schools both in and
# out of state
filter(college,
       control == "Private" &
         (state == "IN" |
            sat_avg > 1500))

# Let's write the same thing with pipes %>%
IN_and_national <- college %>%
  filter(control == "Private" &
           (state == "IN" |
              sat_avg > 1500))

# Sort by name and store in a new tibble
sorted <- college %>%
  filter(control == "Private" &
           (state == "IN" |
              sat_avg > 1500)) %>%
  arrange(name)

# Reverse the alphabetical order
r_sorted <- college %>%
  filter(control == "Private" &
           (state == "IN" |
              sat_avg > 1500)) %>%
  arrange(desc(name))

# List of private schools with avg sat > 1400,
# Show only schoool name and SAT score, sorted by highest SAT score
college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400) %>%
  select(name, sat_avg) %>%
  arrange(desc(sat_avg))

# Store elite privates for later exploration
elite_privates <- college %>%
  filter(control == "Private") %>%
  filter(sat_avg > 1400)

glimpse(elite_privates)
summary(elite_privates)

# Add a column to elite_privates in a new tibble
# showing tuition as a percent of avg faculty salary
ep <- elite_privates %>%
  mutate(tuition_as_percent_salary = tuition/(12*faculty_salary_avg))

# Add a column to elite_privates in place
# showing tuition as a percent of avg faculty salary
elite_privates <- elite_privates %>%
  mutate(tuition_as_percent_salary = tuition/(12*faculty_salary_avg)) %>%
  mutate(tap_salary = tuition_as_percent_salary * 100)

# Rename name to school_name
elite_privates <- elite_privates %>%
  rename(school_name = name)

colnames(elite_privates)

# Let's explore summarise
# Summarize (or summarise) admission rate for elite privates
elite_privates %>%
  summarise(min = min(admission_rate),
            max = max(admission_rate),
            mean = mean(admission_rate))

# Explore group_by
# avg admission rate for each degree type
college %>%
  group_by(highest_degree) %>%
  summarise(admit = mean(admission_rate))

# Plot as a bar graph?
admissions_info <- college %>%
  group_by(highest_degree) %>%
  summarise(admit = mean(admission_rate))

# Plot it!
ggplot(data=admissions_info) +
  geom_col(mapping=aes(x=highest_degree,
                       y=admit))

# Don't need to store it - all in one
college %>%
  group_by(highest_degree) %>%
  summarise(admit = mean(admission_rate)) %>%
  ggplot() +
  geom_col(mapping=aes(x=highest_degree,
                       y=admit))

# Group by, faceted by control?
college %>%
  group_by(highest_degree) %>%
  summarise(admit = mean(admission_rate)) %>%
  ggplot() +
  geom_col(mapping=aes(x=highest_degree,
                       y=admit)) +
  facet_wrap(~ control)

admissions <- college %>%
  group_by(highest_degree,control)
glimpse(admissions)

# recreate with grouping on control
college %>%
  group_by(highest_degree, control) %>%
  summarise(admit = mean(admission_rate)) %>%
  ggplot + 
  geom_col(mapping=aes(x=highest_degree,
                       y=admit)) +
  facet_wrap(~ control)

glimpse(admissions)
# Get rid of the groups
ungroup(admissions)
admissions <- ungroup(admissions)
glimpse(admissions)

college %>%
  select(control) %>%
  filter(control == "Public") %>%
  summarise(total = n())

table(college$control)
n(college$control)