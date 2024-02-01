library(tidyverse)
library(fleetbr)

frota_mensal <- fleetbr |> 
  filter(modal %in% c("TOTAL", "AUTOMOVEL", "CAMINHONETE", "CAMIONETA", "UTILITARIO", 
                      "MOTOCICLETA", "CICLOMOTOR", "MOTONETA"),
         ano < 2023)

save(frota_mensal, file = "data/frota_mensal.rda")
  
