setwd("~/Dropbox/cono-models/weigang/")
setwd("../../Dropbox/cono-models/weigang/")
library(tidyverse)

# elite selection
x1 <- read_tsv("test-alg1.tsv", col_names = F)
colnames(x1) <- c("tag", "tsize", "fit", "bin_str", "fit_elite", "fit_avg", "asize", "alg")
x1 <- x1 %>% 
  mutate(label = paste("target", sprintf("%02d", tsize)))
#x1 <- x %>% 
#  mutate(tsize = nchar(auto))

x1 %>% 
  ggplot(aes(x=asize, y=fit_avg)) +
  #geom_boxplot(outlier.shape = NA) +
  geom_jitter(shape=1) + 
  facet_wrap(~label) +
#  geom_vline(aes(xintercept = tsize ), linetype = 2) +
  theme_bw() +
  xlab("size of automata (number of states in an automata)") +
  ylab("average fitness (at g=100)") +
  labs(title = "Simulated origin of sociality with automata", subtitle = "Test 1. Adaptation to a predefined target binary string, with elite (top 10) selection", caption = "N=40 automata, g=100, mut=1/3")

# tournment selection
x2 <- read_tsv("test-alg2.tsv", col_names = F)
colnames(x2) <- c("tag", "tsize", "fit", "bin_str", "fit_elite", "fit_avg", "asize", "alg")
x2 <- x2 %>% 
  mutate(label = paste("target", sprintf("%02d", tsize)))

x2 %>% 
  ggplot(aes(x=asize, y=fit_avg)) +
  geom_jitter(shape=1) + 
  facet_wrap(~label) +
#  geom_vline(aes(xintercept = tsize ), linetype = 2) +
  theme_bw() +
  xlab("size of automata (number of states in an automata)") +
  ylab("average fitness (at g=100)") +
  labs(title = "Simulated origin of sociality with automata", subtitle = "Test 1. Adaptation to a predefined target binary string, with tournament selection", caption = "N=40 automata, g=100, mut=1/3")

x <- bind_rows(x1, x2)
x %>% 
  group_by(tsize, asize, alg) %>% 
  summarise(mean.fit = mean(fit_avg), sd.fit = sd(fit_avg)) %>% 
  mutate(label = paste("target", sprintf("%02d", tsize))) %>% 
  mutate(alg2 = if_else(alg == 1, 'elite', 'tournament')) %>% 
  ggplot(aes(x=asize, y=mean.fit, ymin = mean.fit - sd.fit, ymax = mean.fit + sd.fit, color = alg2)) +
  geom_point(shape = 1) + 
  geom_errorbar() +
  geom_line() + 
  theme_bw() + 
  geom_hline(yintercept = 1, linetype = 2) +
  facet_wrap(~label) + 
  theme(legend.position = "bottom")
