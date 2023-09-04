library(tidyverse)
library(tidymodels)
library(onsvplot)
library(here)
tidymodels_prefer()
options(scipen = 999)

load(here("data/tabela_total.rda"))

source("R/scripts.R")

res <- lm_complete(df_total) 