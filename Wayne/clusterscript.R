# Cluster conotoxins by kmer freqs
# input: Sneckner outputs "terra_data_vector.csv"

#set working directory and load libraries
#setwd("/Users/waynelam/Dropbox/WayneQiuLab")
setwd("C:/Users/billp/Dropbox/WayneQiuLab")
library(tidyverse)
library(umap)
library(Rtsne)
library(factoextra)
library(cluster)

# read matrix, feature, and superfamily file, join features in feat
x <- read_csv("id_added_teratoxin_snekmer.csv", col_names = F, skip = 1)
feat <- read_csv("All_Toxins_v4.csv", col_names = T)
superfam <- read_csv("summary.csv")
feat <- feat %>% 
  mutate(species = str_extract(ToxinName, "^...")) %>% 
  rename(fm.id = `Framework Confirmation`) %>%
  rename(sequence = NewNamev3) %>%
  left_join(select(superfam, sequence, definitive_pred), by = 'sequence') %>%
  mutate(sf = ifelse(definitive_pred == "UNKNOWN", NA, definitive_pred)) %>%
  mutate(sf = ifelse(grepl("CONFLICT", definitive_pred), "CONFLICT", sf))
x.mat <- as.matrix(x[,-1])
rownames(x.mat) <- x %>% pull(1)

# Get PCAs
x.pca <- prcomp(x.mat, scale = TRUE, center = TRUE)

#visualize percentage of explained var for pcs
fviz_eig(x.pca)

# retrieve scores for first two pcs
x.pc = x.pca$x[,1:2]
x.pc2 <- tibble(id = rownames(x.pc), pc1 = x.pc[,1], pc2 = x.pc[,2])

#plot and color pca by feature
x.pc2 <- x.pc2 %>% 
  left_join(feat, c("id" = "NewNamev2"))
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = species)) +
  geom_point(shape = 1) +
  theme_bw()
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw() 
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = sf)) +
  geom_point(shape = 1) +
  theme_bw() 

#find optimal number of clusters (2)
fviz_nbclust(x.pc, kmeans, method = 'silhouette')

#kmeans clustering for k=5,10,15,20,25
kmeans_pca = kmeans(x.pc, centers = 5, nstart = 100)
fviz_cluster(kmeans_pca, data = x.pc) + 
  xlab('PC1') +
  ylab('PC2')

#how to visualize cluster AND features at the same time without overcrowding?

#umap
x.umap <- umap(x.mat)
x.umap_layout = x.umap$layout[,1:2]
x.umap2 = tibble(id = rownames(x.umap_layout), UMAP1 = x.umap_layout[,1], UMAP2 = x.umap_layout[,2])

#color umap by features
umap_plot <- x.umap2 %>% 
  left_join(feat, c("id" = "NewNamev2"))
umap_plot %>% ggplot(aes(x = UMAP1, y = UMAP2, color = species)) +
  geom_point(shape = 1) +
  theme_bw()
umap_plot %>% ggplot(aes(x = UMAP1, y = UMAP2, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw()
umap_plot %>% ggplot(aes(x = UMAP1, y = UMAP2, color = sf)) +
  geom_point(shape = 1) +
  theme_bw()

#find optimal number of clusters (2)
fviz_nbclust(x.umap_layout, kmeans, method = 'silhouette')

#kmeans clustering for k=5,10,15,20,25
kmeans_umap = kmeans(x.umap_layout, centers = 25, nstart = 100)
fviz_cluster(kmeans_umap, data = as.data.frame(x.umap_layout)) +
  xlab('UMAP1') +
  ylab('UMAP2')


#tsne
x_no_dup.mat = unique(x.mat)
tsne_out = Rtsne(x_no_dup.mat)
tsne_plot = tibble(x = tsne_out$Y[,1],
                   y = tsne_out$Y[,2])
tsne_plot2 = tsne_plot %>%
  mutate(id = rownames(x_no_dup.mat))

#color tsne by features
tsne_plot2 <- tsne_plot2 %>% 
  left_join(feat, c("id" = "NewNamev2"))
tsne_plot2 %>% ggplot(aes(x = x, y = y, color = species)) +
  geom_point(shape = 1) +
  theme_bw() +
  xlab("Y[,1]") +
  ylab("Y[,2]")
tsne_plot2 %>% ggplot(aes(x = x, y = y, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw() +
  xlab("Y[,1]") +
  ylab("Y[,2]")
tsne_plot2 %>% ggplot(aes(x = x, y = y, color = sf)) +
  geom_point(shape = 1) +
  theme_bw() +
  xlab("Y[,1]") +
  ylab("Y[,2]")

#find optimal number of clusters (7)
fviz_nbclust(tsne_plot, kmeans, method = 'silhouette')

#kmeans clustering for k=5,10,15,20,25
kmeans_umap = kmeans(tsne_plot, centers = 25, nstart = 100)
fviz_cluster(kmeans_umap, data = as.data.frame(tsne_plot)) +
  xlab('Y[,1]') +
  ylab('Y[,2]')



