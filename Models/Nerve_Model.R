# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Nerve_tissue <- tissue_parser(tpms, attributes, pheno, "Nerve")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Nerve_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Nerve_tissue <- pc_subsetter(Nerve_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Nerve_split <- initial_split(Nerve_tissue, prop = 9/10, strata = AGE)
#Nerve_training <- training(Nerve_split)
#Nerve_test <- testing(Nerve_split)

# Create our Nerve_model
Nerve_model<-age_tissue_guesser(Nerve_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Nerve_preds <- predict_age(Nerve_model, Nerve_tissue)
