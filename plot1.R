
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

##Open the plot1.png file as the graphics device
png("plot1.png", width = 480, height = 480)

##Plot a histogram of the Global Active Power values using red as the fill color,
##and set the appropriate x axis label and main chart title
hist(data$Global_active_power, col = "red", 
     xlab = "Global Active Power (Kilowatts)", 
     main = "Global Active Power")

##Turn off the graphics device (in this case, close the png file)
dev.off()
