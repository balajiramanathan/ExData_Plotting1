
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

##Open the plot4.png file as the graphics device
png("plot4.png", height = 480, width = 480)

##Set up a 2x2 grid of 4 plots.  The grid will be filled row after row
par(mfrow = c(2, 2))

##Plot in upper left quadrant
plot(data$DateTime, data$Global_active_power, type = "l",
     xlab = "", ylab = "Global Active Power (kilowatts)")

##Plot in upper right quadrant
plot(data$DateTime, data$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage")

##Plot in lower left quadrant
plot(data$DateTime, data$Sub_metering_1, type = "l",
     xlab = "", ylab = "Energy sub metering")
##Add the additional data as lines to the base plot
lines(data$DateTime, data$Sub_metering_2, type = "l", col = "red")
lines(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")
##Add the legend to the top right corner of the plot.  Note that we have added
##the option bty = "n" to prevent drawing of a box around the legend
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = 1, bty = "n")

##Plot in lower right quadrant
plot(data$DateTime, data$Global_reactive_power, type = "l",
     xlab = "datetime", ylab = "Global_reactive_power")

##Turn off the graphics device (in this case, close the png file)
dev.off()