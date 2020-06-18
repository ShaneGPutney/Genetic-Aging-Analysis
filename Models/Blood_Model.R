# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Blood_tissue <- tissue_parser(tpms, attributes, pheno, "Blood")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Blood_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Blood_tissue <- pc_subsetter(Blood_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Blood_split <- initial_split(Blood_tissue, prop = 9/10, strata = AGE)
#Blood_training <- training(Blood_split)
#Blood_test <- testing(Blood_split)

# Create our Blood_model
Blood_model<-age_tissue_guesser(Blood_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Blood_preds <- predict_age(Blood_model, Blood_tissue)
