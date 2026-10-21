# Load the data
data <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
sub_data <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")
datetime <- paste(sub_data$Date, sub_data$Time)
sub_data$Datetime <- as.POSIXct(datetime)

# Create Plot 4
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))
with(sub_data, {
  plot(Global_active_power ~ Datetime, type="l", ylab="Global Active Power", xlab="")
  plot(Voltage ~ Datetime, type="l", ylab="Voltage", xlab="datetime")
  plot(Sub_metering_1 ~ Datetime, type="l", ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2 ~ Datetime, col='Red')
  lines(Sub_metering_3 ~ Datetime, col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power ~ Datetime, type="l", ylab="Global_reactive_power", xlab="datetime")
})
dev.off()
