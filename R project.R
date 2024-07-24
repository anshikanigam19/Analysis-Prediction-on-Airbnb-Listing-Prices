install.packages("readr")
library(readr)
# Data Importing
airbnbdata <- read.csv("C:/Users/hp/Downloads/R Progrm Project/AB_NYC_2019.csv")
View(airbnbdata)

#Data Cleaning and Transformation
install.packages("dplyr")
library(dplyr)

# Removing rows with missing values in the "reviews_per_month" column
airbnbdata <- filter(airbnbdata, !is.na(reviews_per_month))

# Checking for missing values in the dataset
sapply(airbnbdata, function(x) sum(is.na(x)))

#Exploratory Data Analysis (EDA):
# Summary statistics
summary(airbnbdata)

#Select only numeric variables for correlation calculation
numeric_variables <-airbnbdata %>%
  select_if(is.numeric)

# Correlation matrix
correlation_matrix <- cor(numeric_variables)
print(correlation_matrix)

#Installing ggplot2 package
install.packages("ggplot2")
library(ggplot2)

# Histogram of price
ggplot(airbnbdata, aes(x = price)) +
  geom_histogram(binwidth = 50) +
  labs(x = "Price", y = "Frequency", title = "Histrogram of Price")

# Boxplot of price by room_type
ggplot(airbnbdata, aes(x = room_type, y = price)) +
  geom_boxplot() +
  labs(x = "Room Type", y = "Price", title = "Boxplot of Price by Room Type")

#Feature Engineering
# Creating a new feature: distance from a popular landmark (using latitude and longitude)
airbnbdata<-airbnbdata %>%
  mutate(distance_from_landmark =calculate_distance(latitude,longitude,landmark_latitude,landmark_longitude))
View(airbnbdata)

#Modelling
#Installing package caret
install.packages("caret")
library(caret)

# Splitting the data into training and testing sets 
set.seed(123)
train_indices <- sample(1:nrow(airbnbdata),nrow(airbnbdata) * 0.7)
train_data <- airbnbdata[train_indices, ]
test_data <- airbnbdata[-train_indices, ]

# Building a linear regression model
model <- lm(price ~ room_type + host_name + distance_from_landmark, data = train_data)

#Convert host_name to a factor with the same levels as in the train_data dataset
test_data$host_name<-factor(test_data$host_name,levels = levels(train_data$host_name))

# Making predictions on the test set
predictions <- predict(model, newdata = test_data)

#Create scatter plot with predicted values
ggplot(test_data,aes(x=host_name, y=price))+
  geom_point()+
  geom_line(data=cbind(test_data,predictions),aes(y=predictions),color="red")+
  labs(x="Host Name",y="Price",title = "Regression Model Prediction")

# Evaluating model performance
#Installing package metrics
install.packages("Metrics")
library(Metrics)
rmse <- rmse(test_data_filtered$price, predictions)
print(paste(rmse))
#Calculate mean absolute error(MAE)
mae<-mae(test_data_filtered$price, predictions)

#Print evaluation metrics
print(paste(cat("Root Mean Squared Error (RMSE):", rmse, "\n")))
print(paste(cat("Mean Absolute Error (MAE):", mae, "\n")))

