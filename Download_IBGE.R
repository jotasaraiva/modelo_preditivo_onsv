library(tidyverse)

anos <- seq(2006,2021,1)

download_datasus_ibge <- function(intervalo){
  
  intervalo <- intervalo |> as.character() |> str_sub(3,4)
  
  for(i in intervalo){
    print(i)
  }
}

download_datasus_ibge(anos)
