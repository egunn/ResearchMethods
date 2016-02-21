getwd()
setwd("C:/Users/erica/Desktop/ResearchMethods/R-projects/Soil-data/WorldBankData/WorldBankLandArea")
#load csv file from working directory
#use sep="/t" for tab delimited files
test <- read.csv("WBLandArea_countries.csv", header = TRUE, sep=",")

#data file sorted alphabetically, even though the original file is sorted by value.

##------------------------------------------------
##Try to make plot show up for data
##------------------------------------------------

str(test)
library(ggplot2)
library(reshape)
library(scales)

#trim off identifying columns - leaves just data!
#testcut<-test[,6:59]
rm(testcut)

#create a years array from 1961-2014 to match column headers
years<-c(1961:2014)

#works - plots two columns of test dataset
ggplot(test, aes(X1961,X1962))+geom_point(color="blue")

#looks like I may need to restructure the data into a 
#single column before I can use it. To do that, use melt.
melted<-melt(test,id.vars="Country.Name", measure.vars=6:59, variable_name = "year")
ggplot(test, aes(X1961,X1962))+geom_point(color="blue")

#get rid of X in year column, by using a substring of the 2nd-5th char of the time variable. Copy
melted$year2<-substr(melted$year,2,5)
#now convert the character into a number
melted$year <-as.numeric(melted$year2)
#and delete the temp column
melted$year2<-NULL

#no longer need years
rm(years)

#lines were actually changing in the example w/ boxes above! 
#Needed to suppress legend (boxes) so that I could see them
ggplot(melted, aes(x=year,y=value,group=Country.Name,color=Country.Name))+geom_line()+theme(legend.position="none")

##------------------------------------------------
##Trim initial data to limit lines plotted
##------------------------------------------------

#Look at top 50 countries
#Need to pre-filter data in test array before melting,
#use filtered/sorted data to create melt

# varToSort[order(-varToSortBy),]
#neg means sort in descending order
sorted<-test[order(-test$X2014),]    

top50<-sorted[1:50,]

top50Melt<-melt(top50,id.vars="Country.Name", measure.vars=6:59, variable_name = "year")

#get rid of X, by using a substring of the 2nd-5th char of the time variable. Copy
top50Melt$year2<-substr(top50Melt$year,2,5)
#now convert the character into a number
top50Melt$year <-as.numeric(top50Melt$year2)
#and delete the temp column
top50Melt$year2<-NULL

#plot land area of top fifty countries as line graph
ggplot(top50Melt, aes(x=year,y=value,group=Country.Name,color=Country.Name))+geom_line()+theme(legend.position="none")

#plot land area bar charts for...1961? Why not in order??
ggplot(data=top50Melt[1:50,], aes(x=Country.Name[1:50], y=value[1:50])) +geom_bar(stat="identity")

top50Melt$value[2651:2700]

#still not in order, but I think this is the right year
#without the top50melt$ in the aes factors, get error:'data' must be of a vector type, was 'NULL'
ggplot(data=top50Melt[2651:2700,], aes(x=top50Melt$Country.Name[2651:2700], y=top50Melt$value[2651:2700])) +geom_bar(stat="identity")

top50in2014<-top50Melt[2651:2700,]

#need to reorder the factors; otherwise defaults to alphabetical: https://kohske.wordpress.com/2010/12/29/faq-how-to-order-the-factor-variables-in-ggplot2/
reordered <-reorder(top50in2014$Country.Name,top50in2014$value)

#plot again using reordered factors for x (coord flip rotates plot sideways)
#Load scales library, then scale y (horizontal, because rotated) to get non-scientific notation
#use theme to change size of axis and tick mark labels
ggplot(data=top50in2014, aes(x=reordered, y=top50in2014$value)) +
  geom_bar(width=.75,stat="identity")+coord_flip()+
  labs(title="Countries with largest land area", x="Country", y = "Land area (sq. km)")+
  scale_y_continuous(labels=comma)+ 
  theme(axis.title.x = element_text(size=16),axis.title.y = element_text(size=16), axis.text.x = element_text(size =10), axis.text.y = element_text(size =7))
