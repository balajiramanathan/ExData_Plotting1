
##Load the sqldf library.  We need this library in order to subset the
##data while reading so that not all of the data is loaded into R
library(sqldf)

##Read the data.  Note the use of the where clause in SQL to limit the
##data to just the points corresponding to February 1 and 2, 2007
data <- read.csv.sql("household_power_consumption.txt", 
                     sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",
                     header = TRUE, sep = ";",
                     colClasses = c(rep("character",2), rep("numeric",7)))

closeAllConnections()

##Create a new column to hold the date and time (which have been read in as
##character strings) as a POSIXct object
data$DateTime <- as.POSIXct(paste(data$Date, data$Time),format="%d/%m/%Y %H:%M:%S")

##This line is not needed since R plots an axis with POSIXct type using
##abbreviated weekday names by default
##data$Day = weekdays(data$DateTime, abbreviate = T)

##Open the plot2.png file as the graphics device
png("plot2.png", height = 480, width = 480)

##Create a line plot of date and time against Global Active Power,
##and create an empty x axis label and appropriate y axis label
plot(data$DateTime, data$Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)")

##Turn off the graphics device (in this case, close the png file)
dev.off()