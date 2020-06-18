# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Muscle_tissue <- tissue_parser(tpms, attributes, pheno, "Muscle")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Muscle_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Muscle_tissue <- pc_subsetter(Muscle_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Muscle_split <- initial_split(Muscle_tissue, prop = 9/10, strata = AGE)
#Muscle_training <- training(Muscle_split)
#Muscle_test <- testing(Muscle_split)

# Create our Muscle_model
Muscle_model<-age_tissue_guesser(Muscle_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Muscle_preds <- predict_age(Muscle_model, Muscle_tissue)
