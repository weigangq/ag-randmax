#load libraries
library(tidyverse)
library(dplyr)
library(readr)


#load the files
#change columns

conotoxins <- read_csv("~/CSB-BIOL425/python/channels_part2.csv")
colnames(conotoxins) <- c("channels", "record_name", "full_sequence")
head(conotoxins)

#############################################################################
#Replace all the channels name that deviates from the original family
# Replace with NA
# Conotoxin, Consomatin, Contryphan, Conopeptides, Conantokin
conotoxins[conotoxins == "Conotoxin"] <- NA
conotoxins[conotoxins == "Consomatin"] <- NA
conotoxins[conotoxins == "Conantokin"] <- NA
conotoxins[conotoxins == "Contryphan"] <- NA
conotoxins[conotoxins == "Conopeptide"] <- NA
conotoxins[conotoxins == "Glacontryphan"] <- NA
conotoxins[conotoxins == "Conomarphin"] <- NA
conotoxins[conotoxins == "Cysteine"] <- NA
conotoxins[conotoxins == "Contulakin"] <- NA
conotoxins[conotoxins == "putative"] <- NA


#############################################################################
conotoxins_2 <- read_csv("~/CSB-BIOL425/python/ama_mature_two.csv")
colnames(conotoxins_2) <- c("record_name", "mature_sequence")

conotoxins_mature <- conotoxins_2 %>% 
  select(mature_sequence)

write_csv(conotoxins_mature, "~/CSB-BIOL425/python/conotoxins_mature.csv")

#contain the mature sequence and the framework
conochannels_mature <- read_csv("~/CSB-BIOL425/python/conochannels_mature.csv", colnames("FALSE"))
colnames(conochannels_mature) <- c("mature_sequence", "cysteine_framework", "framework")

#################################################################################  

#merge the two objects

(conotoxins_channels <- merge(x = conotoxins,
                             y = conotoxins_2,
                             by = "record_name"
  
))


#merge again
(conomature_framework <- merge(x = conotoxins_channels,
                              y = conochannels_mature,
                              by = "mature_sequence"
                              
))

conomature_framework %>% 
  select(mature_sequence) %>%
  unique() %>% 
  count()
  

#####################################################################
#export the dataframe 

write_csv(conotoxins_channels, "~/CSB-BIOL425/python/conotoxins_merge.csv")
write_csv(conomature_framework, "~/CSB-BIOL425/python/conomature_merge.csv")

##########################################################################
con <- conotoxins %>% 
  select(channels) %>% 
  unique()

#work on conotoxins
cono_channels <- function(x = "Novel"){
  conotoxins %>% 
    filter(channels == x) %>% 
    group_by(channels) %>% 
    count()
}
  
#call the function
cono_channels(x = "Alpha")
#143
#alpha is a nACHR


#######################################################################################################

#Tidy the data that contains only the ion channels
cono_alpha <- conomature_framework %>% 
  filter(channels %in% c("Gamma", "Epsilon", "Iota", "Kappa", "Mu", "Omega", "Delta", "Alpha")) %>%
  select(channels, framework) %>%
  group_by(framework, channels) %>% 
  count()


cono_alpha %>% 
  ggplot(aes(x = framework, y = n))+
  geom_col()+
  facet_wrap(~channels)
#######################################################################################
#Alpha" family with framework 1, primarily contains A superfamily
#Inhibitors of nAChR
cono_alpha %>% 
  filter(channels == "Alpha")
  


