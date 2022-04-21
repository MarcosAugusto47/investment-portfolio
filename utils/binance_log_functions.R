string_to_numeric = function(x){
  x = gsub("[^0-9\\.]", "", x)
  x = x %>% as.numeric()
  return(x)
}

binance_extract_treatment = function(df){
  colnames(df) = c("date", "order_number", "pair", "type", "side", "order_price", "order_amount",
                   "time", "executed", "average_price", "trading_total", "status")
  df$nominator = gsub("[^A-Z]", "", df$order_amount)
  df$denominator = gsub("[^A-Z]", "", df$trading_total)
  df$order_amount = string_to_numeric(df$order_amount)
  df$order_price = string_to_numeric(df$order_price)
  df$executed = string_to_numeric(df$executed)
  df$average_price = string_to_numeric(df$average_price)
  df %>% 
    mutate(date = as.Date(date)) %>% 
    select(-c("pair", "order_number", "time","trading_total"))
}