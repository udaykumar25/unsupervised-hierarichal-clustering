## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#the data is about teleco information of customers and we need to cluster the data to minimise the churns. 

#constraint: the is mixed data (obj and float).


import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

import pandas as pd
#import data file
df = pd.read_excel("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\Telco_customer_churn.xlsx")

df1 = df.drop(["Customer ID","Count","Quarter"], axis=1)


##### exploratory data analysis ######
df1.dtypes
df1.describe()
df1.info()
df1.std()
df1.var()
# expect "number of complants" all numeric columns as to be normalize.

#checking data by calucalating skews and kurtosis.
import scipy.stats

scipy.stats.skew(df1["Number of Referrals"])#skewness=1.44 #positive skew
plt.hist(df1["Number of Referrals"])##data are not normally distributed

scipy.stats.skew(df1["Tenure in Months"])#skewness=0.2404 #positive skew
plt.hist(df1["Tenure in Months"])##data are not normally distributed

scipy.stats.skew(df1["Avg Monthly Long Distance Charges"])#skewness0.049 #positive skew
plt.hist(df1["Avg Monthly Long Distance Charges"])##data uniformly distributed

scipy.stats.skew(df1["Avg Monthly GB Download"])#skewness=1.216 #positive skew
plt.hist(df1["Avg Monthly GB Download"])#data are not normally distributed

scipy.stats.skew(df1["Monthly Charge"])#skewness=-0.2204 #positive skew
plt.hist(df1["Monthly Charge"])#data uniformly distributed

scipy.stats.skew(df1["Total Charges"])#skewness=0.9635 #positive skew
plt.hist(df1["Total Charges"])#data are not normally distributed

scipy.stats.skew(df1["Total Refunds"])#skewness=4.3275 #positive skew
plt.hist(df1["Total Refunds"])#data are not normally distributed

scipy.stats.skew(df1["Total Extra Data Charges"])#skewness=4.0903 #positive skew
plt.hist(df1["Total Extra Data Charges"]) #data are not normally distributed

scipy.stats.skew(df1["Total Long Distance Charges"])#skewness=1.238 #positive skew
plt.hist(df1["Total Long Distance Charges"])#data are not normally distributed

scipy.stats.skew(df1["Total Revenue"])#skewness=0.919 #positive skew
plt.hist(df1["Total Revenue"]) #data are not normally distributed


scipy.stats.kurtosis(df1["Number of Referrals"])#kurtosisness= 0.7205 <3
scipy.stats.kurtosis(df1["Tenure in Months"])#kurtosisness= -1.386 <3
scipy.stats.kurtosis(df1["Avg Monthly Long Distance Charges"])#kurtosisness= -1.25 <3
scipy.stats.kurtosis(df1["Avg Monthly GB Download"])#kurtosis= 0.88  <3
scipy.stats.kurtosis(df1["Monthly Charge"])#kurtosis= -1.257 <3
scipy.stats.kurtosis(df1["Total Charges"])#kurtosis= -0.2283  <3
scipy.stats.kurtosis(df1["Total Refunds"])#kurtosis=18.336  >3
scipy.stats.kurtosis(df1["Total Extra Data Charges"])#kurtosis=16.44  >3
scipy.stats.kurtosis(df1["Total Long Distance Charges"])#kurtosis=0.6427  <3
scipy.stats.kurtosis(df1["Total Revenue"])#kurtosis=-0.204  <3


########  Data processing  ######

#####MissingValues#####

# using isnull() function   
df1.isnull()
#check null values in data set
df1.isnull().sum() #no null values


####Duplication_Typecasting#####
#Identify duplicates records in the data
duplicate = df.duplicated()
sum(duplicate) #no duplicates

####Outlier_Treatment#######

sns.boxplot(df1["Number of Referrals"]);plt.title("Number of Referrals");plt.show()# outliers found
sns.boxplot(df1["Tenure in Months"]);plt.title("Tenure in Months");plt.show()##no outliers
sns.boxplot(df1["Avg Monthly Long Distance Charges"]);plt.title("Avg Monthly Long Distance Charges");plt.show()#no outliers
sns.boxplot(df1["Avg Monthly GB Download"]);plt.title("Avg Monthly GB Download");plt.show()#outliers  found
sns.boxplot(df1["Monthly Charge"]);plt.title("Monthly Charge");plt.show()#no outliers
sns.boxplot(df1["Total Charges"]);plt.title("Total Charges");plt.show()#no outliers
sns.boxplot(df1["Total Refunds"]);plt.title("Total Refunds");plt.show()# outliers  found
sns.boxplot(df1["Total Extra Data Charges"]);plt.title("Total Extra Data Charges");plt.show()# outliers  found
sns.boxplot(df1["Total Long Distance Charges"]);plt.title("Total Long Distance Charges");plt.show()# outliers  found
sns.boxplot(df1["Total Revenue"]);plt.title("Total Revenues");plt.show()# outliers  found


#the outliers seen in the plots are acceptable because data itself in that way so we cannot consider then has outliers.
#no outlier treatment required.


#####Dummy Variables#######
# Create dummy variables on categorcal columns
df_new = pd.get_dummies(df1,drop_first=True)


######Standardization######

#standardization using function
#def function(i):
#    x=(i-i.mean())/(i.std())
#    return(x)
#df_norm=function(df_new.iloc[:,0:8])

from sklearn.preprocessing import normalize
data_scaled = pd.DataFrame(normalize(df_new.iloc[:,0:10]))
data_scaled.std()
data_scaled.var()

#### custom normalization #####
def normal(i):
    x=(i-i.min())/(i.max()-i.min())
    return (x)
  
df_norm=normal(df_new.iloc[:,0:10])
df_norm.std()
df_norm.var()


df_final=pd.concat([df_norm,df_new.iloc[:,10:]],axis=1)


####  unsupervise learning  #####

### Hierarchical clustering ####

# for creating dendrogram 
from scipy.cluster.hierarchy import linkage
import scipy.cluster.hierarchy as sch 

#here we calculating distance matrix and creating dendrogram
z = linkage(df_final, method = "complete", metric = "euclidean")
#?linkage
# Dendrogram
plt.figure(figsize=(15, 8));plt.title('Hierarchical Clustering Dendrogram');plt.xlabel('Index');plt.ylabel('Distance')
sch.dendrogram(z,leaf_rotation = 0,leaf_font_size = 10);plt.show()
#sch.dendrogram(z)

#from the plot we decide how many clusters are to be made 

# Now applying AgglomerativeClustering choosing 3 as clusters from the above dendrogram
from sklearn.cluster import AgglomerativeClustering
#agglomerative function is fitted or applied on dataset
h_complete = AgglomerativeClustering(n_clusters = 3, linkage = 'complete', affinity = "euclidean").fit(df_norm) 
#?Agglomerative

h_complete.labels_ #for that function we are taking labels
#from the function take labels
#converting into series
cluster_labels = pd.DataFrame(pd.Series(h_complete.labels_))
cluster_labels.columns =['clust'] 

#change the postion of new column
df_clust = pd.concat([cluster_labels,df],axis=1)

# Aggregate mean of each cluster
mean_label=df_new.iloc[:,0:10].groupby(df_clust.clust).mean()

# creating a csv file 
df_clust.to_csv("Telco_hier.csv", encoding = "utf-8") #understand format
mean_label.to_csv("mean_Telco_hier.csv", encoding = "utf-8")

import os
os.getcwd() #to see working directory

##Conclusion: As per the dendogram diagram the data clustered into four categories. The conclusions are drawn from mean_Telco_hier.csv.
#1. To reduce the chrun more focus has to put on 2nd clustered customers. 
#2. Lot of information can be drawn from various analysis depending upon requirement.

