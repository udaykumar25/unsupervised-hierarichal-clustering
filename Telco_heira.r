## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#the data is about teleco information of customers and we need to cluster the data to minimise the churns. 

#constraint: the is mixed data (obj and float).
install.packages("readxl")
library("readxl")
#import data
df<-read_excel("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\Telco_customer_churn.xlsx")

attach(df) #this command is used to attach dataframe so that there need not to use $ for every operation further.

# Remove categorical variables
df1 <- subset(df, select = -c(`Customer ID`,Count,Quarter))
df_numeric<-subset(df,select = c(`Number of Referrals`,`Tenure in Months`,`Avg Monthly Long Distance Charges`,`Avg Monthly GB Download`,
                                 `Monthly Charge`,`Total Charges`,`Total Refunds`,`Total Revenue`,`Total Extra Data Charges`,`Total Long Distance Charges`))
##### exploratory data analysis ######
str(df1) #to see strcture of data
View(df1) # to view the data in new tab
summary(df1) # gets the summary of data like mean, median, max, min, etc..,

sapply(df_numeric, var) # variance data
sapply(df_numeric,sd)# standarad deviation of data
# expect "number of complants" all numeric columns as to be normalize.


#checking data by calucalating skews and kurtosis.

library("UsingR") #library to plot histogram
library("moments") # libraryto plot densityplot

skewness(`Number of Referrals`)#skewness=1.445#positive skew
hist(`Number of Referrals`)##data are not normally distributed
densityplot(`Number of Referrals`)##data are not normally distributed

skewness(`Tenure in Months`)#skewness=0.240 #positive skew
hist(`Tenure in Months`)##data are not normally distributed
densityplot(`Tenure in Months`)##data are not normally distributed

skewness(`Monthly Charge`)#skewness=-0.2204 #positive skew
hist(`Monthly Charge`)##data are not normally distributed
densityplot(`Monthly Charge`)##data are not normally distributed

skewness(`Total Charges`)#skewness=0.963 #positive skew
hist(`Total Charges`)##data are not normally distributed
densityplot(`Total Charges`)##data are not normally distributed

skewness(`Total Revenue`)#skewness=0.919
hist(`Total Revenue`)###data uniformly distributed
densityplot(`Total Revenue`)###data uniformly distributed

skewness(`Total Refunds`)#skewness=4.32 #positive skew
hist(`Total Refunds`)##data are not normally distributed
densityplot(`Total Refunds`)##data are not normally distributed

skewness(`Total Extra Data Charges`)#skewness=4.09 #positive skew
hist(`Total Extra Data Charges`)##data are not normally distributed
densityplot(`Total Extra Data Charges`)##data are not normally distributed

skewness(`Total Long Distance Charges`)#skewness=1.238 #positive skew
hist(`Total Long Distance Charges`)##data are not normally distributed
densityplot(`Total Long Distance Charges`)##data are not normally distributed

skewness(`Avg Monthly GB Download`)#skewness=1.216 #positive skew
hist(`Avg Monthly GB Download`)##data are not normally distributed
densityplot(`Avg Monthly GB Download`)##data are not normally distributed

skewness(`Avg Monthly Long Distance Charges`)#skewness=0.0491 #positive skew
hist(`Avg Monthly Long Distance Charges`)##data are not normally distributed
densityplot(`Avg Monthly Long Distance Charges`)##data are not normally distributed

kurtosis(`Number of Referrals`)#kurtosisness= 3.72 >3
kurtosis(`Tenure in Months`)#kurtosisness= 1.613 <3
kurtosis(`Avg Monthly GB Download`)#kurtosisness= 3.88 >3
kurtosis(`Avg Monthly Long Distance Charges`)#kurtosisness= 1.74 <3
kurtosis(`Monthly Charge`)#kurtosisness= 1.74 <3
kurtosis(`Total Charges`)#kurtosisness= 2.77 >3
kurtosis(`Total Refunds`)#kurtosisness= 21.33 >3
kurtosis(`Total Revenue`)#kurtosisness= 2.795 >3
kurtosis(`Total Extra Data Charges`)#kurtosisness= 19.446 >3
kurtosis(`Total Long Distance Charges`)#kurtosisness= 3.642 >3

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

boxplot(`Number of Referrals`) #outliers found
boxplot(`Tenure in Months`) #no outliers
boxplot(`Avg Monthly Long Distance Charges`) #no outliers
boxplot(`Avg Monthly GB Download`) # outliers found
boxplot(`Monthly Charge`) # no outliers
boxplot(`Total Charges`) # no outliers 
boxplot(`Total Refunds`) # outliers found
boxplot(`Total Revenue`) #outliers found
boxplot(`Total Extra Data Charges`) # outliers found
boxplot(`Total Long Distance Charges`) #outliers found

#the outliers seen in the plots are acceptable because data itself in that way so we cannot consider then has outliers.
#no outlier treatment required.


#####  scale or standardisation  ####

#df_norm<-as.data.frame(scale(df_numeric))

##custom normalization
common<-function(i){
  x=(i-min(i))/(max(i)-min(i))
  return(x)
}
df_norm=common(df_numeric)

sapply(df_norm, var) #variance
sapply(df_norm,sd) #sd


#####Dummy Variables#######
# Create dummy variables on categorcal columns
library(fastDummies)

dummy_df <- dummy_cols(df1,remove_first_dummy = TRUE,
                       remove_most_frequent_dummy =FALSE,remove_selected_columns = TRUE)

#normalized numeric data set.
df_final<-data.frame(df_norm,dummy_df[,c(11:35)])


####  unsupervised learning  #####

### Hierarchical clustering ####

# for creating dendrogram 

# Distance matrix
#?dist #This function computes and returns the distance matrix
d <- dist(df_final, method = "euclidean")
d
?hclust

#Hierarchical cluster analysis on a set of dissimilarities and methods for analyzing it.
fit <- hclust(d, method = "complete")

# Display dendrogram
plot(fit) 
plot(fit, hang = -1)

#?cutree #Cut a Tree into Groups of Data
groups <- cutree(fit, k = 3) # Cut tree into 3 clusters
#groups

#to view clusters
rect.hclust(fit, k = 3, border = "red")

#converting into matrix to added it to main data
membership <- as.matrix(groups)

#adding it to main data
final <- data.frame(membership, df)
View(final)

#aggregateing data with clusters by mean using aggregate function.
mean_cluster<-aggregate(df_numeric, by = list(final$membership), FUN = mean)
mean_cluster

#to save data set 
library(readr)
write_csv(final, "Telco_hiera.csv")
write_csv(mean_cluster, "Telco_hiera_mean.csv")
getwd()



#### Method-2 ####
##using dasiy function
library(dplyr)
# all character columns to factor:
df2 <- mutate_if(df1, is.character, as.factor)
str(df2)

library(cluster)
d2<-daisy(df2)

fit2 <- hclust(d2, method = "complete")

# Display dendrogram
plot(fit2) 
plot(fit2, hang = -1)

?cutree #Cut a Tree into Groups of Data
groups2 <- cutree(fit2, k = 3) # Cut tree into 3 clusters
groups
#to view clusters
rect.hclust(fit2, k = 3, border = "red")

#converting into matrix to added it to main data
membership2 <- as.matrix(groups2)

#adding it to main data
final2 <- data.frame(membership2, df)
View(final2)

#aggregateing data with clusters by mean using aggregate function.
mean_cluster2<-aggregate(df_numeric, by = list(final2$membership2), FUN = mean)
mean_cluster2

#to save data set 
library(readr)
write_csv(final2, "Telco_hiera2.csv")
write_csv(mean_cluster2, "Telco_hiera_mean2.csv")

getwd()

##Conclusion: As per the dendogram diagram the data clustered into four categories. The conclusions are drawn from Telco_hiera_mean2.csv
#1. To reduce the chrun more focus has to put on 2nd clustered customers. 
#2. Lot of information can be drawn from various analysis depending upon requirement.
