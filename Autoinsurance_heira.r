## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#                       the data is all about auto insurance details of people with consumer id. 

#constraint: the is mixed data (obj and float).

library(readr)
#import data
df<-read.csv("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\AutoInsurance.csv")

attach(df) #this command is used to attach dataframe so that there need not to use $ for every operation further.

# Remove categorical variables
df1 <- subset(df, select = -c(Customer,Effective.To.Date,Policy.Type))
df_numeric<-subset(df,select = c(Customer.Lifetime.Value,Income,Number.of.Open.Complaints,Number.of.Policies,
                                 Total.Claim.Amount,Months.Since.Policy.Inception,Months.Since.Last.Claim,Monthly.Premium.Auto))
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

skewness(Customer.Lifetime.Value)#skewness-3.031 #positive skew
hist(Customer.Lifetime.Value)##data are not normally distributed
densityplot(Customer.Lifetime.Value)##data are not normally distributed

skewness(Income)#skewness-0.2868 #positive skew
hist(Income)##data are not normally distributed
densityplot(Income)##data are not normally distributed

skewness(Monthly.Premium.Auto)#skewness-2.12 #positive skew
hist(Monthly.Premium.Auto)##data are not normally distributed
densityplot(Monthly.Premium.Auto)##data are not normally distributed

skewness(Months.Since.Last.Claim)#skewness-0.2785 #positive skew
hist(Months.Since.Last.Claim)##data are not normally distributed
densityplot(Months.Since.Last.Claim)##data are not normally distributed

skewness(Months.Since.Policy.Inception)#skewness-0.04015
hist(Months.Since.Policy.Inception)###data uniformly distributed
densityplot(Months.Since.Policy.Inception)###data uniformly distributed

skewness(Number.of.Open.Complaints)#skewness-2.782 #positive skew
hist(Number.of.Open.Complaints)##data are not normally distributed
densityplot(Number.of.Open.Complaints)##data are not normally distributed

skewness(Number.of.Policies)#skewness-1.253 #positive skew
hist(Number.of.Policies)##data are not normally distributed
densityplot(Number.of.Policies)##data are not normally distributed

skewness(Total.Claim.Amount)#skewness-1.714 #positive skew
hist(Total.Claim.Amount)##data are not normally distributed
densityplot(Total.Claim.Amount)##data are not normally distributed

kurtosis(Customer.Lifetime.Value)#kurtosisness= 16.81 >3
kurtosis(Income)#kurtosisness= 1.905 <3
kurtosis(Monthly.Premium.Auto)#kurtosisness= 9.189 >3
kurtosis(Months.Since.Last.Claim)#kurtosisness= 1.92 <3
kurtosis(Months.Since.Policy.Inception)#kurtosisness= 1.8669 <3
kurtosis(Number.of.Open.Complaints)#kurtosisness= 10.744 >3
kurtosis(Number.of.Policies)#kurtosisness= 3.362 >3
kurtosis(Total.Claim.Amount)#kurtosisness= 8.9754 >3


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

boxplot(Customer.Lifetime.Value) #outliers found
boxplot(Income) #no outliers
boxplot(Monthly.Premium.Auto) #outliers found
boxplot(Months.Since.Last.Claim) # no outliers
boxplot(Months.Since.Policy.Inception) # no outliers
boxplot(Number.of.Open.Complaints) # outliers found
boxplot(Number.of.Policies) # outliers found
boxplot(Total.Claim.Amount) #outliers found

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
df_final<-data.frame(df_norm,dummy_df[,c(9:49)])


####  unsupervised learning  #####

### Hierarchical clustering ####

# for creating dendrogram 

# Distance matrix
?dist #This function computes and returns the distance matrix
d <- dist(df_final, method = "euclidean")
d
?hclust

#Hierarchical cluster analysis on a set of dissimilarities and methods for analyzing it.
fit <- hclust(d, method = "complete")

# Display dendrogram
plot(fit) 
plot(fit, hang = -1)

?cutree #Cut a Tree into Groups of Data
groups <- cutree(fit, k = 4) # Cut tree into 4 clusters
#groups

#to view clusters
rect.hclust(fit, k = 4, border = "red")

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
write_csv(final, "Autoinsurance_hiera.csv")
write_csv(mean_cluster, "Autoinsurance_hiera_mean.csv")
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
groups2 <- cutree(fit2, k = 4) # Cut tree into 4 clusters
groups
#to view clusters
rect.hclust(fit2, k = 4, border = "red")

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
write_csv(final2, "Autoinsurance_hiera2.csv")
write_csv(mean_cluster2, "Autoinsurance_hiera_mean2.csv")

getwd()


##Conclusion: The data is mix data so two methods are used one through dummy variable and another through daisy function.
##             not much difference in results observed between this methods.
##As per the dendogram diagram the data clustered into four categories. The conclusions are drawn from mean_Autoinsurance_hier.csv.
#1. The clustering is done as per customer life time and total claim amount. so, those who have high life time had high claim amount independent of income.
#2. The remaining entities flows as per customer life time.
#3. Lot of information can be drawn from various analysis depending upon requirement.