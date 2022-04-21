library(dplyr)
library(tidyr)
library(readxl)
source("utils/log_functions.R")
columns = c("periodo",
            "c_v",
            "mercado",
            "codigo",
            "especificacao",
            "quantidade",
            "preco",
            "valor_total")
numeric_columns = c("quantidade", "preco", "valor_total")
df = read_xls("data/bronze/B3/InfoCEI-01_04_2021.xls")
df = formatting(df, columns, numeric_columns)
df2 = read_xls("data/bronze/B3/InfoCEI-01_04_2021-14_04_2022.xls")
df2 = formatting(df2, columns, numeric_columns)
df = rbind(df, df2)
df_events = read_excel("data/bronze/B3/stock_events.xlsx")
df_events = stock_events_treatment(df_events)
df_log = create_log(df, df_events)
write.csv(df_log, "data/silver/B3_log.csv", row.names = FALSE)
