## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#The data is about all customers of east west airlines so, we need clusters the customers with the data and increase product/service for air lines. 

import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

import pandas as pd
#import data file
df = pd.read_excel("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\EastWestAirlines.xlsx",sheet_name=1)

df1 = df.drop(["ID"], axis=1)
#id has unique data so it is droped
#?pd.read_excel
##### exploratory data analysis ######
df1.dtypes
df1.describe()
df1.info()
df1.std()
df1.var()
# expect "number of complants" all numeric columns as to be normalize.

#checking data by calucalating skews and kurtosis.
import scipy.stats

scipy.stats.skew(df1["Balance"])#skewness=5 #positive skew
plt.hist(df1["Balance"])##data are not normally distributed

scipy.stats.skew(df1["Qual_miles"])#skewness=7.5 #positive skew
plt.hist(df1["Qual_miles"])##data are not normally distributed

scipy.stats.skew(df1["cc1_miles"])#skewness=11.2 #positive skew
plt.hist(df1["cc1_miles"])##data are not normally distributed

scipy.stats.skew(df1["cc2_miles"])#skewness=11.2 #positive skew
plt.hist(df1["cc2_miles"])#data are not normally distributed

scipy.stats.skew(df1["cc3_miles"])#skewness=17.189 #positive skew
plt.hist(df1["cc3_miles"])##data are not normally distributed

scipy.stats.skew(df1["Bonus_miles"])#skewness=2.841 #positive skew
plt.hist(df1["Bonus_miles"])##data are not normally distributed

scipy.stats.skew(df1["Bonus_trans"])#skewness=1.15 #negative skew
plt.hist(df1["Bonus_trans"])##data are not normally distributed

scipy.stats.skew(df1["Flight_miles_12mo"])#skewness=7.44 #positive skew
plt.hist(df1["Flight_miles_12mo"])#data are not normally distributed

scipy.stats.skew(df1["Flight_trans_12"])#skewness=5.488 #positive skew
plt.hist(df1["Flight_trans_12"])##data are not normally distributed

scipy.stats.skew(df1["Days_since_enroll"])#skewness=0.12 #positive skew
plt.hist(df1["Days_since_enroll"])##data are not normally distributed

scipy.stats.skew(df1["Award?"])#skewness=0.536 #negative skew
plt.hist(df1["Award?"])##data are not normally distributed


scipy.stats.kurtosis(df1["Balance"])#kurtosisness= 44.101 >3
scipy.stats.kurtosis(df1["Qual_miles"])#kurtosisness= 67.603 >3
scipy.stats.kurtosis(df1["cc1_miles"])#kurtosisness= -0.749 < 3
scipy.stats.kurtosis(df1["cc2_miles"])#kurtosis= 133.6 > 3
scipy.stats.kurtosis(df1["cc3_miles"])#kurtosisness= 308.26 >3
scipy.stats.kurtosis(df1["Bonus_miles"])#kurtosisness= 3.611 >3
scipy.stats.kurtosis(df1["Bonus_trans"])#kurtosisness= 2.74 < 3
scipy.stats.kurtosis(df1["Flight_miles_12mo"])#kurtosis= 94.64  >3
scipy.stats.kurtosis(df1["Flight_trans_12"])#kurtosisness= 42.922 >3
scipy.stats.kurtosis(df1["Days_since_enroll"])#kurtosisness= -0.9677 <3
scipy.stats.kurtosis(df1["Award?"])#kurtosisness= -1.7116 > 3



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

sns.boxplot(df1["Balance"]);plt.title("Balance");plt.show()# outliers
sns.boxplot(df1["Qual_miles"]);plt.title("Qual_miles");plt.show()## outliers-
sns.boxplot(df1["cc1_miles"]);plt.title("cc1_miles");plt.show()#no outliers
sns.boxplot(df1["cc2_miles"]);plt.title("cc2_miles");plt.show()# outliers
sns.boxplot(df1["cc3_miles"]);plt.title("cc3_miles");plt.show()# outliers
sns.boxplot(df1["Bonus_miles"]);plt.title("Bonus_miles");plt.show()## outliers-
sns.boxplot(df1["Bonus_trans"]);plt.title("Bonus_trans");plt.show()# outliers
sns.boxplot(df1["Flight_miles_12mo"]);plt.title("Flight_miles_12mo");plt.show()# outliers
sns.boxplot(df1["Flight_trans_12"]);plt.title("Flight_trans_12");plt.show()#no outliers
sns.boxplot(df1["Days_since_enroll"]);plt.title("Days_since_enroll");plt.show()##no outliers-
sns.boxplot(df1["Award?"]);plt.title("Award?");plt.show()#20 outliers

#the outliers seen in the plots are acceptable because data itself in that way so we cannot consider then has outliers.
#no outlier treatment required.

######Standardization######

#standardization using function
#def function(i):
#    x=(i-i.mean())/(i.std())
#    return(x)
#df_norm=function(df1.iloc[:,0:10])

from sklearn.preprocessing import normalize
df_norm = pd.DataFrame(normalize(df1.iloc[:,:10]))
df_norm.std()
df_norm.var()

#### custom normalization #####
def normal(i):
    x=(i-i.min())/(i.max()-i.min())
    return (x)
  
df_final=normal(df1)
df_final.std()
df_final.var()


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

# Now applying AgglomerativeClustering choosing 4 as clusters from the above dendrogram
from sklearn.cluster import AgglomerativeClustering
#agglomerative function is fitted or applied on dataset
h_complete = AgglomerativeClustering(n_clusters = 4, linkage = 'complete', affinity = "euclidean").fit(df1) 
#?Agglomerative

h_complete.labels_ #for that function we are taking labels
#from the function take labels
#converting into series
cluster_labels = pd.Series(h_complete.labels_)

df['clust'] = cluster_labels # creating a new column and assigning it to new column 

#change the postion of new column
df_clust = df.iloc[:, [12,0,1,2,3,4,5,6,7,8,9,10,11]]

# Aggregate mean of each cluster
mean_label=df1.groupby(df.clust).mean()

# creating a csv file 
df_clust.to_csv("Eastwestairlines_hiehra.csv", encoding = "utf-8") #utf-understand format
mean_label.to_csv("mean_Eastwestairlines_hiehra.csv", encoding = "utf-8")

import os
os.getcwd() #to see working directory

##Conclusion: As per the dendogram diagram the data clustered into four categories. The conclusions are drawn from mean_Eastwestairlines_hiehra.csv.
#1. In clustering Balance and days since enroll as proportional.
#2. The remaining entities flows Bonus mile.
#3. Lot of information can be drawn from various analysis depending upon requirement.