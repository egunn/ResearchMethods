#
# basic plot types 
# check http://www.statmethods.net/graphs/creating.html
# we will work with the built in EPA fuel economy dataset
#

# print the whole dataset
mpg
# print a single column cyl
mpg$cyl
# print the first few lines
head(mpg)
# information about the data set
help(mpg)
# data structure
str(mpg)
# summary statistics
summary(mpg)	
# print row names of the data frame (by default numbers, but can be arbitrary string)
row.names(mpg)

# plot displacement vs. miles per gallon on highway
plot(data=mpg, displ~cty)
# same result (except axis titles)
plot(mpg$cty,mpg$displ)

# use a different point symbol (can be 1-25), color ... 
plot(data=mpg, displ~cty, pch=3)

# list all default graphical parameters
# check http://www.statmethods.net/advgraphs/parameters.html
par()
# modify a few parameters
plot(data=mpg, displ~cty, pch=21, col='red', bg='yellow', cex=2, lwd=0.5 )
plot(data=mpg, displ~cty)
     
# fuel efficiency by car class
# note that plot function automatically selects bar charts due to categorical x variable
plot(data=mpg, hwy~class)

# mosaicplot
mosaicplot(data=mpg, class~drv, color=TRUE)

# linechart
plot(data=economics, unemploy~date, type='l', ylab="Unemployment", xlab="Year")

#
# now the same with the ggplot2 library 
# check http://docs.ggplot2.org
#

ggplot(data=mpg, aes(displ,cty)) + geom_point(alpha=0.2, size=5)

# boxplot, two syntax versions
ggplot(mpg,aes(class,hwy)) + geom_boxplot()

# use color, categorical var
ggplot(mpg,aes(displ,cty, color=class)) + geom_point(size=5) 

# use color, continuous var
ggplot(mpg,aes(hwy,cty, color=displ)) + geom_point(size=5) 

# use shape, categorical var.
ggplot(mpg,aes(displ,cty, shape=drv)) + geom_point(alpha= 0.5,size=3) 


# plots with categorical variables
# bar chart with filled area
ggplot(mpg,aes(class,fill=drv)) + geom_bar() 
# 2d histogram
ggplot(mpg,aes(class,drv)) + stat_bin_2d() + coord_equal() 


# linecharts
ggplot(economics,aes(x=date,y=unemploy/pop)) +geom_line() + ylab("Unemployment rate")
