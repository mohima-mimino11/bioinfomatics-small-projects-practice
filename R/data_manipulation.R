# script to manipulate gene expression data
# setwd("/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/data/GSE183947_fpkm.csv")


install.packages(c("dplyr", "tidyverse"))
install.packages("tidyverse")
# Install BiocManager if you don't have it yet
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# Install GEOquery from Bioconductor
BiocManager::install("GEOquery")
BiocManager::install("tidyverse")


# load libararies
library(dplyr)
library(tidyverse)
library(GEOquery)

# read in the data 

data <- read.csv(file="/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/data/GSE183947_fpkm.csv")

dim(data)

# get metadata

gse <- getGEO(GEO="GSE183947", GSEMatrix = TRUE )

gse

metadata <- pData(phenoData(gse[[1]]))

head(metadata)

metadata.modified <- metadata %>%
  select(1,10,11, 17) %>%
  rename(tissue = characteristics_ch1) %>%
  rename(metastasis = characteristics_ch1.1) %>%
  mutate(tissue = gsub("tissue: ", "", tissue)) %>%
  mutate(metastasis = gsub("metastasis: ", "", metastasis))
  
head(metadata.modified)

# reshaping the data

data.long <- data %>%
  rename(gene = X) %>%
  gather(key = 'samples', value = 'FPKM', -gene)

head(data.long)

#  join dataframes = data.long + metadata.modified

data.long <- data.long %>%
  left_join(., metadata.modified, by = c("samples" = "description")) 


# explore data

data.long %>%
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  group_by(gene, tissue) %>%
  summarize(mean_FPKM = mean(FPKM), median_FPKM = median(FPKM)) %>%
  arrange(-mean_FPKM)

