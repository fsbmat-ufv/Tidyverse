rm(list = ls())
cat("\014")
library(tidyverse)
library(data.table)
df1 <- fread("dados/EmendasParlamentares.csv", encoding = "Latin-1")
# Função personalizada para aplicar rm_accent e toupper
padronizar_texto <- function(x) {
        if (is.character(x)) {
                x <- abjutils::rm_accent(x) # Remove acentos
                x <- toupper(x)             # Converte para caixa alta
        }
        return(x)
}

# Aplicar a função a todas as colunas usando mutate(across)
df1 <- df1 %>%
        mutate(across(everything(), padronizar_texto))

# Padronizar também os nomes das colunas
colnames(df1) <- colnames(df1) %>%
        abjutils::rm_accent() %>%     # Remove acento
        toupper()          # Coloca em caixa alta

dfMG <- df1 %>% filter(UF=="MINAS GERAIS")
dfMG1 <- dfMG %>% 
        group_by(MUNICIPIO, `NOME FUNCAO`) %>% 
        summarise("Empenhado"=sum(`VALOR EMPENHADO`),
                  "Liquidado"=sum(`VALOR LIQUIDADO`),
                  "Pago"=sum(`VALOR PAGO`), .groups = "drop")
