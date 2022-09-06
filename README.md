# Alpha
# Language: R
# Input: TXT
# Output: PNG
# Tested with: PluMA 2.0, R 4.0
# Dependencies: stringr_1.4.0   scales_1.1.1    ggpubr_0.4.0    ggplot2_3.3.5
# vegan_2.5-7     lattice_0.20-41 permute_0.9-5


PluMA plugin to compute and plot Alpha diversity (PNG).  

Input is a TXT file of tab-delimited keyword-value pairs:
abundance: Abundance matrix
metadata: Metadata
samplecol: Column to use for sample name
classcol: Column to differentiate
class1: Class A
class2: Class B

