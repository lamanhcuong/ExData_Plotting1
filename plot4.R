## This script is to create plot 4 as required / described by Course Project 1 - Plotting of Cousera Exploratory Data Analysis

##download the zip file if it does not exist
if (!file.exists("exdata_data_household_power_consumption.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata_data_household_power_consumption.zip", mode="wb")
}

##unzip the file
if (file.exists("exdata_data_household_power_consumption.zip") & !file.exists("household_power_consumption.txt")){
  unzip("exdata_data_household_power_consumption.zip", files=c("household_power_consumption.txt"))
  
}

library(readr)
library(dplyr)

## Read data in
myData <- read_delim("household_power_consumption.txt", delim = ";", col_types = "ccnnnnnnn", na = c("NA"), quoted_na = TRUE)

## Filter data for 2 days 2007-02-01 and 2007-02-02 only
myData <- filter(myData, format(as.Date(Date, "%d/%m/%Y"), "%Y") == "2007") ## Filter for year = 2007
myData <- filter(myData, format(as.Date(Date, "%d/%m/%Y"), "%m") == "02") ## Filter for month = 2 (Feb)
myData <- filter(myData, format(as.Date(Date, "%d/%m/%Y"), "%d") <= "02") ##Filter for day = 1 or 2

## add a new  variable of POSIXt type name DateTime which combines Date and Time variables
myData$DateTime <- strptime(paste(myData$Date, myData$Time), format = "%d/%m/%Y %H:%M:%S")

##plot 4
dev.size(units=c("px"))
dev.new(480,480)
par(mfrow=c(2,2))
with (myData, {
  plot(DateTime, Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  plot(DateTime, Voltage, type="l", ylab="Voltage", xlab="datetime")
  
  plot(DateTime, Sub_metering_1, type="l", col="black", ylab="Energy sub meeting", xlab="")
  lines(DateTime, Sub_metering_2, col="red")
  lines(DateTime, Sub_metering_3, col="blue")
  legend("topright", col=c("black","red","blue"), lty = c(1, 1, 1), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  
  plot(DateTime, Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
})

dev.copy(png, file = "plot4.png")
dev.off()

rm(myData)