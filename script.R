library(dplyr)
library(tidyr)
library(readxl)
source("utils/functions.R")
df = read_xls("data/InfoCEI-01_04_2021.xls")
columns = c("periodo",
            "c_v",
            "mercado",
            "codigo",
            "especificacao",
            "quantidade",
            "preco",
            "valor_total")
numeric_columns = c("quantidade", "preco", "valor_total")
df = formatting(df, columns, numeric_columns)
df_buys = buys_data_treatment(df)
df_pivot = compute_position(df)
df = data_join(df_buys, df_pivot)

##### stock events
df_events = read_excel("data/stock_events.xlsx")
df = join_stock_events(df, df_events)
df = update_positions(df)
#####

df2 = read_xls("data/InfoCEI-01_04_2021-14_04_2022.xls")
df2 = formatting(df2, columns, numeric_columns)
df_buys = buys_data_treatment(df2)
df_pivot = compute_position(df2)
df2 = data_join(df_buys, df_pivot)

df_final = final_join(df, df2)

