## Hierarchical Clustering ###

##Business objective: clustering of data using unsupervised hierarical clustering method and draw interferance from clustered data.
#                       the data is all about different crimes percentage in various states. 

import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

import pandas as pd
#import data file
df = pd.read_csv("D:\\360.digi\\Assignment\\Clustering-Hierarchical Clustering\\Dataset_Assignment Clustering\\crime_data.csv")

df1 = df.drop(["state"], axis=1)


##### exploratory data analysis ######
df1.dtypes
df1.describe()
df1.info()
df1.std()
df1.var()
# expect "number of complants" all numeric columns as to be normalize.

#checking data by calucalating skews and kurtosis.
import scipy.stats

scipy.stats.skew(df1["Murder"])#skewness=0.382 #positive skew
plt.hist(df1["Murder"])##data are not normally distributed

scipy.stats.skew(df1["Assault"])#skewness=0.227 #positive skew
plt.hist(df1["Assault"])##data are not normally distributed

scipy.stats.skew(df1["UrbanPop"])#skewness=-0.219 #negative skew
plt.hist(df1["UrbanPop"])##data are not normally distributed

scipy.stats.skew(df1["Rape"])#skewness=0.776 #positive skew
plt.hist(df1["Rape"])#data are not normally distributed


scipy.stats.kurtosis(df1["Murder"])#kurtosisness= -0.864 <3
scipy.stats.kurtosis(df1["Assault"])#kurtosisness= -1.06 <3
scipy.stats.kurtosis(df1["UrbanPop"])#kurtosisness= -0.7842 > 3
scipy.stats.kurtosis(df1["Rape"])#kurtosis= 0.201  <3



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

sns.boxplot(df1["Murder"]);plt.title("Murder");plt.show()#no outliers
sns.boxplot(df1["Assault"]);plt.title("Assault");plt.show()##no outliers-
sns.boxplot(df1["UrbanPop"]);plt.title("UrbanPop");plt.show()#20 outliers
sns.boxplot(df1["Rape"]);plt.title("Rape");plt.show()# outliers
#the outliers seen in the plots are acceptable because data itself in that way so we cannot consider then has outliers.
#no outlier treatment required.

######Standardization######

#standardization using function
#def function(i):
#    x=(i-i.mean())/(i.std())
#    return(x)
#df_norm=function(df_new.iloc[:,0:8])

from sklearn.preprocessing import normalize
data_scaled = pd.DataFrame(normalize(df1))
data_scaled.std()
data_scaled.var()

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

# Now applying AgglomerativeClustering choosing 2 or 4 as clusters from the above dendrogram
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
df_clust = df.iloc[:, [5,0,1,2,3,4]]

# Aggregate mean of each cluster
mean_label=df1.groupby(df.clust).mean()

# creating a csv file 
df_clust.to_csv("crime_hiehra.csv", encoding = "utf-8") #understand format
mean_label.to_csv("mean_crime_hiehra.csv", encoding = "utf-8")

import os
os.getcwd() #to see working directory

##Conclusion: As per the dendogram diagram the data clustered into four categories. The conclusions are drawn from mean_crime_hiehra.csv.
#Depending upon the different crime rates in states clutering has done.
#it is suggested that not to prefer the states with 3rd and 1st cluster states because it has high crime.

