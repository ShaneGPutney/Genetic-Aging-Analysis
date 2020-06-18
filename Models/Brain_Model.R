# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Brain_tissue <- tissue_parser(tpms, attributes, pheno, "Brain")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Brain_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Brain_tissue <- pc_subsetter(Brain_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Brain_split <- initial_split(Brain_tissue, prop = 9/10, strata = AGE)
#Brain_training <- training(Brain_split)
#Brain_test <- testing(Brain_split)

# Create our Brain_model
Brain_model<-age_tissue_guesser(Brain_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Brain_preds <- predict_age(Brain_model, Brain_tissue)
