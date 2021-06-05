## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#The data is about all customers of east west airlines so, we need clusters the customers with the data and increase product/service for air lines. 

install.packages("readxl")
library("readxl")
#import data
df<-read_excel("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\EastWestAirlines.xlsx",sheet=2)

attach(df) #this command is used to attach dataframe so that there need not to use $ for every operation further.

# Remove categorical variables
df1 <- subset(df, select = -c(ID))

##### exploratory data analysis ######
str(df) #to see strcture of data
View(df1) # to view the data in new tab
summary(df1) # gets the summary of data like mean, median, max, min, etc..,

sapply(df1, var) # variance data
sapply(df1,sd)# standarad deviation of data
# expect "number of complants" all numeric columns as to be normalize.


#checking data by calucalating skews and kurtosis.

library("UsingR") #library to plot histogram
library("moments") # libraryto plot densityplot

skewness(Balance)#skewness=5.002 #positive skew
hist(Balance)##data are not normally distributed
densityplot(Balance)##data are not normally distributed

skewness(Qual_miles)#skewness=7.509 #positive skew
hist(Qual_miles)##data are not normally distributed
densityplot(Qual_miles)##data are not normally distributed

skewness(cc1_miles)#skewness=0.857 #positive skew
hist(cc1_miles)##data are not normally distributed
densityplot(cc1_miles)##data are not normally distributed

skewness(cc2_miles)#skewness=11.206 #positive skew
hist(cc2_miles)##data are not normally distributed
densityplot(cc2_miles)##data are not normally distributed

skewness(cc3_miles)#skewness=17.189 #positive skew
hist(cc3_miles)##data are not normally distributed
densityplot(cc3_miles)##data are not normally distributed

skewness(Bonus_miles)#skewness=2.84 #positive skew
hist(Bonus_miles)##data are not normally distributed
densityplot(Bonus_miles)##data are not normally distributed

skewness(Bonus_trans)#skewness=1.156 #positive skew
hist(Bonus_trans)##data are not normally distributed
densityplot(Bonus_trans)##data are not normally distributed

skewness(Flight_miles_12mo)#skewness=7.44 #positive skew
hist(Flight_miles_12mo)##data are not normally distributed
densityplot(Flight_miles_12mo)##data are not normally distributed

skewness(Flight_trans_12)#skewness=5.488 #positive skew
hist(Flight_trans_12)##data are not normally distributed
densityplot(Flight_trans_12)##data are not normally distributed

skewness(Days_since_enroll)#skewness=0.1201 #positive skew
hist(Days_since_enroll)##data are not normally distributed
densityplot(Days_since_enroll)##data are not normally distributed

skewness(`Award?`)#skewness=0.536 #positive skew
hist(`Award?`)##data are not normally distributed
densityplot(`Award?`)##data are not normally distributed

kurtosis(Balance)#kurtosisness= 47.101 >3
kurtosis(Qual_miles)#kurtosisness= 70.603 >3
kurtosis(cc1_miles)#kurtosisness= 2.2509 <3
kurtosis(cc2_miles)#kurtosisness= 136.61 >3
kurtosis(cc3_miles)#kurtosisness= 311.267 >3
kurtosis(Bonus_miles)#kurtosisness= 16.611 >3
kurtosis(Bonus_trans)#kurtosisness= 5.7408 >3
kurtosis(Flight_miles_12mo)#kurtosisness= 97.64 >3
kurtosis(Flight_trans_12)#kurtosisness= 45.922 >3
kurtosis(Days_since_enroll)#kurtosisness= 2.0322 <3
kurtosis(`Award?`)#kurtosisness= 1.288 <3

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

boxplot(Balance) #outliers found
boxplot(Qual_miles) #outliers found
boxplot(cc1_miles) #outliers
boxplot(cc2_miles) # outliers found
boxplot(cc3_miles) #outliers found
boxplot(Bonus_miles) #outliers found
boxplot(Bonus_trans) #outliers found
boxplot(Flight_miles_12mo) #outliers found
boxplot(Flight_trans_12) #outliers found
boxplot(Days_since_enroll) #no outliers
boxplot(`Award?`) # no outliers

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
#?dist #This function computes and returns the distance matrix
d <- dist(df_final, method = "euclidean")
d

#?hclust
fit <- hclust(d, method = "complete")

# Display dendrogram
plot(fit) 
plot(fit, hang = -1)

#to view clusters
rect.hclust(fit, k = 3, border = "red")

#?cutree #Cut a Tree into Groups of Data
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
write_csv(final, "Eastwestairlines_hiehra.csv")
write_csv(mean_cluster, "Eastwestairlines_hiehra_mean.csv")
getwd()

##Conclusion: As per the dendogram diagram the data clustered into three categories. The conclusions are drawn from mean_Eastwestairlines_hiehra.csv.
#1. In clustering Balance and days since enroll as proportional.
#2. The remaining entities flows Bonus mile.
#3. Lot of information can be drawn from various analysis depending upon requirement.