#import using GUI, turn off "Strings as factors"!!

rm(data)
rm(x)

library(ggplot2)


#set blanks and datafile n/a to NA
#worked with factored import, doesn't work with variable structure. Why??
data[data==""] <- NA
data[data=="n/a"] <- NA


ggplot(data, aes(x=data$v5,y=data$v7))

data$V9 <-NULL


year<-datatrimmed$V5
depth<-datatrimmed$V7
tillage<-datatrimmed$V2
SOC<-datatrimmed$V8

#use as.factor() to convert from numeric to categorical data!!
crop<-datatrimmed$V3
cropFact<-factor(crop)
cropFact[cropFact==""] <- NA
cropFact[cropFact=="n/a"] <- NA

#plot year vs. depth increment studied, use SOC to scale size of spots
ggplot(datatrimmed, aes(x=year,y=depth,color=crop))+geom_point(size=as.numeric(SOC))

#try to split plant categories to arrays      
datatrimmed$V3[125]
#cotton-corn
#use strsplit command to split the string at the desired character
test<-strsplit(datatrimmed$v3[125],"-")
#test "cotton" "corn"

#make a new column (duplicate of V3)
datatrimmed$crops <-datatrimmed$V3

#didn't work
for (i in nrow(datatrimmed$V3)){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}

#troubleshooting:works one at a time
datatrimmed$crops[125]<-strsplit(datatrimmed$V3[125],"-")

#returns 1949 (as expected)
nrow(datatrimmed)
  
#returns null
nrow(datatrimmed$V9)

#re-try with non-null index - still no
for (i in nrow(datatrimmed)){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}

#nope
for (i in 1949){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}

#no?!?
for (i in nrow(datatrimmed)){
  temp <-strsplit(datatrimmed$V3[i],"-")
  datatrimmed$crops[i]<-temp
}

#verify one at a time for 196,197 (note: some fields are comma separated; will need to address those separately)
datatrimmed$crops[197]<-strsplit(datatrimmed$V3[197],"-")

#ask it to report on what it's doing with i for each loop
#use cat() instead of print() to avoid getting a new line for each entry
for (i in 1949){
  cat(i)
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}
#outputs just 1949

#works!
#need a vector in the for loop, not just the maximum number
for (i in 1:1949){
  cat(i)
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}

#run again for comma delimited lists
for (i in 1:1949){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],",")
}

#and for /
for (i in 1:1949){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"/")
}

#some hyphens not getting caught - maybe a different character?
#print text from one of the examples, paste it into loop function
for (i in 1:1949){
  datatrimmed$crops[i]<-strsplit(datatrimmed$V3[i],"-")
}

#mostly resolved. Still some labels with / in the new vector versions

#try counting up the number of factors stored in the column
test<-factor(datatrimmed$crops)
#error in sort.list(y):'x'must be atomic for 'sort.list'
#? does this mean that I can't use factor because some of the data is stored as vectors?

#following an example in a comment thread on stackoverflow
#create a new column
datatrimmed$cropFactors <-datatrimmed$crops
#go through one element at a time, and convert to factor
#"The function [ applied to a data frame returns a data frame 
#(if only one argument is used). If you want to access a single 
#column and return it as a vector, you have to use [[ instead" 
for (i in 1:1949){
  datatrimmed$cropFact[i]<-factor(datatrimmed$V3[[i]])
}
#doesn't work - returns a value of 1 for all entries!

#http://www.stat.berkeley.edu/~s133/factors.html
#levels should tell you what factors are available for a dataset
levels(datatrimmed$V3[[i]])
#returns null

levels(datatrimmed$V3[i])
#returns null

#following this example
#http://gormanalysis.com/r-introduction-to-factors-tutorial/
#create a levels vector manually, and input it to factor() along with the data
levelVect<-c("corn","soybean","wheat","fallow",'hay',"sod","cotton","rye","initial","sorghum","oat","sunflower","virgin profile","barley","clover","timothy","cereals","continuous cereal","2 yr ley","4 yr crop","3 yr cereal","3 yr crop","4 yr ley")
#if this works, will want to consolidate categories before assigning levels!
for (i in 1:1949){
  datatrimmed$cropFact[i]<-factor(datatrimmed$V3[[i]],levelVect)
}
#worked for columns with a single value (not for vectors). 

#try treating as vectors (example used c)
for (i in 1:1949){
  datatrimmed$cropFact[i]<-factor(c(datatrimmed$V3[[i]]),c(levelVect))
}
#nope

#can I iterate through each element of the vector stored in the cell?
for (i in 1:1949){
  for (j in 1:length(datatrimmed$V3[[i]])){
      datatrimmed$cropFact[i]<-factor(datatrimmed$V3[[i]][[j]],levelVect)
 }
}
#nope

#try individually, with concrete example
datatrimmed$V3[[125]][[1]]
#?? returns "cotton-corn"! But viewer says that it's c("cotton","corn"),
#and I ran the previous loop on it to strsplit at the hyphen!

#similar result for 225 - did the for loop not work in the first place??

