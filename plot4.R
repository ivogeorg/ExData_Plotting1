dataDir <- "./data"

if (!file.exists(dataDir)) {
  dir.create(dataDir)
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
localFileName <- "power.zip"
localFilePath <- paste(dataDir, "/", localFileName, sep="")
download.file(fileUrl, localFilePath, method="curl")
unzip(localFilePath, exdir=dataDir)

dataSetFileName <- "household_power_consumption.txt"
dataSetPath <- paste(dataDir, "/", dataSetFileName, sep="")
powerCons <- read.table(dataSetPath, 
                        header=T, 
                        sep=";", 
                        colClasses=c("character", "character", "numeric", "numeric",
                                     "numeric", "numeric", "numeric", "numeric", "numeric"),
                        na.strings = "?",
                        stringsAsFactors=F)

# Load packages for transformation
library(dplyr)
library(lubridate)

# Make one column of class Period for data+time?
powerCons <- 
  powerCons %>%
  mutate(DateTime = dmy_hms(paste(Date, Time))) %>%
  filter(DateTime >= ymd_hms("2007-02-01 00:00:00") &
           DateTime <= ymd_hms("2007-02-02 23:59:59")) %>%
  select(DateTime, Global_active_power:Sub_metering_3)

# Plot 4
png("./plot4.png")

par(mfrow=c(2, 2))

with(powerCons, 
     plot(DateTime, Global_active_power, 
     type="l",
     ylab="Global Active Power (kilowatts)", 
     xlab=""))

with(powerCons,
     plot(DateTime, Voltage, 
     type="l",
     ylab="Voltage", 
     xlab="datetime"))

with(powerCons,
{
  plot(DateTime, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="");
  lines(DateTime, Sub_metering_2, col="red");
  lines(DateTime, powerCons$Sub_metering_3, col="blue");
  legend("topright", col=c("black", "red", "blue"), lty=1, bty="n",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

with(powerCons,
     plot(DateTime, Global_reactive_power, 
     type="l",
     ylab="Global_reactive_power", 
     xlab="datetime"))


dev.off()
