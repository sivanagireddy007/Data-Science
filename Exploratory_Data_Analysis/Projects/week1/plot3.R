# plot3.R is to draw line chart with sub meters of house hold power consumption data 

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


# plot 1 - line chart
par(mfrow = c(1, 1))
plot(new_date_time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering" )
lines(new_date_time, Sub_metering_2, col = "red")
lines(new_date_time, Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), cex = 0.8, lty = 1,legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

# copy plot to png file
dev.copy(png, file = "plot3.png",width = 480, height = 480)

# close connection to png device
dev.off()

#detach the attached house hold consumption data set
detach(household_consumption_data)

# close file connection
close(readDataFromFile)
