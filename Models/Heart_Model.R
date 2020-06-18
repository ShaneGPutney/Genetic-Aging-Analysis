# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
Heart_tissue <- tissue_parser(tpms, attributes, pheno, "Heart")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(Heart_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

Heart_tissue <- pc_subsetter(Heart_tissue)

# For initial testing (commented out)
#library(tidymodels)
#Heart_split <- initial_split(Heart_tissue, prop = 9/10, strata = AGE)
#Heart_training <- training(Heart_split)
#Heart_test <- testing(Heart_split)

# Create our Heart_model
Heart_model<-age_tissue_guesser(Heart_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
Heart_preds <- predict_age(Heart_model, Heart_tissue)
