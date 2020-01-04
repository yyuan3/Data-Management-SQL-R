library(tidyverse)
library(lubridate)
library(stringr)
amazon_orig<- read_csv("https://itao-datasets.s3.amazonaws.com/aff_2012.csv")
amazon <- amazon_orig

amazon1 <- amazon%>%
  select(`GEO.display-label`,`NAICS.display-label`,SEX.id,`SEX.display-label`,PAYANN,EMP)

#delete first row
amazon1 <- amazon1[-1,]


#filter sex
amazon2 <- amazon1%>%
  filter(SEX.id=="002"|SEX.id=="003"|SEX.id=="004")%>%
  filter(`NAICS.display-label`!='Total for all sectors')


#replace
amazon2 <- amazon2 %>%
  mutate(EMP=replace(EMP, EMP=='a', '10')) %>%
  mutate(EMP=replace(EMP, EMP=='b', '60')) %>%
  mutate(EMP=replace(EMP, EMP=='c', '175')) %>%
  mutate(EMP=replace(EMP, EMP=='e', '375')) %>%
  mutate(EMP=replace(EMP, EMP=='f', '750')) %>%
  mutate(EMP=replace(EMP, EMP=='g', '1750')) %>%
  mutate(EMP=replace(EMP, EMP=='h', '3750')) %>%
  mutate(EMP=replace(EMP, EMP=='i', '7500')) %>%
  mutate(EMP=replace(EMP, EMP=='j', '17500')) %>%
  mutate(EMP=replace(EMP, EMP=='k', '37500')) %>%
  mutate(EMP=replace(EMP, EMP=='l', '75000')) %>%
  mutate(PAYANN=replace(PAYANN, PAYANN=='S', 'NA'))%>%
  mutate(`SEX.display-label`=replace(`SEX.display-label`, `SEX.display-label`=='Female-owned', 'Female'))%>%
  mutate(`SEX.display-label`=replace(`SEX.display-label`, `SEX.display-label`=='Male-owned', 'Male'))%>%
  mutate(`SEX.display-label`=replace(`SEX.display-label`, `SEX.display-label`=='Equally male-/female-owned', 'Equal'))%>%
  mutate(PAYANN=as.integer(PAYANN*1000))%>%
  mutate(EMP=as.integer(EMP))


amazon3 <- amazon2%>%
  select(`GEO.display-label`,`NAICS.display-label`,`SEX.display-label`,PAYANN,EMP)


amazon3 <- separate(amazon3,`GEO.display-label`,c('Country','State'),',')
head(amazon3)
amazon3 <- amazon3%>%
  mutate(PAYANN=as.integer(PAYANN),EMP=as.integer(EMP))%>%
  mutate(AVERAGEPAY=round(PAYANN/ EMP))%>%
  select(-PAYANN,-EMP)
amazon3

amazon4 <- amazon3%>%
  spread(`SEX.display-label`,AVERAGEPAY)
colnames(amazon4) <- c('county','state','sector','equal','female','male')
amazon4

amazon5 <- amazon4 %>%
  filter( !((is.na(equal)) & (is.na(female)) & (is.na(male)) ))%>%
  arrange(state,county,sector)
amazon5

#Save Data

dim(amazon5)

write_csv(amazon5,'C://Users/yuanye/Desktop/ND learning/3.data management/R/tidyverse/yyuan3_2.csv',na='')


















  