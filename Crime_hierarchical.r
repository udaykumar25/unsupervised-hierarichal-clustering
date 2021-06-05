## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#                       the data is all about different crimes percentage in various states.


library(readr)
#import data
df<-read.csv("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\crime_data.csv")

attach(df) #this command is used to attach dataframe so that there need not to use $ for every operation further.

# Remove categorical variables
df1 <- subset(df, select = -c(state))

##### exploratory data analysis ######
str(df1) #to see strcture of data
View(df1) # to view the data in new tab
summary(df1) # gets the summary of data like mean, median, max, min, etc..,

sapply(df1, var) # variance data
sapply(df1,sd)# standarad deviation of data
# expect "number of complants" all numeric columns as to be normalize.


#checking data by calucalating skews and kurtosis.

library("UsingR") #library to plot histogram
library("moments") # libraryto plot densityplot

skewness(Murder)#skewness=0.382 #positive skew
hist(Murder)##data are not normally distributed
densityplot(Murder)##data are not normally distributed

skewness(Assault)#skewness=0.227 #positive skew
hist(Assault)##data are not normally distributed
densityplot(Assault)##data are not normally distributed

skewness(UrbanPop)#skewness=-0.219 #positive skew
hist(UrbanPop)##data are not normally distributed
densityplot(UrbanPop)##data are not normally distributed

skewness(Rape)#skewness=0.776 #positive skew
hist(Rape)##data are not normally distributed
densityplot(Rape)##data are not normally distributed


kurtosis(Murder)#kurtosisness= 2.135 <3
kurtosis(Assault)#kurtosisness= 1.9309 <3
kurtosis(UrbanPop)#kurtosisness= 2.215 <3
kurtosis(Rape)#kurtosisness= 3.201 >3


########  Data processing  ######

#####MissingValues#####

summary(df)
sum(is.na(df)) #no missing values in data

####Duplication_Typecasting#####
#Identify duplicates records in the data
dup <- duplicated(df)
dup
length(which(dup==TRUE))#no duplicate values

####Outlier_Treatment#######

boxplot(Murder) #outliers found
boxplot(Assault) #no outliers
boxplot(UrbanPop) #outliers found
boxplot(Rape) # no outliers

#the outliers seen in the plots are acceptable because data itself in that way so we cannot consider then has outliers.
#no outlier treatment required.


#####  scale or standardisation  ####

#df_norm<-as.data.frame(scale(df_numeric))

##custom normalization
common<-function(i){
  x=(i-min(i))/(max(i)-min(i))
  return(x)
}
df_final=common(df1)

sapply(df_final, var) #variance
sapply(df_final,sd) #sd


####  unsupervised learning  #####

### Hierarchical clustering ####

# for creating dendrogram 

# Distance matrix
?dist #This function computes and returns the distance matrix
d <- dist(df_final, method = "euclidean")
d
?hclust

fit <- hclust(d, method = "complete")

# Display dendrogram
plot(fit) 
plot(fit, hang = -1)

#to view clusters
rect.hclust(fit, k = 3, border = "red")

?cutree #Cut a Tree into Groups of Data
groups <- cutree(fit, k = 3) # Cut tree into 3 clusters
groups
#converting into matrix to added it to main data
membership <- as.matrix(groups)

#adding it to main data
final <- data.frame(membership, df)
View(final)

#aggregateing data with clusters by mean using aggregate function.
mean_cluster<-aggregate(df1, by = list(final$membership), FUN = mean)

#to save data set 
library(readr)
write_csv(final, "crime_hiera.csv")
write_csv(mean_cluster, "crime_hiera_mean.csv")
getwd()

##Conclusion: As per the dendogram diagram the data clustered into three categories. The conclusions are drawn from mean_crime_hiehra.csv.
#Depending upon the different crime rates in states clustering has done.
#it is suggested that not to prefer the states with  1st cluster states because it has high crime.