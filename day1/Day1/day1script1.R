r <-rivers
r
plot(r)

hist(r)
str(r)

# this is a comment
iris
i <- iris
str(i)
head(i)
summary(i)
plot(i)

#accessing specific parts of the dataframe
#ea variable has $ name: i$SepalWidth  
hist(i$Sepal.Width)

# returns value in [row#, column#]
# can address variables by name, or by number in list. R starts with 1, not 0!
i[1,1]

#first row of all columns - leave columns unspecified
i[1,]

#statmethods.net - easy to use R manual (on BB)

#subset data to extract small arrays from data
#row 1-10
i[1:10,]
i[,2:3]
i1 <- i[3,2:3]

#install a package ggplot - use packages GUI, or import with
#install.packages("ggplot2")

#load for each script you want to use it in.
library(ggplot2)

#plot with ggplot - define variables to plot.
#ggplot based on grammar of graphics - maps data to visual variables
#systematic way of combining plot types.
qplot(data=i,x=Sepal.Width, y=Petal.Width)

qplot(data=i,x=Sepal.Width, y=Petal.Width, size=Sepal.Width)

#alpha for transparency; I means to treat 0.3 as a literal value, 
#not relative to something else. Can now see when things are on top of each other
#if you forget the I, it parses as a value and thinks it's a category of sorts
qplot(data=i,x=Sepal.Width, y=Petal.Width, size=Sepal.Width, alpha=I(0.3))

#understands that species value is categorical; uses non-hierarchical color scale automatically
qplot(data=i,x=Sepal.Width, y=Petal.Width, size=Sepal.Width, alpha=I(0.3), color=Species)

#qplot can get unwieldy
#call data, identify aesthetics. Don't need I here, but won't break if you add it.
#creates base layer of graphic; still need to specify geometry
#can save all of this as a new variable to reuse, and chain as in Javascript
#geometry uses the aesthetics to create a plot with a particular geometry
#geometry may require additional components - find them from documentation
#go through ggplot2 tutorial on BB "One hour intro"
#can use other features (facets) in addition to geometry to create other functions (small multiples
ggplot(data=i,aes(x=Sepal.Width, y=Petal.Width, size=Sepal.Width, alpha=0.3, color=Species))+geom_point()

ggplot(data=i,aes(x=Sepal.Width, y=Petal.Width, size=Sepal.Width, alpha=0.3, color=Species))+geom_point() +facet_wrap(~Species)

#another example - need to install library
#lots of different packages
#library(ggally)
#ggpairs(i)


#save a plot
p<-ggplot(data=i,aes(x=Sepal.Width, y=Petal.Width, size=Sepal.Width, alpha=0.3, color=Species))+geom_point()
library(plotly)
ggplotly(p)
#press button with website and arrow in viewer to see as webpage.

#shiny is an interface for building websites where you can control R from a website
