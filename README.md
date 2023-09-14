# Modelo Preditivo de Mortes Viárias Anuais

- [Objetivo](#objetivo)
- [Método](#método)
- [Estrutura dos Arquivos](#estrutura-dos-arquivos)
- [Principais resultados](#principais-resultados)

## Objetivo

Este projeto é um modelo baseado em dados viários para previsão de
mortes relacionadas à segurança viária e veicular no Brasil com uma
resolução temporal anual, confeccionado a fim de gerar um estudo
científico para o Observatório Nacional de Segurança Viária (ONSV).

## Método

Os dados brutos e *scripts* de tratamento se encontram em `data-raw/`,
utilizados para extração de dados tratados encontrados em `data/`.

|  ano | automovel | motocicleta | veiculos_total | mortes |     pib | populacao | qnt_acidentes | qnt_acidentes_fatais | qnt_feridos | qnt_mortos | condutores | quilometragem_10_bilhoes | mortos_por_pop |
|-----:|----------:|------------:|---------------:|-------:|--------:|----------:|--------------:|---------------------:|------------:|-----------:|-----------:|-------------------------:|---------------:|
| 2011 |  45513632 |    17566802 |       68024871 |  43256 | 4376382 | 192379287 |        192326 |                 7158 |      106827 |       8675 |   53885601 |                 83.05893 |       22.48475 |
| 2012 |  48973903 |    19412783 |       73699403 |  44812 | 4814760 | 193976530 |        184568 |                 7003 |      104468 |       8663 |   56749646 |                 89.91420 |       23.10176 |
| 2013 |  52638712 |    20942530 |       79261065 |  42266 | 5331619 | 201062789 |        186748 |                 6887 |      103810 |       8426 |   59604073 |                104.27821 |       21.02129 |
| 2014 |  56028615 |    22412117 |       84494118 |  43780 | 5778953 | 202799518 |        169201 |                 6742 |      100832 |       8234 |   62658577 |                 97.66260 |       21.58782 |
| 2015 |  58972258 |    23750523 |       89080562 |  38651 | 5995787 | 204482459 |        122161 |                 5648 |       90251 |       6867 |   65316146 |                 99.35574 |       18.90187 |
| 2016 |  61079077 |    24898477 |       92553570 |  37345 | 6269328 | 206114067 |         96363 |                 5355 |       86672 |       6398 |   67629344 |                106.18009 |       18.11861 |
| 2017 |  63106809 |    25772008 |       95643467 |  35375 | 6585480 | 207660929 |         89567 |                 5184 |       84320 |       6248 |   69729348 |                 99.83830 |       17.03498 |
| 2018 |  65440975 |    26658933 |       99090731 |  32655 | 7004141 | 208494900 |         69332 |                 4507 |       76695 |       5273 |   71787294 |                 98.93043 |       15.66225 |
| 2019 |  68048424 |    27685249 |      103016009 |  31945 | 7389131 | 210147125 |         67556 |                 4597 |       79191 |       5338 |   73844088 |                105.92725 |       15.20125 |
| 2020 |  70144529 |    28576665 |      106289700 |  32716 | 7609597 | 211755692 |         63576 |                 4525 |       71511 |       5293 |   75028871 |                 98.72076 |       15.44988 |
| 2021 |  72331723 |    29684894 |      109961381 |  33813 | 8898727 | 213317639 |         64539 |                 4664 |       71846 |       5396 |   77122865 |                110.15627 |       15.85101 |

O modelo ajustado é uma regressão linear multivariada, construída após
um processo de seleção de atributos manual:

As funções para o modelo criado se encontram em `R/main.R`, onde
demonstram a previsão para 2022. Para futuras previsões, basta imputar
novos dados ao *dataset* de entrada e chamar o modelo com `lm_model()` e
`lm_extract()`.

## Estrutura dos Arquivos

- `report/` contém relatórios sobre o processo de criação do modelo
- `data-raw/` possui dados brutos e scripts de extração deles
- `data/` possui os dados tratados utilizados no modelo
- `R/` possui o modelo e as funções criadas para previsão

## Principais resultados

O modelo contemplou um intervalo de dez anos (2011 à 2021) e foi testado
com os dados de 2022. Avaliando as métricas com o pacote `yardstick`,
têm-se:

| metricas |     valores |
|:---------|------------:|
| rmse     | 687.6800884 |
| mae      | 607.8646399 |
| rsq      |   0.9786708 |

Seus coeficientes podem ser observados:

| variavel             |      valor |    pvalor |
|:---------------------|-----------:|----------:|
| (Intercept)          |  37874.000 | 0.0000000 |
| qnt_acidentes        |  -4689.250 | 0.2372921 |
| qnt_acidentes_fatais |   8158.733 | 0.0433187 |
| condutores           | -15133.569 | 0.2292492 |
| veiculos_total       |  13851.817 | 0.2157495 |
