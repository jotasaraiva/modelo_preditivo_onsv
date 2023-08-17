datatran_extract <- function(df) {
  
  acidentes <- df |> 
    select(
      data_inversa,
      mortos,
      feridos,
      classificacao_acidente
    ) |> 
    mutate(
      
      ano = case_when(
        is.character(data_inversa) ~ year(dmy(data_inversa)),
        !is.character(data_inversa) ~ year(data_inversa)
      ),
      
      classificacao_acidente = case_when(
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos > 0 ~ "Com Vítimas Fatais",
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos == 0 & feridos > 0 ~ "Com Vítimas Feridas",
        classificacao_acidente %in% c("(null)","Ignorado",NA) & mortos == 0 & feridos == 0 ~ "Sem Vítimas",
        TRUE ~ classificacao_acidente
      )
    )
  
  mortes <- acidentes |> 
    group_by(ano) |> 
    summarise(
      qnt_acidentes = n(),
      qnt_acidentes_fatais = sum(classificacao_acidente == "Com Vítimas Fatais"),
      qnt_feridos = sum(feridos),
      qnt_mortos = sum(mortos)
    )
  
  return(mortes)
  
}

arrange_datatran <- function() {
  k <- seq(2007, 2021, 1)
  enderecos_datatran <- paste(
    "data-raw/datatran/datatran",
    k,
    ".csv",
    sep = ""
  )
  #criação de loop para a importação de todos os anos
  for (i in enderecos_datatran) {
    df_temp <- read_csv2(i, locale = locale(encoding = "latin1")) |>
      datatran_extract()
    if (exists("datatran_anos")) {
      datatran_anos <- bind_rows(datatran_anos, df_temp)
    } else {
      datatran_anos <- df_temp
    }
  }
  return(datatran_anos)
}

sinistros_prf <- arrange_datatran()
save(sinistros_prf, file = "data/sinistros_prf.rda")