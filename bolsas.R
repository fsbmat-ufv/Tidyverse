rm(list=ls())
cat("\014")
library(tidyverse)
library(data.table)
library(htmlTable)
library(DT)
library(scales)
df1 <- fread("dados/202101_BolsaFamilia_Pagamentos.csv", encoding = "Latin-1")
names(df1) <- c("MESCompetencia",
                "MESReferencia",
                "UF",
                "CodSIAFI",
                "MUN",
                "CPF",
                "NIS",
                "Nome",
                "Valor")
df1 <- df1 %>% filter(MUN %in% c("COIMBRA", 
                              "TEIXEIRAS", 
                              "VICOSA")) %>% filter(UF=="MG")
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


tb1 <- df1 %>% 
        group_by(MUN) %>% 
        summarise("Total"=sum(VALOR),
                  .groups = 'drop') 
tb1$Total <- dollar(tb1$Total, prefix = "R$", big.mark = ".", decimal.mark = ",")
# Gerar a tabela SEM numeração de linha
htmlTable(tb1,
          header = c("Município", "Total"), # Define os cabeçalhos explicitamente
          rnames = FALSE                    # ESSA é a chave para não imprimir a numeração!
)

tb2 <- df1 %>% 
        group_by(MUN) %>% 
        summarise("Minimo"=min(VALOR),
                  .groups = 'drop') 
tb2$Minimo <- dollar(tb2$Minimo, prefix = "R$", big.mark = ".", decimal.mark = ",")
# Gerar a tabela SEM numeração de linha
htmlTable(tb2,
          header = c("Município", "Minimo"), # Define os cabeçalhos explicitamente
          rnames = FALSE                    # ESSA é a chave para não imprimir a numeração!
)

tb3 <- df1 %>% 
        group_by(MUN) %>% 
        summarise("Maximo"=max(VALOR),
                  .groups = 'drop') 
tb3$Maximo <- dollar(tb3$Maximo, prefix = "R$", big.mark = ".", decimal.mark = ",")
# Gerar a tabela SEM numeração de linha
htmlTable(tb3,
          header = c("Município", "Maximo"), # Define os cabeçalhos explicitamente
          rnames = FALSE                    # ESSA é a chave para não imprimir a numeração!
)

Coimbra <- df1 %>% filter(MUN == "COIMBRA") %>% arrange(desc(VALOR))
Vicosa <- df1 %>% filter(MUN == "VICOSA") %>% arrange(desc(VALOR))
Teixeiras <- df1 %>% filter(MUN == "TEIXEIRAS") %>% arrange(desc(VALOR))
saveRDS(Coimbra, "Coimbra.Rds")
