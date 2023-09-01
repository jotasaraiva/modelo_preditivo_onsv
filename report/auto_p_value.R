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
  rc_temp <- df_total |>
    recipe(mortes ~ .) |>
    step_naomit(all_numeric()) |> 
    step_select("mortes", i)
  
  wflow <- workflow() |>
    add_recipe(rc_temp) |>
    add_model(modelo)
  
  wflow_fit <- wflow |> fit(df_total)
  
  if (i == "ano") {
    p_valores <- wflow_fit |> tidy()
   
  } else {
    p_valores <- rbind(p_valores, wflow_fit |> tidy())
  }
}


p_valores <- filter(p_valores, term != "(Intercept)")

menor_pvalor <- filter(p_valores, p.value == min(p.value))

