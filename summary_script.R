library(dplyr)
library(tidyr)
library(readxl)
source("utils/summary_functions.R")
# B3
df = read.csv("data/silver/B3_log.csv")
df_buys = buys_data_treatment(df)
df_pivot = compute_position(df)
df_final = data_join(df_buys, df_pivot)

# passfolio
df = read.csv("data/silver/passfolio_log.csv")
df_passfolio = df %>%
  group_by(symbol) %>% 
  summarise(total_quantity = sum(filledQuantity),
            total_amount = sum(amount)) %>% 
  mutate(average_price = total_amount/total_quantity)

# binance
df = read.csv("data/silver/binance_log.csv")
df %>%
  filter(status == "FILLED") %>% 
  mutate(amount_BRL = executed*average_price) %>% 
  group_by(nominator) %>% 
  summarise(sum_executed = sum(executed),
            sum_amount_BRL = sum(amount_BRL)) %>% 
  mutate(average_price = sum_amount_BRL/sum_executed)

write.csv(df_final, "data/gold/B3_summary.csv", row.names=FALSE)
write.csv(df_passfolio, "data/gold/passfolio_summary.csv", row.names=FALSE)

