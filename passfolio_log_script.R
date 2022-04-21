library(dplyr)
library(tidyr)
library(readxl)
library(stringr)
df = read.csv("data/bronze/passfolio/orders.csv")
df2 = read.csv("data/bronze/passfolio/transfers.csv")

df = df %>% 
  mutate(date = as.Date(enteredAt)) %>% 
  select(date, status, side, type, symbol, filledQuantity, amount, price, feesUSD)

df2 = df2 %>% 
  mutate(date = as.Date(receivedAt)) %>% 
  select(date, status, sourceAmount, sourceCurrency, destinationCurrency, exchangeRate, feesBRL, feesUSD)

add_exchange_rate = function(df, df_exchange){
  df$exchangeRate = NA
  
  for (i in 1:nrow(df)){
    pick_rate = df2 %>%
               filter(date <= df$date[i]) %>% 
               filter(date == max(date)) %>% 
               select(exchangeRate)
    df$exchangeRate[i] = pick_rate
  }
  df = df %>% mutate(exchangeRate = as.numeric(exchangeRate))
  return(df)
}

df = add_exchange_rate(df, df2)

write.csv(df, "data/silver/passfolio_log.csv", row.names = FALSE)
