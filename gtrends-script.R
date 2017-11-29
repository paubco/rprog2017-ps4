library(gtrendsR)
library(ggplot2)
library(tidyverse)


bitcoin.trend <- gtrends(c("bitcoin"), gprop = "web", time = "all")[[1]]
class(bitcoin.trend)
head(bitcoin.trend)

#creating a data table based on the data on google trends

class(bitcoin.trend$date)

#this actually tells us what cass date is

ggplot(data = bitcoin.trend) + geom_line(mapping = aes(x= date, y = hits))

#plotting the bitcoin trend on tme

bitcoin.trend <- bitcoin.trend %>% filter(date >= as.Date("2009-01-01"))
ggplot(data = bitcoin.trend) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red") #trump inauguration
  
#this is plotting a line to indicate the break point from trump's election

library(Quandl)
bitcoin.price <- Quandl("BCHARTS/BITSTAMPUSD")
bitcoin.price <- bitcoin.price %>% filter(Date %in% bitcoin.trend$date) %>% select(Date, Close) %>% rename(date = Date, price = Close) %>% mutate(price = price*100/max(price))

bitcoin <- left_join(x = bitcoin.trend, y= bitcoin.price, by = "date")
head(bitcoin)

ggplot(data = bitcoin) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_line(mapping = aes(x= date, y = price), color = "gray") + 
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red")

