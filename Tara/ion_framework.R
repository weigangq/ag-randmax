#load the libraries

library(tidyverse)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggstatsplot)

#########################################################################
#Read the file

conotrain_modified <- read_csv("~/CSB-BIOL425/python/conotrain.csv")
colnames(conotrain_modified) <- c("Sequence", "Cysteine_framework", "Cysteine_count")
head(conotrain_modified)

conotrain_original <- read_csv("~/CSB-BIOL425/python/sandbox/Conotraining.csv")
colnames(conotrain_original) <- c("Class", "Sequence", "Acc_ID")
head(conotrain_original)


############################################################################
#Join the two file and save them to new objects
#two objects and common field

conotrain <- merge(x = conotrain_modified,
                y = conotrain_original,
                by = "Sequence" 
                
)
conotrain
#################################################################################

#tidy data

conotrain_tidy <- conotrain %>% 
  select(Cysteine_count, Class) %>% 
  group_by(Cysteine_count, Class) %>% 
  arrange(desc(Class)) %>% 
  count()
conotrain_tidy

#plot the barplot


conotrain_tidy %>% 
  ggplot(aes(x = Cysteine_count, y = n))+
  geom_col()+
  theme_bw()+
  facet_wrap(~Class)
#Calcium has 6 and 7 framework and novel
#Na and K channels lack novel framework
##################################################################################

#Distribution of the channels
conotrain_tidy %>% 
  ggplot(aes(x = Class, y = n))+
  geom_col()+
  theme_bw()


#Distribution of the framework
conotrain_tidy %>% 
  ggplot(aes(x = Cysteine_count, y = n))+
  geom_col()+
  theme_bw()

##############################################################################

#Tidy the related data
conotrain_tidy_1 <- conotrain_tidy %>% # new object 
  filter(Cysteine_count %in% c("novel", "6 and 7")) %>% 
  filter(Class %in% c("K", "Na")) %>% #framework 8 is the pharmacological interest
  group_by(Cysteine_count, Class) %>% 
  summarise(sum_total = sum(n))
conotrain_tidy_1

#plot the graph
conotrain_tidy_1 %>% 
  ggplot(aes(x = Cysteine_count, y = sum_total, fill = Class))+
  geom_col(stat = "identity", position = "dodge")

###########################################################################

#Chisquare test
conotrain_clean <- xtabs (sum_total ~ Class + Cysteine_count, data = conotrain_tidy_1)# for correct format
conotrain_clean
#chisquare test
conotrain_chi <- chisq.test(conotrain_clean)

conotrain_chi
conotrain_chi$expected
conotrain_chi$residuals# see where the observation lies compared to the expected
###############################################################################
#For K and Na
# Cysteine framework novel, "6 and 7"
# if the frequency distribution of two categorical variables are independent of each other using the contingency table analysis
cys_counts_potassium_sodium <- conotrain%>%
  group_by(Cysteine_count, Class) %>% #grouped data should be ungrouped
  filter(Class %in% c("K", "Na")) %>% 
  filter(Cysteine_count %in% c("novel", "6 and 7"))
cys_counts_potassium_sodium

cys_stats <- ggbarstats(
  data = cys_counts_potassium_sodium,
  x = Class,# rows in contingency table are mapped in x axis
  y = Cysteine_count,
  type = "nonparametric",
  label = "percentage" # both gives counts and percentage
)
cys_stats

#############################################################################
#For Ca and Na
cys_counts_calcium_sodium <-conotrain%>%
  group_by(Cysteine_count, Class) %>% #grouped data should be ungrouped
  filter(Class %in% c("Ca", "Na")) %>% 
  filter(Cysteine_count %in% c("novel", "6 and 7"))
cys_counts_calcium_sodium

cys_stats_2 <- ggbarstats(
  data = cys_counts_calcium_sodium,
  x = Class,# rows in contingency table are mapped in x axis
  y = Cysteine_count,
  type = "nonparametric",
  label = "percentage" # both gives counts and percentage
)
cys_stats_2

#for Ca and potassium
cys_counts_calcium_potassium <-conotrain%>%
  group_by(Cysteine_count, Class) %>% #grouped data should be ungrouped
  filter(Class %in% c("Ca", "K")) %>% 
  filter(Cysteine_count %in% c("novel", "6 and 7"))
cys_counts_calcium_potassium

cys_stats_3 <- ggbarstats(
  data = cys_counts_calcium_potassium,
  x = Class,# rows in contingency table are mapped in x axis
  y = Cysteine_count,
  type = "nonparametric",
  label = "percentage" # both gives counts and percentage
)
cys_stats_3
