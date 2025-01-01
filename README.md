# WALMART Sales Analysis
### End-to-End Project: Python + SQL + Power BI    

![walmart project](https://github.com/user-attachments/assets/70fadc2e-1f95-49c2-975a-f20c659e785f)

### **Dataset Link** : [Walmart Sales Data](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets)

##  **Project Steps**

### *1. Setting Up Environment*

 **Tools Used** : Google Colab , PostgreSQL , Power BI
 
**Programming Languages** : Python , SQL

### *2. Setting Up Kaggle API*

**API Setup** : Obtain kaggle api token from kaggle and then download the JSON file

**Configure** : Placing the downloaded kaggle.json file in local folder by using  

        kaggle datasets download -d  dataset-path 
   to pull datasets directly into the project

### *3. Installing Required Libraries*

**->Pandas**

**->Numpy**

**->OS**

### *4. Exploring Data*

**Goal** : An initial data exploration to understand data distribution , checking column types , data types , identifying potential issues are to be conducted

**Analysis** : Use functions like .info() , .describe()  and  .head() to get a quick overview

### *5. Data Cleaning(Using Python)*

**->Removing Duplicates to avoid skewed results**

**->Handling Missing/Null values**

**->Fixing Datatypes**

**->Renaming Columns**

### *6. Feature Engineering*

**Create New Columns** : Calculate Total Amount for each transaction by unit_price * quantity and adding this as a new column 

### *7. Loading Data into SQL : Complex Queries and Business Solving*

**Table Creation** : Set up table  in PostgreSQL to insert and load the dataset values

**Business Problem Solving** : Write and execute complex SQL queries to answer critical business questions

->Revenue trends across branches and categories
     
->Identifying best selling product categories
     
->Sales performance by time, city and payment method
     
->Profit Margin analysis by branch and category
     
### *8. Publishing Data into Power BI* 

Implementing dashboard to show trends, charts and analyze year-to-year growth

### *9. Project Documentation* 

 Maintaining a well structured code documentation through Python notebook and SQL file.


![Screenshot 2024-12-25 100621](https://github.com/user-attachments/assets/1ce62a6d-a382-41ea-86f1-814bfad3ecca)


#### Key Insights:

1.Sales Trends (2019-2023):
- Notable growth from 2019 to 2020 across categories.
  
- Relatively stable performance from 2020-2023 with slight fluctuations.
  
- 2023 shows modest growth compared to 2022 in most categories.

2.Category-specific Insights:

- Electronic accessories: High margin but moderate volume.
  
- Fashion accessories: High volume but price sensitive.
  
- Food and beverages: Stable pricing but lower total sales.
  
- Home and lifestyle: Strong unit price performance at higher quantities.
  
- Sports and travel: Most volatile pricing structure.

