library(tidyverse)
library(tidymodels)
library(onsvplot)
library(here)
tidymodels_prefer()
options(scipen = 999)

load(here("data/tabela_total.rda"))

source("R/linear_model.R")

res <- df_total |> 
  lm_model() |> 
  lm_extract(df_total)

prediction <- res$pred