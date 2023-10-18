library(tidyverse)
library(tidymodels)
library(onsvplot)
library(here)
tidymodels_prefer()
options(scipen = 999)

load(here("data/tabela_total.rda"))

source(here("R/linear_model.R"))

res <- df_total |> 
  lm_model() |> 
  lm_extract(df_total)

prediction <- res$pred

dados2022 <- list(
  "ano" = 2022,
  "qnt_acidentes" = 64547,
  "qnt_acidentes_fatais" = 4662,
  "condutores" = 79921178,
  "veiculos_total" = 115116532
) |> as.data.frame()

df_2022 <- bind_rows(drop_na(df_total), dados2022)

res2 <- df_total |>
  lm_model() |>
  lm_extract(df_2022)

prediction2 <- res2$pred