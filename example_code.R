library(dplyr)
library(tidyr)
library(lubridate)
library(readxl)
# source: National Highway Traffic Safety Administration (NHTSA) Motor Vehicle Crash Data Querying and Reporting
# The Yes no columns are recorded distracted driver indicators
crashes <- read_excel("CrashReport.xlsx", skip=6, guess_max = 3680)
#source: digitisation of article table image
top10 <- read_excel("top10.xlsx", skip=1)

clean_crash <- crashes |> 
  fill(...1, ...2, ...3) |> 
  mutate(date_is = ymd(paste(...1, ...2, ...3))) |> 
  filter(!is.na(date_is)) #gets rid of totals
clean_top10 <- top10 |> 
  mutate(date_is = mdy(`Date released`))

combo <- clean_crash |> 
  left_join(clean_top10, by="date_is")

distract <- combo |> 
  mutate(distract = Yes/Total)

library(ggplot2)
ggplot(distract, aes(x=date_is, y=distract)) +
  geom_point(size=.1) +
  theme_bw() + 
  geom_point(data=distract |> filter(!is.na(Album)), colour="red", size=2) +
  labs(title="Proportion of fatal US accidents involving distracted drivers",
       subtitle="album release dates in red")
ggsave(filename="ggsky.jpg", width=2016, height=1134, units="px")
