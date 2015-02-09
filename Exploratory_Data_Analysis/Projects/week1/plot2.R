# plot2.R is to draw line chart with Global_active_power of house hold power consumption data 

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



# plot 1 - line chart
par(mfrow = c(1, 1))
plot(household_consumption_data$new_date_time, household_consumption_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)" )


# copy plot to png file
dev.copy(png, file = "plot2.png",width = 480, height = 480)

# close connection to png device
dev.off()

# close file connection
close(readDataFromFile)
