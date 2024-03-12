load("data/pib_mensal.rda")

pib <- pib_mensal |> 
  summarise(.by = ano, pib = sum(pib))

save(pib, file = "data/pib.rda")