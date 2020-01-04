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


# Create a scatterplot with tuition on
# the x-axis and loan default rates on the y-axis.
ggplot(data=college)+
  geom_point(mapping=aes(x=tuition,
                         y=loan_default_rate))

length(college$loan_default_rate)
length(na.omit(college$loan_default_rate))

# Enhance your scatterplot by fitting a line to the data.
#zhijing
college %>% 
  ggplot()+
  geom_point(mapping = aes(x=tuition, y=loan_default_rate))+
  geom_smooth(mapping = aes(x=tuition, y=loan_default_rate))

college %>% 
  ggplot(mapping = aes(x=tuition, y=loan_default_rate))+
  geom_point()+
  geom_smooth(color = "green")
#geom_smooth(colour = "red")


ggplot(data=college) +
  geom_point(mapping = aes(x=tuition, 
                           y=loan_default_rate, color = region)) +
  geom_smooth(mapping = aes(x=tuition, 
                            y=loan_default_rate))

# Create a boxplot showing faculty salary broken out
# by the highest degree awarded by the institution.


ggplot(college) +
  geom_boxplot(mapping = aes(x=highest_degree,
                             y =faculty_salary_avg))

table(college$highest_degree)
# Let's get rid of Nondegree
college %>%
  filter(highest_degree != 'Nondegree') %>%
  ggplot() +
  geom_boxplot(mapping = aes(x=highest_degree,
                             y =faculty_salary_avg))


# Produce a statistical summary (using the summary() function) of all of the
# schools with a loan default rate over 20%.

college %>% 
  #filter(loan_default_rate > '0.2') %>% # don't do this - it is a string!
  filter(loan_default_rate > 0.2) %>%
  #select(name, loan_default_rate) %>% # Maybe add this to narrow down the results
  summary()

# Create a new tibble that contains only institutions with a faculty salary over
# $10K/month, sorted in descending order of salary and including only the
# institution name, state, and average salary.
high_salary_colleges <-  college %>%
  filter(faculty_salary_avg>10000) %>%
  select(name, state, faculty_salary_avg) %>%
  arrange(desc(faculty_salary_avg))

structure(high_salary_colleges)
#my_new_tibble <- as.tibble(my_existing_dataframe)

# Create a new tibble showing the number of 
# high salary schools in each state,
# with the highest count first.
high_salary_colleges%>%
  group_by(state)%>%
  summarise(count=n())%>%
  arrange(desc(count))

# Produce a tibble summarizing the
# total number of schools in each state.
state_count <- college %>%
  group_by(state) %>%
  summarize(count_schools = n()) %>%
  arrange(desc(count_schools))


#Weiyi Zhao
high_salary <- college %>% 
  filter(faculty_salary_avg>10000) %>% 
  select(name, state, faculty_salary_avg) %>% 
  arrange(desc(faculty_salary_avg)) %>% 
  group_by(state) %>% 
  summarize(SchoolCount=n()) %>% 
  arrange(desc(SchoolCount))

total_school <- college %>% 
  group_by(state) %>% 
  summarize(SchoolCount=n())

inner_total_record <- inner_join(high_salary,
                                 total_school,
                                 by = 'state') %>% 
  rename(Schools=SchoolCount.y,
         high_salary_schools=SchoolCount.x)
length(inner_total_record)

left_total_record <- left_join(total_school,
                               high_salary,
                               by = 'state') %>% 
  rename(Schools=SchoolCount.y,
         high_salary_schools=SchoolCount.x)

length(left_total_record)

dim(inner_total_record)
dim(left_total_record)


# Create column containing the % of
# schools in each state that are high salary,
# sort by that percentage in descending
# order and only include states where the
# value is 30% or higher.

left_total_record%>%
  mutate(percent_high_salary = (high_salary_schools/Schools)) %>%
  filter(percent_high_salary > .3) %>%
  arrange(desc(percent_high_salary))

college %>%
  mutate(rejectRate = 1-admission_rate) %>% 
  ggplot(aes(rejectRate, median_debt, color = control)) +
  geom_smooth(se=FALSE)+ # get rid of smoothing shadow
  theme_classic()+ # get rid of grid lines
  ggtitle("Student Debt Varies With School Selectivity",
          subtitle = 'Source: U.S Department of Education')+
  xlab("Rejection Rate")+
  ylab("MedianDebt(USD)") 


# Create a beautiful graph!
college %>%
  mutate(rejection_rate=1-admission_rate) %>%
  ggplot(mapping=aes(x=rejection_rate, y=median_debt, color=control)) +
  geom_smooth(se=FALSE) +
  ggtitle("Student Debt Varies With School Selectivity",
          subtitle="Source: U.S. Department of Education") +
  theme(panel.grid = element_blank(), panel.background = element_blank()) +
  theme(legend.key=element_blank()) +
  ylab("Median Debt (USD)") +
  xlab("Rejection Rate") +
  ylim(5000,45000) +
  xlim(0,1)
