# setwd("/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects")

# load libraries
library(tidyverse)
library(ggplot2)

# data
# dat.long to be used generated from previous demo
# dat.long <- read.delim('../data/GSE183947_long_format.txt', header = T)

#basic format for ggplot
# ggplot(data, aes(x = variable, y = variable1)) +
#   geom_col()

# 1. Barplot
barplot <- data.long %>%
  filter(gene=='BRCA1') %>%
  ggplot(.,aes(x = samples, y = FPKM, fill = tissue)) +
  geom_col()

ggsave(barplot, filename="/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/breast_cancer_barplot.png")

#2.density 
density_plt <- data.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x = FPKM, fill = tissue)) +
  geom_density(alpha = 0.3)

ggsave(density_plt, filename = "/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/breast_cancer_density_plot.png")

# 3. boxplots
boxplot <- data.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x = metastasis, y = FPKM)) +
  geom_boxplot()

ggsave(boxplot, filename = "/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/breast_cancer_boxplots.png")

violinPlot <- data.long %>%
  filter(gene == 'BRCA1') %>%
  ggplot(., aes(x = metastasis, y = FPKM)) +
  geom_violin()

ggsave(violinPlot, filename = "/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/breast_cancer_violin_plot.png")

#4. scatter plot
scatter_plot <- data.long %>%
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  spread(key = gene, value = FPKM) %>%
  ggplot(.,aes(x = BRCA1, y = BRCA2, color = tissue)) +
  geom_point() +
  geom_smooth(method = 'lm', se= FALSE)

ggsave(scatter_plot, filename = "/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/breast_cancer_scatter_plot.png")


# 5. heatmap

genes.of.interest <- c('BRCA1', 'BRCA2', 'TP53', 'ALK', 'MYCN')

pdf("/media/mim/98f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/heatmap_save2.pdf", width = 10, height = 8)

data.long %>%
  filter(gene %in% genes.of.interest) %>%
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'red')

dev.off()

# ggsave(heatmap, filename = "/media/mim/98 f13536-4fbf-47cf-a5eb-647479dcaef1/personal-projects/bioinformatics_projects/R/plots/heatmap_save.pdf", width = 10, height = 8)
