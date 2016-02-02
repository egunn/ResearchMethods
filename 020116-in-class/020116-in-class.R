#\t is tab key using regular expressions - reads the comma separated file
t <-read.csv("data/tex.txt",sep="\t")

#could also use 
t<-read.csv("data/text.csv")

#can't use numbers for variable names! Will put an X in front of it
# x = "123"  (saves as str)
# as.numeric(x) will be 123


str(t) #look at data structure
head(t)  #show 1st 6 rows
t[1:6,]  #rows 1-6, all columns
t[c(1:3,7,9:10)]  #rows defined by a vector containing a list of numbers
#c indicates that the following is a vector
somerows <- c(1:3,7,9:10)  #create same vector of numbers
somerows[3] #returns the value in the third position
t[somerows,] #you can use object as an argument

c(1,2,3)
c(1,2,c(1,2,3))  #concatenates the two arrays into one


#call columns by name
t[,"Time"]  #only call column with name "Time"
t[,c("Cotton","Time")]  #call columns specified in a vector of names

#copying and deleting
t2 <- t  #make a copy of t

#t is a dataframe - like a table, but can be nested at multiple levels 
#and mapped to other data structures directly "object oriented nested data structure"

#$ is used to designate the beginning of a column
t2$ctons <- t2$Cotton/1000  #copy column into a new column, and divide by 1000
t2$ctons <- NULL   #delete a column by overwriting it with null values
rm(t2)  #removes an object (does not work with columns)

t2$new <- 5  #create a new column filled with 5s

#conditions
t[t$Time>2000,]   #only load rows with time >2000 (just printing to console)
t[t$Time!=2000,]  #all rows except those with 2000

#statistics
plot(t)   #small multiples correlation plot of all variables
plot(t[2:4])  #small multiples of rows 2:4

#statmethods.net - good online resource/documentation

#summaries: mean(average), median (middle number in range), range, quartiles(first quarter of data)
summary(t)  #show summary statistic
summary(t$Silk)  #summary of only one column

#variance and standard deviation
var(t$Cotton)  #variance is the averages of the squared differences from the mean (how far from the average, square to get positive #s)
sd(t$Cotton)   #standard deviation, the square root of the variance (square root of the variance - ~distance from average)
                #answers: how dispersed is the data?

#covariance and correlation
cov(t)  #two variables- how much do the two change together?
cor(t)  #lin. corr. coeff. - covariance divided by std dev. (normalized using st dev to be between -1 and 1)

#look at OldFaithful dataset
plot(faithful)
f<-faithful$eruptions  #make a new object with only the eruptions column
f
summary(f)
plot(f)
hist(f)   #draw histogram
boxplot(f,horizontal=T)  #interquartile range, median, whiskers
#median is dark line, 
#box defines 1st and 3rd quartile of data (contains exactly 1/2 of data), 
#whiskers show max/min of data, can only be 1.5x the length of the box

#for testing, add a new outlier 
f[268] <-10
boxplot(f,horizontal=T)

var(f)  #variance avg squared diff. from mean
sd(f)  #std dev sq rt of var, average distance from the mean


hist(f)
x<-boxplot(f,horizontal=T)  #assign plot values to a variable
x  #output to console, to see statistical summaries

data()  #lists all built-in datasets

#use ggplot
library(ggplot2)
#aes maps variables to colors, etc.
#adding a point layer with geom_point and a line layer using geom_line
ggplot(t,aes(x=Time,y=Cotton))+geom_point(color="red")+geom_line(alpha=0.3)

#easier to read
g<- ggplot(t,aes(x=Time,y=Cotton))
g + geom_line() +theme_minimal()


library(reshape)
library(xlsx)

#advanced: reshaping: convert between wide and long datasets
#load from xls file, third sheet
#adds X in front of columns names to make sure not to confuse
#give filename, sheetnumber
t<-read.xlsx("data/texorig.xlsx",3)

#"melt" the data to put all columns into one column of data
tm<-melt(t,id.vars=1) #can do with multiple variables using  melt(t,id.vars=1:3)
tm<-melt(t,id.vars="material", measure.vars=2:27, variable_name = "time")
#specify material as id variables

#get rid of X, by using a substring of the 2nd-5th char of the time variable. Copy
tm$time2<-substr(tm$time,2,5)
#now convert the character into a number
tm$time <-as.numeric(tm$time2)
#and delete the temp column
tm$time2<-NULL

#qplot is a shorthand for ggplot - use long form when debugging, 
#since it's more robust. Errors in homework code likely because of qplot
ggplot(tm, aes(x=time,y=value,color=material))+geom_line()

#get rid of the "total" group
#check his notes for more complex series of changes!
ggplot(tm[tm$material!="Total",], aes(x=time,y=value,color=material))+geom_line()

#if the date is in numeric format, then you get an error saying 
#"do you need to adjust the group aesthetic?"
#can only do a line chart with a var recognized as a series - use as numeric to convert to nums

tl<-cast(tm,time~material)  #cast the melted data into long format ~ means "group by"

write.csv(tl,"data/export.csv")
plot(tl)
