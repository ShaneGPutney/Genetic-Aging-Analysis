# Uncomment if you need to load datasets
#setwd("~/Data Science Projects/RNA_TPM")
# Put our datasets into memory
#tpms <- fread("tpm.gct") 
#pheno <- fread("Pheno.txt")
#attributes <- fread("attributes.txt")

# Use tissue parser to grab interesting tissue type
BloodVessel_tissue <- tissue_parser(tpms, attributes, pheno, "Blood Vessel")

# Set protein coding genes symbol
pc_id<-protein_coding_parser(BloodVessel_tissue)

# Grab only the genes that are protein coding genes
pc_subsetter <- function(data_tissue){
  return(data_tissue %>% 
           select.(SAMPID, SMTS, SEX, AGE, DTHHRDY, c(pc_id)))
}

BloodVessel_tissue <- pc_subsetter(BloodVessel_tissue)

# For initial testing (commented out)
#library(tidymodels)
#BloodVessel_split <- initial_split(BloodVessel_tissue, prop = 9/10, strata = AGE)
#BloodVessel_training <- training(BloodVessel_split)
#BloodVessel_test <- testing(BloodVessel_split)

# Create our BloodVessel_model
BloodVessel_model<-age_tissue_guesser(BloodVessel_tissue,
                                    max_sample = 350,
                                    v=6,
                                    metric = "accuracy")

# See how it did
BloodVessel_preds <- predict_age(BloodVessel_model, BloodVessel_tissue)
