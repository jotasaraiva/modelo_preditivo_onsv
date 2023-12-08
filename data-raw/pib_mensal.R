read_pib <- function() {
  pib <- read_delim(
    here("data-raw","pib_mensal","pib_bacen_dolar.csv"),
    delim = ";", locale = locale(encoding = "latin1"),
    col_names = c("data","pib"), skip = 1
  )
  
  pib <- pib[pib$data != "Fonte", ]
  
  pib <- pib |> 
    mutate(
      pib = pib |> 
        str_replace("\\.","") |> 
        str_replace(",",".") |> 
        as.numeric(),
      data = my(data)
    ) |> 
    mutate(mes = month(data),
           ano = year(data)) |> 
    select(-data)
  
  return(pib)
}

pib_mensal <- read_pib()

save(pib_mensal, file = "data/pib_mensal.rda")