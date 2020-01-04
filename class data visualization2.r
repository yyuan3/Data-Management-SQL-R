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



head(college)
glimpse(college)
summary(college)
# create a plot of tuit sat scores
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition,
                         shape=control))#add shape for control
#shape works,but is hard ti read. Lets try color instead
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition,
                         color=control))#add color for control

#try a line graph
ggplot(data=college) +
  geom_line(mapping=aes(x=sat_avg,
                         y=tuition,
                         color=control))#add color for control

#how well would a line fit this data? Try a different geom
ggplot(data=college) +
  geom_smooth(mapping=aes(x=sat_avg,
                        y=tuition,
                        color=control))


#how well it fits
ggplot(data=college) +
  geom_smooth(mapping=aes(x=sat_avg,
                          y=tuition,
                          color=control))
geom_point(mapping=aes(x=sat_avg,
                       y=tuition,
                       color=control))

# Lets make this less verbose and clean up our code
ggplot(data=college,
       mapping=aes(x=sat_avg,
                   y=tuition,
                   color=control))
  geom_smooth() +
  geom_point() +
  geom_line()
  
#Tuition vs institutional control (pub/priv)
ggplot(data=college)+
  geom_jitter(mapping=aes(x=control,
                         y=tuition))

#boxplot
ggplot(data=college)+
  geom_boxplot(mapping=aes(x=tuition,
                          y=faculty_salary_avg))

#compare tuition and faculty salaries
ggplot(data=college)+
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=control))
#what about public/private
ggplot(data=college)+
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=control))
#Facts can separate these into similar graphs
ggplot(data=college)+
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=control))+
  facet_wrap(~ control)

#facets help here quite a bit
ggplot(data=college)+
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=highest_degree))+
  facet_wrap(~ highest_degree)

# Adimission VS SAT
ggplot(data=college)+
  geom_point(mapping=aes(x=sat_avg,
                         y=admission_rate,
                         color=control))+
  facet_wrap(~ region)

#what kind of geom to depict number of colleges by region?
ggplot(data=college) +
  geom_bar(mapping=aes(x=region,
                       color=control))
#Public vs private
ggplot(data=college)+
  geom_bar(mapping=aes(x=region,
                       fill=control))

#Instead,lets use a map-not a bar chart
states <- map_data("state")

#draw a state map
ggplot() +
  geom_polygon(data=states,
               aes=(x=long,
                    y=lat,
                    group=group)
               color ="white",
               fill = "grey10") +
  coord_map()#nice!









