# default R scatterplot matrix implementation using the Iris data set
pairs(iris)

# interactive javascript scatterplot matrix using the D3 library
#https://github.com/garthtarr/pairsD3/
install.packages("pairsD3")
require(pairsD3)
pd3 <- pairsD3(iris[,1:4],group=iris[,5])
savePairs(pd3, file = 'iris.html')

shinypairs(iris)

# scatterplot matrix using ggplot
install.packages("GGally")
require(GGally)
ggpairs(iris)

#tableplot
install.packages("tabplot")
library(tabplot)
tableplot(iris)
tableplot(iris,sortCol = "Species")

#corrgram
install.packages("corrgram")
library(corrgram)
corrgram(iris)

corrgram(iris, order=TRUE, lower.panel=panel.shade,upper.panel=panel.pie)
corrgram(iris, order=TRUE, lower.panel=panel.ellipse,upper.panel=panel.pts,diag.panel=panel.minmax)
corrgram(iris, order=NULL, lower.panel=panel.shade,upper.panel=NULL)
corrgram(iris, order=TRUE, lower.panel=panel.shade,upper.panel=panel.pie)

# hierarchies - treemaps
# create a treemap
#install.packages("treemap")
library(treemap)

data(GNI2010)
treemap(GNI2010,index=c("continent", "iso3"),vSize="population",vColor="GNI",type="value")