# plot4.R is to draw four line chart with house hold power consumption data 

# check the data directory which holds the data files exists or not. If it doesn't exist create a directory with name 'data'
if (!file.exists("data"))
{
  dir.create("data")
}

#source url and the destination file url(current directory/data)
sourceUrl <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
destinationUrl<- "./data/household_power_consumption.zip"

# download the file & note the time
download.file(sourceUrl, destinationUrl)
fileDownloadedAt <- date()

#unzip the downloaded file
unzip(destinationUrl,"household_power_consumption.txt")

# Read the data from file 
readDataFromFile <- file("household_power_consumption.txt", "r");

# Extract the required data ie. lines start with 1/2/2007 or 2/2/2007
household_consumption_data <- read.table(text = grep("^[1,2]/2/2007", readLines(readDataFromFile), value = TRUE),sep = ";", skip = 0, na.strings = "?", stringsAsFactors = FALSE)

# add column names as of source file
names(household_consumption_data) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
                                       "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")


# add a new date-time column with the format %d/%m/%Y %H:%M:%S
household_consumption_data$new_date_time <- as.POSIXct(paste(household_consumption_data$Date,household_consumption_data$Time), format="%d/%m/%Y %H:%M:%S")

# attach the house hold consumption data set
attach(household_consumption_data)


# divide the plot area in to four parts
par(mfrow = c(2, 2))

# plot 1 - line chart of  datetime Vs Global Active power
plot(new_date_time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

#plot 2 - line chart of datetime Vs Voltage 
plot(new_date_time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

#plot 3 - line chart of datetime Vs sub meters
plot(new_date_time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering" )
lines(new_date_time, Sub_metering_2, col = "red")
lines(new_date_time, Sub_metering_3, col = "blue")
legend(max(new_date_time)-95000,42, col = c("black", "red", "blue"), cex = 0.6, lty = 1,bty="n",y.intersp=0.3,legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

#plot 4 - line chart of datetime Vs Global_reactive_power
plot(new_date_time, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global Reactive Power")

# copy plot to png file
dev.copy(png, file = "plot4.png",width = 480, height = 480)

# close connection to png device
dev.off()

#detach the attached house hold consumption data set
detach(household_consumption_data)

# close file connection
close(readDataFromFile)
