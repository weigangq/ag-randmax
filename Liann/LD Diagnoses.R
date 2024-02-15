#Necessary libraries
library(tidyverse)
library(pzfx)
library(ggplot2)
library(tidyr)

#Lists all tables within the prism file
pzfx_tables("/Users/liann/Arumugam-etal-data.pzfx")

#Reads the dataset and stores it
df_Arumugam <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx")

#Creates a temp. file path for the data
tmp <- tempfile(fileext="Arumugam-etal-data.pzfx")

#Writes the dataframe to the prism file via tmp
write_pzfx(df_Arumugam, tmp, row_names=FALSE, x_col="VlsE")
out_df <- read_pzfx(tmp, table=1)
head(out_df)

#Reads the PTLDS data and stores the output
df_PTLDS <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","NIH PTLDS ")

#Adds two new columns and stores the output
x.PTLDS <- df_PTLDS |> mutate(serum_id = 1:20, stage = 'Post Treatment') 

#Pivots data from wide to long and groups names into antigens etc.
PostTreatmentLD <- x.PTLDS |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")

#Substitutes to avoid discrepancies
PostTreatmentLD["antigen"] <- sub("pepVF\\*", "pepVF", PostTreatmentLD[["antigen"]])
PostTreatmentLD["antigen"] <- sub("p93", "p93/100", PostTreatmentLD[["antigen"]])
view(PostTreatmentLD)

#Reads the Suspected Convalescent Early Lyme data and stores the output
df_SCELD <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","NYSDOH Early Lyme n=39 C6+/IgG WB+ ")

#Adds the serum_id and stage columns
x.SusConELD <- df_SCELD |> mutate(serum_id = 1:44, stage = 'Suspected Convalescent Early Lyme') 

#Pivots data from wide to long 
SusConELD <- x.SusConELD |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")
view(SusConELD)

#Reads the Suspected Acute Early Lyme data and stores the output
df_SAELD <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","NYSDOH Early Lyme n=20 2-tier pos " )

#Remove Var.11 column to avoid discrepancies
df_SAELD1 <- subset(df_SAELD, select = -Var.11)

#Adds the serum_id and stage columns
x.SusAcuELD <- df_SAELD1 |> mutate(serum_id = 1:20, stage = 'Suspected Acute Early Lyme') 

#Pivots data from wide to long 
SusAcuELD <- x.SusAcuELD |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")
view(SusAcuELD)

#Reads the Confirmed Acute Early Lyme data and stores the output
df_CAELD <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","LDB Early Lyme confirmed 2-tier n=19 ")

#Adds two new columns and stores the output
x.AcuConELD <- df_CAELD |> mutate(serum_id = 1:19, stage = 'Confirmed Early Lyme') 

#Pivots data from wide to long
ConAcuELD <- x.AcuConELD |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")

#Substitutes to avoid naming discrepancies
ConAcuELD["antigen"] <- sub("pepVF\\*", "pepVF", ConAcuELD[["antigen"]])
view(ConAcuELD)

#Reads Lyme Arthritis data and stores it
df_LymArt <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","NIH late Lyme Arthritis n=20 ")

#Adds two new columns 
x.LymeArthritis <- df_LymArt |> mutate(serum_id = 1:20, stage = 'Lyme Arthritis')

#Pivots data from wide to long
LymeArthritis <- x.LymeArthritis |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")

#Substitutes to avoid naming discrepancies
LymeArthritis["antigen"] <- sub("pepVF\\*", "pepVF", LymeArthritis[["antigen"]])
view(LymeArthritis)

#Reads Healthy Control data and stores it
df_HC <- read_pzfx("/Users/liann/Arumugam-etal-data.pzfx","FL Healthy")

#Remove Var.11 column to avoid discrepancies
df_HC1 <- subset(df_HC, select = -Var.11) 

#Adds two new columns 
x.HC <- df_HC1 |> mutate(serum_id = 1:20, stage = 'Healthy')

#Pivots data from wide to long
HealthyControl <- x.HC |> pivot_longer(1:12, names_to = "antigen", values_to = "od450")
view(HealthyControl)

