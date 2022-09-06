# Title     : Alpha Diversity Calculation
# Objective : Calculate alpha diversity for metagenomics data
# Created by: Vitalii Stebliankin
# Created on: 9/22/19

# Input:
# Abundance matrix where rows are Samples  and column are taxa

# Output:
#   a file with calculated shannon index for each sample


library(vegan)
library(ggpubr)

library(scales)
library(stringr)
dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")

input <- function(inputfile) {
        pfix = prefix()
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
  abundance_path <<- paste(pfix, parameters["abundance", 2], sep="/")
  mapping_file <<- paste(pfix, parameters["metadata", 2], sep="/")
  sample_col <<- parameters["samplecol", 2]
  class_col <<- parameters["classcol", 2]
  class1 <<- parameters["class1", 2]
  class2 <<- parameters["class2", 2]
}

run <- function() {}

output <- function(outputfile) {

out_diversity = outputfile


######################################################################################################################
# Calculate Shannon in Simpson indexes
######################################################################################################################
matrix_a <-read.table(abundance_path, sep=",", header=TRUE, row.names = 1)

abundance_df <- as.data.frame(matrix_a)
abundance_df[is.na(abundance_df)] <- 0

# Shannon index
shannon_index <- diversity(abundance_df)
shannon_index <- as.data.frame(shannon_index)

# Simpson index
simpson_index <- diversity(abundance_df, "simpson")
simpson_index <- as.data.frame(simpson_index)

# Merge shannon and siimpson index
diversity_index = merge(shannon_index, simpson_index, by=0)

######################################################################################################################
# Check statistical signigicants
######################################################################################################################

# Map samples to the class
# Shannon index
class_m <- read.table(mapping_file, sep="\t", header=TRUE)
class_m <- as.data.frame(class_m)
diversity_merged <- merge(diversity_index, class_m, by.x="Row.names", by.y = sample_col)

# Output shennonn index
write.csv(diversity_merged, out_diversity)

# Rename class columns
colnames(diversity_merged)[colnames(diversity_merged)==class_col] <- "class"


# Check statistical significance 
diversity1 <- diversity_merged[diversity_merged$class==class1,]
diversity2 <- diversity_merged[diversity_merged$class==class2,]


t.test(diversity1$shannon_index,diversity2$shannon_index)
t.test(diversity1$simpson_index,diversity2$simpson_index)

p <- ggboxplot(diversity_merged, x = "class", y = "shannon_index",
               color = "class", palette = "jco",
               add = "jitter")
#  Add p-value
p + stat_compare_means()

# Change method
p + stat_compare_means(method = "t.test")

p <- ggboxplot(diversity_merged, x = "class", y = "simpson_index",
               color = "class", palette = "jco",
               add = "jitter")
#  Add p-value
p + stat_compare_means()

# Change method
p + stat_compare_means(method = "t.test")
}
