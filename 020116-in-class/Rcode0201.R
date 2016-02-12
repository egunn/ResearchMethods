# importing into R
# 1. create a data folder in your 
# http://www.ers.usda.gov/data-products/cotton,-wool,-and-textile-data/raw-fiber-equivalents-of-us-textile-trade-data.aspx

#read csv file
t <- read.csv("data/tex.csv")	# read comma separated file, store it in object t (data frame)

# read tab delimited file
# for example when you copy paste data from a spreadsheet into a text editor
t <- read.csv("data/tex.txt", sep="\t")

str(t)				# check data structure
head(t)				# show only first 6 rows
t[1:6,]				# same effect by calling a subset of the data, t[rows,columns]
t[c(1:3,7,9:10),]		# rows defined by a vector containing a list of numbers
somerows <- c(1:3,7,9:10) 	# create the same vector of numbers
t[somerows,]			# you can use object as argument

# calling columns by name
t[,"Time"]			# only call column with name "Time"
t[,"Cotton"]
t[,c("Cotton","Time")] 		# call columns specified in a vector of names

# copying and deleting
t2 <- t				# make a copy of t
t2$ctons <- t2$Cotton/1000	# copy column into new column, divided by 1000
t2$ctons <- NULL		# delete a column by overwriting it with NULL
rm(t2)				# delete an object (does not work with columns)

#conditions
t[t$Time>2000,]			# only load rows with Time > 2000
t[t$Time!=2000,]		

#statistics
plot(t)
plot(t[2:4])

# summaries: mean, median, range, quartiles
summary(t)    		# show summary statistic
summary(t$Silk)		# summary of only one column

# variance and standard deviation
var(t$Time) 		#variance, the average of the squared differences from the Mean
sd(t$Time)  		#standard deviation, the square root of the variance

# covariance and correlation
cov(t) 			# covariance measure of how much two random variables change together
cor(t) 			# lin. corr coeff. covariance divided by standard deviation (normalizes betweeen -1 and 1)

#another data set - the built in data from old faithful geyser
plot(faithful)
f <- faithful$eruptions 	# make a new object with only the eruptions column
f
summary(f)
plot(f)
hist(f)				# histogram
boxplot(f, horizontal = T) 	# interquartile range, median, whiskers

# for testing, we add an outlier in a new row - try other values, positive and negative, then go back to the boxplot
f[268] <- 7 		

var(f) 			# variance average of squared differences from the mean
sd(f) 			# standard deviation, sqroot of var, average distance from the mean

hist(f)

f <- faithful
plot(f)
cov(f) 			# covariance measure of how much two random variables change together 
cor(f) 			# lin. corr coeff. covariance divided by standard deviation (normalizes betweeen -1 and 1)

# back to our data set
cor(t)			# correlation matrix
library(corrgram)	# visualize correlation matrix as heatmap
corrgram(t)


# use ggplot
ggplot(t, aes(x=Time,y=Cotton)) + geom_point(color="red") + geom_line(alpha=0.3)

# easier to read
g <- ggplot(t, aes(x=Time,y=Cotton))
g + geom_line() + theme_minimal()


#advanced: reshaping - converting between wide and long data formats
install.packages("reshape")
library(reshape)

# load from xls file, third sheet
# notice that R added an X in front of column names, to make sure to not confuse column with a number
install.packages("xlsx")
library("xlsx")

t <- read.xlsx("data/texorig.xlsx", 3)

# melt the data: 
tm <- melt(t,id.vars = 1)
tm <- melt(t,id.vars = "material", measure.vars = 2:27, variable_name = "time") # more verbose version with the same result

# get rid of the X, by using a substring from the second to the fifth character. copy in new column
tm$time2 <- substr(tm$time,2,5)
# now we have to convert the character into a number
tm$time <- as.numeric(tm$time2)
tm$time2 <- NULL # delete our temporary column

head(tm)				# inspect our melted data set

tl <- cast(tm, time~material)		# cast the melted data set into long format ~ means "by" - time by material

write.csv(tl,"data/export.csv")
plot(tl)

# but the melted data set is also useful - introduce material column as group
ggplot(tm, aes(x=time,y=value, color=material)) + geom_line() 

# get rid of the Total group
ggplot(tm[tm$material!="Total",], aes(x=time,y=value, color=material)) + geom_line() + facet_wrap(~material) + theme_minimal()
