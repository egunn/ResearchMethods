# load a csv file and store it into a new object "earthquakes"
eq <- read.csv(file = "data/earthquake.csv")

eq
head(eq)
summary(eq)
str(eq)

library(ggplot2)

p <- ggplot(data = eq) + 
  geom_point(aes(x=longitude,y=latitude, size=mag, color=magType), alpha = 0.7) +
  coord_fixed() + 
  ggtitle("Earthquakes")
p
# save our plot as pdf
ggsave("out/earthquakes.pdf")

#plotly https://plot.ly/r/
library(plotly)
ggplotly(p)

# import JSON files
# install the package (if you have not done so yet)
install.packages("jsonlite")
library(jsonlite)

# load weather data file
weather <- fromJSON("data/weather_simple.json")
str(weather)
summary(weather)

ggplot(data=weather) +
  geom_point(aes(x=date, y=temp/10)) + 
  geom_point(aes(x=date, y=temp_min/10), color="grey") + 
  geom_point(aes(x=date, y=temp_max/10), color="grey") + 
  ggtitle("Temperature Min Max in Celsius")


#
rivers
r <- rivers
plot(r)
hist(r)
summary(r)

iris
diamonds


i <- iris

str(i)
head(i)
plot(i)
summary(i)

hist(i$Sepal.Length)

# navigating the data set
# dataset[row,column]
# row 1-5, all columns (in R, counting starts at 1)
i[1:5,]

#column 2-3, all rows
i[,2:3]

#access column by name
i$Sepal.Length

# GGally
install.packages("GGally")
library(GGally)
ggpairs(i)

#ggvis http://ggvis.rstudio.com/
install.packages("ggvis")
library(ggvis)
ggvis(i, x=~Sepal.Length, y=~Sepal.Width, size=~Petal.Length, fill=~Petal.Width)

#plotly https://plot.ly/r/
library(plotly)
p <- qplot(data=i, x=Sepal.Length, y=Sepal.Width, size=Petal.Length, color=Petal.Width) + facet_wrap(~ Species) 
p
ggplotly(p)

#googlevis https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html 
install.packages("googleVis")
library(googleVis)
b <- gvisBubbleChart(i, idvar="Species", xvar="Sepal.Length", yvar="Sepal.Width", sizevar="Petal.Length", colorvar="Petal.Width") 
plot(b)

#rcharts http://rcharts.io/ 
library(rCharts)
r <- rPlot(data=i,Sepal.Length~Sepal.Width, color = 'species', type = 'point')
r$print("chart1")
