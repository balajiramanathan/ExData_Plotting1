
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

##Open the plot3.png file as the graphics device
png("plot3.png", height = 480, width = 480)

##Create a line plot of date and time vs Sub Metering 1.  The default color
##of the line is black
plot(data$DateTime, data$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")

##Now add red and blue line plots for Sub metering 2 and Sub metering 3
lines(data$DateTime, data$Sub_metering_2, type = "l", col = "red")
lines(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")

##Create a legend in the top right corner of the plot.  Since the plot
##is a line plot, we use the lty option instead of specifying pch, which
##is used if the plot contains points
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1)

##Turn off the graphics device (in this case, close the png file)
dev.off()