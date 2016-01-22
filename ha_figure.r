my_data <- read.csv("C:/Chicago_Grasslands/Manuscript/gbca_summary_area.csv")

library(ggplot2)
library(scales)

ggplot(data = my_data, aes(x = GBCA.Type, y = hectares)) +
  geom_bar(stat = "identity", position = "dodge", aes(fill = Status)) +
  labs(x="GBCA Type") +
  scale_fill_grey() +
  theme_bw() +
  scale_y_continuous(name="Area (ha)", labels = comma)
