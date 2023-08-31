library(tidyverse)
library(tidymodels)
library(here)
tidymodels_prefer()
options(scipen = 999)

load(here("data","tabela_total.rda"))

df_total <- df_total |> select(-mortos_por_pop)

p_valores <- list()

modelo <- linear_reg() |> set_engine("lm")

for (i in colnames(df_total)) {
  
  if(i != "mortes") {
    
    rc_temp <- recipe(
      df_total,
      vars = c("mortes", i),
      roles = c("outcome", "predictor")
    ) |> 
      step_naomit(all_numeric())
    
    wflow_fit <- workflow() |> 
      add_recipe(rc_temp) |> 
      add_model(modelo) |> 
      fit(df_total)
    
    if (i == "ano") {
      p_valores <- wflow_fit |> tidy()
    } else {
      p_valores <- rbind(p_valores, wflow_fit |> tidy())
    }
  }
}

p_valores <- filter(p_valores, term != "(Intercept)") |> arrange(p.value)

menor_pvalor <- filter(p_valores, p.value == min(p.value))