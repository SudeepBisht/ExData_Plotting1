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

# Creating the plot
png(filename="plot2.png", width=480, height=480)

# plot is created and stored in a png file
# type is used to define plot to be of line type
plot(data$datetime, data$Global_active_power, xlab="",
     ylab="Global Active Power (kilowatts)",type="l")
dev.off()