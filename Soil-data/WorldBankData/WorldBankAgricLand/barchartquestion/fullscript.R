getwd()
setwd("C:/Users/erica/Desktop/ResearchMethods/R-projects/Soil-data/WorldBankData/WorldBankLandArea")

#load files
landArea <- read.csv("WBLandArea_countries.csv", header = TRUE, sep=",")
agric <- read.csv("C:/Users/erica/Desktop/ResearchMethods/R-projects/Soil-data/WorldBankData/WorldBankAgricLand/WBAgricLand_countries.csv", header = TRUE, sep=",")

library(ggplot2)
library(reshape)
library(scales)


#trim to same size (ends on 2013)
agric <- agric[,1:59]

#create one dataframe, adding values for 2013 agric land use to the end of the landArea array 
combined<-landArea
combined$agric <-agric[,58]

#clean out extra years (use only 2013 data) 
combinedSmall <- combined
for (i in 57:2){
  combinedSmall[,i]<-NULL
}
combinedSmall[,3]<-NULL


#sort the countries by total land area (verified that this works)
combinedSorted<-combinedSmall[order(-combinedSmall$X2013),]    

#take the top 50
combinedTop50<-combinedSorted[1:50,]

#reorder the factors to link country names to land area values; otherwise defaults to alphabetical: https://kohske.wordpress.com/2010/12/29/faq-how-to-order-the-factor-variables-in-ggplot2/
combinedReordered <-reorder(combinedTop50$Country.Name,combinedTop50$X2013)

#save factors for plotting later
orderToPlot<-combinedReordered

#plot total land area to check data - verfied correct
ggplot(data=combinedTop50, aes(x=combinedReordered, y=combinedTop50$X2013)) +geom_bar(width=.75,stat="identity")+coord_flip()

#plot percent agric land for each country - verified correct
ggplot(data=combinedTop50, aes(x=combinedReordered, y=combinedTop50$agric)) +geom_bar(width=.75,stat="identity")+coord_flip()+labs(title="% agricultural land for 50 largest countries", x="Country", y = "% Agricultural Land")+scale_y_continuous(labels=comma)+ theme(axis.title.x = element_text(size=12),axis.title.y = element_text(size=12), axis.text.x = element_text(size =10), axis.text.y = element_text(size =7), plot.title=element_text(size=16))


#calculate the actual agric land area per country
absAgricAreaTop50 <- combinedTop50
absAgricAreaTop50$absAgricArea <- absAgricAreaTop50$X2013*absAgricAreaTop50$agric/100

#remove the percentage values from the array
absAgricAreaTop50$agric<-NULL

#Save data in a variable for plotting
toPlot<-absAgricAreaTop50

#rename columns to something more useful before melting
toPlot$landArea<-toPlot$X2013
toPlot$agricArea<-toPlot$absAgricArea
toPlot$X2013<-NULL
toPlot$absAgricArea<-NULL

#save order factor in a new column (otherwise, the factor variable will be the wrong length to use in aes after melting)
toPlot$factor[1:50] <- orderToPlot 

#melt into one column with two factors: landArea and agricArea
toPlotMelt<-melt(toPlot,id.vars=c("Country.Name", "factor"), measure.vars=2:3, variable_name = "Area", na.rm = FALSE)

#reorder melted array using factor column
toPlotReordered <-reorder(toPlotMelt$Country.Name,toPlotMelt$factor)

#plot total land area, with all countries in order (confirmed correct)
ggplot(data=toPlotMelt[1:50,], aes(x=toPlotReordered[1:50], y=toPlotMelt$value[1:50],fill=toPlotMelt$Area[1:50]))+geom_bar(width=.5,stat="identity")+coord_flip()+labs(title="Total and agricultural land area for 50 largest countries", x="Country", y = "Land area (sq. km)")+scale_y_continuous(labels=comma)+ theme(axis.title.x = element_text(size=12),axis.title.y = element_text(size=12), axis.text.x = element_text(size =10), axis.text.y = element_text(size =7), plot.title=element_text(size=16))+scale_fill_manual(values=c("#E69F00","#999999"), name="Land Type", breaks=c("X2013", "absAgricArea"),  labels=c("Agricultural", "Total"))

#plot agric land area, with all countries in order (confirmed correct)
ggplot(data=toPlotMelt[51:100,], aes(x=toPlotReordered[1:50], y=toPlotMelt$value[51:100],fill=toPlotMelt$Area[51:100]))+geom_bar(width=.5,stat="identity")+coord_flip()+labs(title="Total and agricultural land area for 50 largest countries", x="Country", y = "Land area (sq. km)")+scale_y_continuous(labels=comma)+ theme(axis.title.x = element_text(size=12),axis.title.y = element_text(size=12), axis.text.x = element_text(size =10), axis.text.y = element_text(size =7), plot.title=element_text(size=16))+scale_fill_manual(values=c("#E69F00","#999999"), name="Land Type", breaks=c("X2013", "absAgricArea"),  labels=c("Agricultural", "Total"))

#plot both variables together, with all countries in order 
ggplot(data=toPlotMelt, aes(x=toPlotReordered, y=toPlotMelt$value,fill=toPlotMelt$Area))+geom_bar(width=.5,stat="identity")+coord_flip()+labs(title="Total and agricultural land area for 50 largest countries", x="Country", y = "Land area (sq. km)")+scale_y_continuous(labels=comma)+ theme(axis.title.x = element_text(size=12),axis.title.y = element_text(size=12), axis.text.x = element_text(size =10), axis.text.y = element_text(size =7), plot.title=element_text(size=16))+scale_fill_manual(values=c("#E69F00","#999999"), name="Land Type", breaks=c("X2013", "absAgricArea"),  labels=c("Agricultural", "Total"))

