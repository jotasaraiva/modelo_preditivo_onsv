library(fleetbr)
library(dplyr)
library(tidyr)

frota_veiculos <- fleetbr |> 
  pivot_wider(names_from = modal, values_from = frota) |> 
  mutate(
    automovel = AUTOMOVEL + CAMINHONETE + CAMIONETA + UTILITARIO,
    motocicleta = MOTOCICLETA + CICLOMOTOR + MOTONETA,
    total = TOTAL
  ) |> 
  filter(mes == 7) |> 
  summarise(
    .by = ano,
    automovel = sum(automovel),
    motocicleta = sum(motocicleta),
    veiculos_total = sum(total)
  ) 

save(frota_veiculos, file = "data/frota_veiculos.rda")