# Load the data
data <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
sub_data <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")
datetime <- paste(sub_data$Date, sub_data$Time)
sub_data$Datetime <- as.POSIXct(datetime)

# Create Plot 2
png("plot2.png", width=480, height=480)
plot(sub_data$Global_active_power ~ sub_data$Datetime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()
