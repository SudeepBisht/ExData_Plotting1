file <- "exdata-data-household_power_consumption.zip" 

#a check to see if file exists
# funtion read from R help
if (!file.exists(file)) 
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                file)
  
  
}
unz(file,"household_power_consumption.txt")
#check if file present in the working directory in my laptop it was giving 
#problem sometimes so i had to manually unzip it

wd<-paste(getwd(),"household_power_consumption.txt",sep="/")

data<- read.csv(file<- wd, sep=";", stringsAsFactors=F,
                na.strings=c("NA","?"),header=T,
                colClasses=c("character", "character", "numeric","numeric",
                             "numeric", "numeric","numeric", "numeric",
                             "numeric"
                )
)

temp<-paste(data$Date, data$Time)

#NOTE:
# ad.Date is not used here as strptime converts between 
# character representations and objects of classes "POSIXlt" (R Help)
# thus converting to as.Date and then using strptimecauses problem
# if we convert data$Date to Date type and want to join DAte and time
# use data$datetime<-as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

data$datetime <- strptime(temp,format="%d/%m/%Y %H:%M:%S", tz="GMT")
feb1 = strptime("01/02/2007 00:00:00", format="%d/%m/%Y %H:%M:%S", tz="GMT")
feb2 = strptime("02/02/2007 23:59:59", format="%d/%m/%Y %H:%M:%S", tz="GMT")
data<-data[data$datetime >= feb1 & data$datetime<= feb2, ]

#png graphics device being opened
png(filename="plot4.png", width=480, height=480)

par(mfrow=c(2,2))

# 1st plot
# type is used to define plot to be of line type
plot(data$datetime, data$Global_active_power, xlab="",
     ylab="Global Active Power", type="l")

# 2nd plot
plot(data$datetime, data$Voltage,
     xlab="datetime", ylab="Voltage", type="l")



#3rd plot
plot(data$datetime, data$Sub_metering_1, xlab="",
     ylab="Energy sub metering", type="l")
lines(data$datetime, data$Sub_metering_2, col="red")
lines(data$datetime, data$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lwd=par(""), bty="n")

#4th plot
plot(data$datetime, data$Global_reactive_power,
     xlab="datetime", ylab="Global_reactive_power", type="l")

dev.off()