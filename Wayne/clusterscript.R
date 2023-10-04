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
x.pc2 <- tibble(id = rownames(x.pc), pc1 = x.pc[,1], pc2 = x.pc[,2]) %>% 
  left_join(feat, c("id" = "sequence"))

#plot and color pca by feature
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = species)) +
  geom_point(shape = 1) +
  theme_bw()
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw()
x.pc2 %>% ggplot(aes(x = pc1, y = pc2, color = sf)) +
  geom_point(shape = 1) +
  theme_bw()

#find optimal number of clusters (5)
fviz_nbclust(x.pc, kmeans, method = 'silhouette', k.max = 25)

#kmeans clustering for k=5,10,15,20,25
kmeans_pca = kmeans(x.pc, centers = 5, nstart = 100)
k.pca_clust <- kmeans_pca$cluster
x.pca_clust <- tibble(id = names(k.pca_clust), cluster = k.pca_clust)
x.pc3 <- x.pc2 %>% left_join(x.pca_clust, c("id" = "id"))

#visualize feature by cluster
x.pc3 %>% ggplot(aes(x = pc1, y = pc2, color = sf)) +
  geom_point() +
  facet_wrap(~cluster)
x.pc3 %>% ggplot(aes(x = pc1, y = pc2, color = species)) +
  geom_point() +
  facet_wrap(~cluster)
x.pc3 %>% ggplot(aes(x = pc1, y = pc2, color = fm.id)) +
  geom_point() +
  facet_wrap(~cluster)

#umap
x.umap <- umap(x.mat)
x.umap_layout = x.umap$layout[,1:2]
x.umap2 = tibble(id = rownames(x.umap_layout), UMAP1 = x.umap_layout[,1], UMAP2 = x.umap_layout[,2]) %>% 
  left_join(feat, c("id" = "sequence"))

#color umap by features
x.umap2 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = species)) +
  geom_point(shape = 1) +
  theme_bw()
x.umap2 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw()
x.umap2 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = sf)) +
  geom_point(shape = 1) +
  theme_bw()

#find optimal number of clusters (4)
fviz_nbclust(x.umap_layout, kmeans, method = 'silhouette', k.max = 25)

#kmeans clustering for k=5,10,15,20,25
kmeans_umap = kmeans(x.umap_layout, centers = 4, nstart = 100)
k.umap_clust <- kmeans_umap$cluster
x.umap_clust <- tibble(id = names(k.umap_clust), cluster = k.umap_clust)
x.umap3 <- x.umap2 %>% left_join(x.umap_clust, c("id" = "id") )

#visualize feature by cluster
x.umap3 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = species)) +
  geom_point() +
  facet_wrap(~cluster)
x.umap3 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = fm.id)) +
  geom_point() +
  facet_wrap(~cluster)
x.umap3 %>% ggplot(aes(x = UMAP1, y = UMAP2, color = sf)) +
  geom_point() +
  facet_wrap(~cluster)

#tsne
x_no_dup.mat = unique(x.mat)
x.tsne = Rtsne(x_no_dup.mat)
x.tsne_y = x.tsne$Y[,1:2]
x.tsne2 = tibble(id = rownames(x_no_dup.mat), Y1 = x.tsne_y[,1], Y2 = x.tsne_y[,2]) %>% 
  left_join(feat, c("id" = "sequence"))
rownames(x.tsne_y) <- x.tsne2 %>% pull(1)

#color tsne by features
x.tsne2 %>% ggplot(aes(x = Y1, y = Y2, color = species)) +
  geom_point(shape = 1) +
  theme_bw() 
x.tsne2 %>% ggplot(aes(x = Y1, y = Y2, color = fm.id)) +
  geom_point(shape = 1) +
  theme_bw() 
x.tsne2 %>% ggplot(aes(x = Y1, y = Y2, color = sf)) +
  geom_point(shape = 1) +
  theme_bw() 

#find optimal number of clusters (7)
fviz_nbclust(x.tsne_y, kmeans, method = 'silhouette', k.max = 25)

#kmeans clustering for k=5,10,15,20,25
kmeans_tsne = kmeans(x.tsne_y, centers = 7, nstart = 100)
k.tsne_clust <- kmeans_tsne$cluster
x.tsne_clust <- tibble(id = names(k.tsne_clust), cluster = k.tsne_clust)
x.tsne3 <- x.tsne2 %>% left_join(x.tsne_clust, c("id" = "id") )

#visualize features by cluster
x.tsne3 %>% ggplot(aes(x = Y1, y = Y2, color = species)) +
  geom_point() +
  facet_wrap(~cluster)
x.tsne3 %>% ggplot(aes(x = Y1, y = Y2, color = fm.id)) +
  geom_point() +
  facet_wrap(~cluster)
x.tsne3 %>% ggplot(aes(x = Y1, y = Y2, color = sf)) +
  geom_point() +
  facet_wrap(~cluster)

#TODO confusion matrix and calculate recall scores


