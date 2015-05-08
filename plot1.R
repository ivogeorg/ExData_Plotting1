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

# Plot 1
png("./plot1.png")
with(powerCons,
     hist(Global_active_power, 
     col="red", 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     ylim=c(0, 1200)))

dev.off()
