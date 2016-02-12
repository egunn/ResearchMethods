#load csv file from working directory
test <- read.csv("WBAgricLand.csv", header = TRUE, sep="\t")

##------------------------------------------------
##Try to make plot show up for data
##------------------------------------------------

str(test)
library(ggplot2)

testcut<-test[,6:58]

abw <- test[1,6:58]
abw2<-data.frame(abw)
years<-c(1961:2013)
#years2<-matrix(years,1,53)

is.list(abw2)
abw3<-unlist(abw2)
abw4<-data.frame(abw3)

ggplot(abw4, aes(x=years,y=abw4))+geom_point(color="blue")

help(ggplot)


length(abw2)
length(years)
help(plot)

abW5<-data.frame(test$Country.Name)

ggplot(abw4, aes(x=years,y=abw5))

###--------------------------------------

#works - plots two columns of test dataset
ggplot(test, aes(X1961,X1962))+geom_point(color="blue")

#looks like I may need to restructure the data into a 
#single column before I can use it. To do that, use melt.

#May also need to transpose?


library(reshape)
melted<-melt(test,id.vars="Country.Name", measure.vars=6:58, variable_name = "year")
ggplot(test, aes(X1961,X1962))+geom_point(color="blue")

help(melt)


#get rid of X, by using a substring of the 2nd-5th char of the time variable. Copy
melted$year2<-substr(melted$year,2,5)
#now convert the character into a number
melted$year <-as.numeric(melted$year2)
#and delete the temp column
melted$year2<-NULL

#tries to define color as "Aruba" etc
ggplot(melted, aes(x=year,y=value))+geom_point(color=melted$Country.Name)

#works, but plots all values, and all in blue
ggplot(melted, aes(x=year,y=value))+geom_point(color="blue")

#works, but still all blue
ggplot(melted, aes(x=year,y=value,group=Country.Name))+geom_point(color="blue")

#works! Lines plot all in black, though...
ggplot(melted, aes(x=year,y=value,group=Country.Name))+geom_line()

#can map color to year, but not to Country.Name
ggplot(melted, aes(x=year,y=value,group=Country.Name,color=year))+geom_line()

#back to little squares again...
ggplot(melted, aes(x=year,y=value,group=Country.Name,color=Country.Name))+geom_line()

melted$nameFactor<-factor(melted$Country.Name)
#try putting color inside line function instead
#no luck! line plots with black lines and dots...
ggplot(melted, aes(x=year,y=value,group=Country.Name,fill(Country.Name)))+geom_line()+geom_point()

#this gives different line colors, at least - just for links between points
c<-melted$value
ggplot(melted, aes(x=year,y=value,group=Country.Name,color(value)))+geom_line(color=c)+geom_point()

#lines were actually changing in the example w/ boxes above! 
#Needed to suppress legend (boxes) so that I could see them
ggplot(melted, aes(x=year,y=value,group=Country.Name,color=Country.Name))+geom_line()+theme(legend.position="none")



##------------------------------------------------
##Trim initial data to limit lines plotted
##------------------------------------------------

#want to see countries with biggest change in agric land
#(maybe top 10?) over period measured.
#Need to pre-filter data in test array before melting,
#use filtered/sorted data to create melt

country<-test$Country.Code
#find the max value for the country in the first row of test array (Aruba)
max(test[1,6:58],na.rm=TRUE)
min(test[1,6:58],na.rm=TRUE)

#debug for loop below
#check num rows correct (it is)
nrow(test)
#check that this gives a single row of test (it does)
test[248,]
#check that this calculates the max and min from the row (it does)
max(test[2,6:58],na.rm=TRUE)-min(test[2,6:58],na.rm=TRUE)
max(test[248,6:58],na.rm=TRUE)-min(test[248,6:58],na.rm=TRUE)
#set value of changeAg for that particular row (works)
test$changeAg[3]<-max(test[248,6:58],na.rm=TRUE)-min(test[248,6:58],na.rm=TRUE)

#do this for every row of the dataframe
for (i in 1:nrow(test)){
  test$changeAg[i]<-max(test[i,6:58],na.rm=TRUE)-min(test[i,6:58],na.rm=TRUE)
}

#check max value of changeAg column (seems reasonable)
max(test$changeAg)

sorted<-test[order(-test$changeAg),]  

topTen<-sorted[1:10,]

topTenMelt<-melt(topTen,id.vars="Country.Name", measure.vars=6:58, variable_name = "year")

#get rid of X, by using a substring of the 2nd-5th char of the time variable. Copy
topTenMelt$year2<-substr(topTenMelt$year,2,5)
#now convert the character into a number
topTenMelt$year <-as.numeric(topTenMelt$year2)
#and delete the temp column
topTenMelt$year2<-NULL

#plot top ten countries 
ggplot(topTenMelt, aes(x=year,y=value,group=Country.Name,color=Country.Name))+geom_line()
#+theme(legend.position="none")

##------------------------------------------------
##Plot delta as bar chart for each country
##------------------------------------------------

#this insists on giving me all the countries (and errors if I use [1:10] index in aes)
ggplot(data=sorted[1:10], aes(x=Country.Name, y=sorted$changeAg)) +
  geom_bar(stat="identity")

#redo topTenMelt, keeping the changeAg column
topTenMelt2<-melt(topTen,id.vars=c("Country.Name","changeAg"), measure.vars=6:59, variable_name = "year")

#get rid of X, by using a substring of the 2nd-5th char of the time variable. Copy
topTenMelt2$year2<-substr(topTenMelt2$year,2,5)
#now convert the character into a number
topTenMelt2$year <-as.numeric(topTenMelt2$year2)
#and delete the temp column
topTenMelt2$year2<-NULL

#prints out country names
topTenMelt$Country.Name

#insists on returning values of changeAg between 0 and 2050 
#doesn't make sense!!
ggplot(data=topTenMelt2, aes(x=Country.Name, y=topTenMelt2$changeAg)) +
  geom_bar(stat="identity")

#save separate variable to hold changeAg values
#returns error about numeric values, so add an as.numeric
#(Even though original variable claims to be num in inspector...)
yVar<-as.numeric(topTenMelt2$changeAg)

#still uses wrong values for y
ggplot(data=topTenMelt2, aes(x=Country.Name, y=yVar)) +
geom_bar(stat="identity")

#works with points...
ggplot(data=topTenMelt2, aes(x=Country.Name, y=yVar)) +
  geom_point(color="blue")

#returns an error: stat_count() must not be used with a y aesthetic 
ggplot(data=topTenMelt2, aes(x=Country.Name, y=yVar)) +
  geom_bar(color="blue")

#help file says that you need to use stat="identity" and
#map a y variable in the aesthetic in order for the 
#bars to represent a value in y rather than a count.
#There are no values in the yvar array bigger than 100,
#and yet this still returns values of more than 2000.
ggplot(data=topTenMelt2, aes(x=Country.Name, y=yVar)) +
  geom_bar(stat="identity")


#yVar is too long! Has 540 entries; we only need 10.
#tried to restrict to first 10 rows of topTenMelt - 
#returns error "incorrect # of dimensions"
yVar<-as.numeric(topTenMelt2$changeAg[1:10,])

#returns column of # 540s
topTenMelt2$changeAg

#it didn't like the comma. Only has one column...
topTenMelt2$changeAg[1:10]

#gives 10 values
yVar<-as.numeric(topTenMelt2$changeAg[1:10])

#doesn't work in plot, because not the same length as the dataframe
ggplot(data=topTenMelt2, aes(x=Country.Name, y=yVar)) +geom_bar(stat="identity")

#can't cut out the first 10 rows of the dataframe
#returns "Error in `[.data.frame`(topTenMelt2, 1:10) : undefined columns selected" 
ggplot(data=topTenMelt2[1:10], aes(x=Country.Name, y=yVar)) +geom_bar(stat="identity")

#needed a comma - topTenMelt2 has two dimensions.
topTenMelt2[1:10,]

#and now, finally, it works.
ggplot(data=topTenMelt2[1:10,], aes(x=Country.Name[1:10], y=yVar)) +geom_bar(stat="identity")


##------------------------------------------------
##Also tried
##------------------------------------------------

#cast into long form
long<-cast(melted,year~Country.Name)

ggplot(long, aes(x=year,y=value))

#can't melt by year, because not stored as an id variable in the test data structure
melted2<-melt(test,id.vars="year", measure.vars=6:58, variable_name = "name")
