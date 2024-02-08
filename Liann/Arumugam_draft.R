#Necessary libraries
library(tidyverse)
library(pzfx)
library(ggplot2)
library(tidyr)

#Lists all tables within the prism file
pzfx_tables("/Users/liann/Arumugam-etal-data.pzfx")

#Reading the whole dataset and storing it as a dataframe
df_Arumugam <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx")
view(df_Arumugam) 

#Creates a temp. file path for the data
tmp <- tempfile(fileext="Arumugam-etal-data.pzfx")

#Writes the dataframe to the prism file via tmp
write_pzfx(df_Arumugam, tmp, row_names=FALSE, x_col="VlsE")
out_df <- read_pzfx(tmp, table=1)
head(out_df)

#Reading the PTLDS table and storing it as a dataframe
df_PTLDS <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","NIH PTLDS ")
view(df_PTLDS) 

#Creates a temp. file path for PTLDS data
tmp_PTLDS <- tempfile(fileext="Arumugam-etal-data.pzfx")

#Writes the dataframe to the prism file via tmp_PTLDS
write_pzfx(df_PTLDS, tmp_PTLDS, row_names=FALSE, x_col="VlsE")
out_df <- read_pzfx(tmp_PTLDS, table=1)
head(out_df)

#Grouping columns as Antigens and rows as Optical Density
OD450 <- rownames(df_PTLDS)
Antigens <- colnames(df_PTLDS)

#Reshapes the data according to the new groups
long_PTLDS <- gather(df_PTLDS, Antigen, OD450)

#Code for the graph
ggplot(long_PTLDS, aes(x = Antigen, y = OD450)) +
  geom_point() +
  labs(x = "Antigens", y =expression("OD"[450]), title = "PTLDS (NIH)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),plot.title = element_text(hjust = 0.5))
