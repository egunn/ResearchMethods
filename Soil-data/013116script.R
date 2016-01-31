#load csv file from working directory
test <- read.csv("NRCS_National_Hydric_Soils_List_2015.csv")

#list of variable names
str(test)

#tell R which libraries to use
library(ggplot2)
library(plotly)

#Use ggplot to plot the states and number of acres for each state
qplot(data=test,x=State,y=Component.Acres)

#plot number of acres against mukey value
qplot(data=test,x=Component.Acres, y=mukey)

#tried to implement aes to change size of marker based on mukey value, but returns errors. 
qplot(data=test,aes(x=State,y=Component.Acres,size=mukey))

#try same thing without using aes
qplot(data=test,x=State, y=Component.Acres, size=mukey)


#plot number of acres against mukey value
qplot(data=test,x=test[MA].Component.Acres, y=mukey)

#state abbrevs stored in test[1]
test[1]

subset <- test[1]="MA"
