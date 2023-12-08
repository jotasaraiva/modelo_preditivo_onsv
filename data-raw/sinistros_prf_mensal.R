filepaths <- paste0(here("data-raw","datatran//"),
                        list.files(here("data-raw/datatran")))

read_accident <- function(paths) {
  prf <- lapply(
    paths,
    read_delim,
    delim = ";",
    locale = locale(decimal_mark = ",",
                    encoding = "latin1",
                    date_format = "%d/%m/%Y")
  )
  
  prf[[10]] <- prf[[10]] |> 
    mutate(data_inversa = dmy(data_inversa))
  
  prf <- reduce(
    lapply(prf, select, data_inversa, uf, causa_acidente, tipo_acidente, 
           classificacao_acidente, pessoas, mortos,feridos), 
    full_join
  ) |> 
    mutate(
      ano = year(data_inversa),
      mes = month(data_inversa),
      classificacao_acidente = case_when(
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos > 0 ~ "Com Vítimas Fatais",
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos == 0 & feridos > 0 ~ "Com Vítimas Feridas",
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos == 0 & feridos == 0 ~ "Sem Vítimas",
        TRUE ~ classificacao_acidente
      )
    ) |> 
    summarise(
      .by = c("mes","ano","uf"),
      acidentes = n(),
      acidentes_fatais = sum(classificacao_acidente == "Com Vítimas Fatais"),
      feridos = sum(feridos),
      mortes = sum(mortos)
    ) |> 
    arrange(ano, mes)
  
  return(prf)
}

sinistros_prf_mensal <- read_accident(filepaths)

save(sinistros_prf_mensal, file = "data/sinistros_prf_mensal.rda")