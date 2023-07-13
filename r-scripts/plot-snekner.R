# Cluster conotoxins by kmer freqs
# input: Sneckner outputs "bsf_matrix.csv"
#

# set working directory (has to be customized for each computer)
setwd("Dropbox/cono-models/")
library(tidyverse)
# read matrix file
x <- read_csv("output-k4-m1/cluster/bsf/bsf_matrix.csv", col_names = F)

# read toxin ids
id <- read_tsv("output-k4-m1/protein-ids.tsv", col_names = F)

# pair-wise distance matrix:
x.mat <- as.matrix(x)
rownames(x.mat) <- id$X1

# Get PCAs
x.pca <- princomp(x.mat)

# retrieve scores & plot first two PCs
x.pc <- x.pca$scores[,1:2]
x.pc <- tibble(id = rownames(x.pc), pc1 = x.pc[,1], pc2 = x.pc[,2])
x.pc %>% ggplot(aes(x = pc1, y = pc2)) +
  geom_point(shape = 1) +
  theme_bw()

# To do: Estimate pca, t-sne and Umap clusters from pairwise distance matrix ("x.mat")
