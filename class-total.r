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

# Create a plot of tuition vs. SAT scores
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition))

# Let's add a shape to differentiate institutional control
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition,
                         shape=control)) # Add shape for control

# Shape works, but is hard to read.  Let's try color instead
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition,
                         color=control)) # Try color for control

# Let's try a line graph instead.
ggplot(data=college) +
  geom_line(mapping=aes(x=sat_avg, # change geometry to line from point
                         y=tuition,
                         color=control)) # Try color for control

# How well would a line fit this data?  Try a different geom
ggplot(data=college) +
  geom_smooth(mapping=aes(x=sat_avg, # change geom from line to fitted line
                          y=tuition,
                          color=control)) # Try color for control

# Let's add back the plot geom to see how well it fits
ggplot(data=college) +
  geom_smooth(mapping=aes(x=sat_avg, # change geom from line to fitted line
                          y=tuition,
                          color=control)) + # Try color for control
  geom_point(mapping=aes(x=sat_avg,
                         y=tuition,
                         color=control))

# Let's make this less verbose and clean up our code
ggplot(data=college,
       (mapping=aes(x=sat_avg, # change geom from line to fitted line
                    y=tuition,
                    color=control))) + # Try color for control
  geom_smooth() +
  geom_point()

# Connect the dots - how?
ggplot(data=college,
       (mapping=aes(x=sat_avg, # change geom from line to fitted line
                    y=tuition,
                    color=control))) + # Try color for control
  geom_smooth() +
  geom_point() +
  geom_line()

# Tuition vs institutional control (pub/priv)
ggplot(data=college) +
  geom_point(mapping=aes(x=control,
                         y=tuition))

# Better visualize - add some jitter
ggplot(data=college) +
  geom_jitter(mapping=aes(x=control,
                          y=tuition))

# Even better - a boxplot
ggplot(data=college) +
  geom_boxplot(mapping=aes(x=control,
                           y=tuition))

# Compare tuition and faculty salaries
ggplot(data=college) + 
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg))

# What about public/private
ggplot(data=college) + 
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=control))

# Facets can separate these into similar graphs
ggplot(data=college) + 
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=control)) +
  facet_wrap(~ control)

# College by highest granting degree
ggplot(data=college) + 
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=highest_degree)) 

# Facets help here quite a bit
ggplot(data=college) + 
  geom_point(mapping=aes(x=tuition,
                         y=faculty_salary_avg,
                         color=highest_degree)) +
  facet_wrap(~ highest_degree)

# Admissions vs. SAT average?
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=admission_rate))

# Does public/private make a difference?
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=admission_rate,
                         color=control))


# Does geography make a difference?
ggplot(data=college) +
  geom_point(mapping=aes(x=sat_avg,
                         y=admission_rate,
                         color=control)) +
  facet_wrap(~ region)

# What kind of geom to depict number of colleges by region?
ggplot(data=college) +
  geom_bar(mapping=aes(x=region))

# Public vs private?
ggplot(data=college) +
  geom_bar(mapping=aes(x=region,
                       color=control))

# That is awful to read - it is simply an outline!
ggplot(data=college) +
  geom_bar(mapping=aes(x=region,
                       fill=control))

# What about at the state level?
ggplot(data=college) +
  geom_bar(mapping=aes(x=state,
                       fill=control))

# Instead, let's use a map - not a bar chart.
states <- map_data("state")

# Draw a state map
ggplot() +
  geom_polygon(data=states,
               aes(x=long,
                   y=lat,
                   group=group),
               color="white",
               fill="grey10")

# Make the map reflect the fact that Earth isn't flat...
ggplot() +
  geom_polygon(data=states,
               aes(x=long,
                   y=lat,
                   group=group),
               color="white",
               fill="grey10") +
  coord_map() # nice!

# Let's layer in our college data
ggplot() +
  geom_polygon(data=states,
               aes(x=long,
                   y=lat,
                   group=group),
               color="white",
               fill="grey10") +
  coord_map() +
  geom_point(data=college,
             aes(x=lon,
                 y=lat))

# Filter out outliers - AK and HI
college_noakhi <- filter(college,
                         state != 'AK' &
                           state != 'HI')

ggplot() +
  geom_polygon(data=states,
               aes(x=long,
                   y=lat,
                   group=group),
               color="white",
               fill="grey10") +
  coord_map() +
  geom_point(data=college_noakhi,
             aes(x=lon,
                 y=lat))

# Add in some color to help
ggplot() +
  geom_polygon(data=states,
               aes(x=long,
                   y=lat,
                   group=group),
               color="white",
               fill="grey10") +
  coord_map() +
  geom_point(data=college_noakhi,
             aes(x=lon,
                 y=lat,
                 color=control)) # Add in some color

# Let's get just Indiana
indiana_colleges <- college %>%
  filter(state=="IN")

# Now that we have the institutions, let's get a map of just IN!
indiana_mapdata <- map_data(map="county",
                            region="indiana")

# This works too! :)
indiana_mapdata2 <- map_data(map="county",
                            region="IN")

# Build the map!
ggplot() +
  geom_polygon(data=indiana_mapdata,
               aes(x=long,
                   y=lat,
                   group=group),
               color="black",
               fill="beige") +
  coord_map()

# Let's add the schools.
ggplot() +
  geom_polygon(data=indiana_mapdata,
               aes(x=long,
                   y=lat,
                   group=group),
               color="black",
               fill="beige") +
  coord_map() +
  geom_point(data=indiana_colleges,
             aes(x=lon,
                 y=lat,
                 color=control,
                 size=undergrads,
                 alpha=0.9)) # alpha for transparency adjustment
# Let's clean up this map!
ggplot() +
  geom_polygon(data=indiana_mapdata,
               aes(x=long,
                   y=lat,
                   group=group),
               color="black",
               fill="beige") +
  coord_map() +
  geom_point(data=indiana_colleges,
             aes(x=lon,
                 y=lat,
                 color=control,
                 size=undergrads,
                 alpha=0.9)) +
  theme(panel.grid = element_blank(), # Get rid of the grid lines!
        panel.background = element_blank(),# Get rid of the background!
        axis.title = element_blank(),# Get rid of the axes!
        axis.ticks = element_blank())

# Add in the title
ggplot() +
  geom_polygon(data=indiana_mapdata,
               aes(x=long,
                   y=lat,
                   group=group),
               color="black",
               fill="beige") +
  coord_map() +
  geom_point(data=indiana_colleges,
             aes(x=lon,
                 y=lat,
                 color=control,
                 size=undergrads,
                 alpha=0.9)) +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank()) +
  ggtitle("Indiana Colleges and Universities 2016",
          subtitle = "Source: US Department of Education") +
  scale_alpha_continuous(guide=FALSE) + # Got rid of alpha here
  scale_color_discrete(name="Institutional Control") + 
  scale_size_continuous(name="Undergraduate Population",
                        range=c(1,15)) 
  # Bump up point size