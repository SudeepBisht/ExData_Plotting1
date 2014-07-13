
file <- "exdata-data-household_power_consumption.zip" 

#a check to see if file exists
# funtion read from R help
if (!file.exists(file)) 
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
  file)
  
  
}
unz(file,"household_power_consumption.txt")
#check if file present in the working directory in my laptop it was giving problem sometimes so i had to manually unzip it

wd<-paste(getwd(),"household_power_consumption.txt",sep="/")

#https://www.zoology.ubc.ca/~schluter/R/data/ the link from where the na.strings ColClasses and stringAsFactors argument was read
#colClasses used to change the data type of each column individually and StringAsFactor=F used
#to stop automatic conversion of data type to facors
data<- read.csv(file<- wd, sep=";", stringsAsFactors=F,
                na.strings=c("NA","?"),header=T,
                colClasses=c("character", "character", "numeric","numeric",
                             "numeric", "numeric","numeric", "numeric",
                             "numeric"
                             )
                )

data$Date = as.Date(data$Date, "%d/%m/%y")
feb1 <-as.Date("01/02/2007", "%d/%m/%y")
feb2 <- as.Date("02/02/2007","%d/%m/%y")

#condition of selecting data from 1st feb 2007 to 2nd feb 2007
#NOTE:if end comma is removed an error of undefined columns selected occurs
data <-data[data$Date >= feb1 & data$Date <= feb2 , ]

#plot is created and stored in a png file

png(filename="plot1.png", width=480, height=480)
hist(data$Global_active_power, main="Global Active Power",
     xlab="Global Active Power (kilowatts)", col="red")
dev.off()


