# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Colon_tissue <- tissue_parser(tpms, attributes, pheno, "Colon")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Colon_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Colon_tissue <- pc_subsetter(Colon_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Colon_split <- initial_split(Colon_tissue, prop = 9/10, strata = AGE)
#Colon_training <- training(Colon_split)
#Colon_test <- testing(Colon_split)

# Create our Colon_model
Colon_model<-age_tissue_guesser(Colon_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Colon_preds <- predict_age(Colon_model, Colon_tissue)
