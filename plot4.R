# This plot1.R script is developed according to the JHU DS Exploratiry Data Analysis Course Project No. 1 Assignment
# The script creates plot1.png files.

# The source file is household_power_consumption.txt. This file is supposed to be in the working directory.
# The data in the source file are ordered by date and time.
# To fulfil the assignment and reduce the data frame size, it is enough to load the observations 
# made between the dates 2007-02-01 and 2007-02-02.  we should select the proper observations.
# The first observation dated with 2007-02-01 is in line 66638, the date looks like 1/2/2007.
# The last observation dated with 2007-02-02 is in line 69517, the date looks like 2/2/2007
# We should read (69517-66638+1) observations: set nrows = (69517-66638+1)
# We shold skip (66638-1) observations and the header: set skip = (66638-1), header = FALSE
# We construct col.names manually.
# The separator is ";": use read.csv2, to download the data frame from the source.
# NAs are represented with "?": set na.strings = "?"
# Decimal delimeter is ".": set dec = "."


                # --- Load libraries, to transform the data; check the data set availability  

if (!require(dplyr)){
        stop(paste
             ("The script requires dplyr package installed.",
             "Please install this package into your system.",
             'You may want to run install.packages("dplyr"),',
             "to load the package.",
             "The script stops.",
             sep = "\n"
             )
        )
}

if (!require(lubridate)){
        stop(paste
             ("The script requires lubridate  package installed.",
             "Please install this package into your system.",
             'You may want to run install.packages("lubridate"),',
             "to load the package.",
             "The script stops.",
             sep = "\n"
             )
        )
}


if(!file.exists("household_power_consumption.txt")){
        stop(   paste("The working directory does not contain household_power_consumption.txt file. ",
                      "Please copy household_power_consumption.txt into your working directory. ",
                      "The script stopped.", sep = "\n"))
        
}

        
                # --- Data set preparation (commonly shared among plot1.R -- Plot4.R) ---
                # 1. Define a vector of the data frame column names
                # 2. Load the data frame
                # 3. Convert the data frame into dplyr tbl_df 
                # 5. Convert Date and Time variables to proper date and time format
                # 4. Remove the data frame no longer needed

col.names       <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                     "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

df.consumption  <- read.csv2("household_power_consumption.txt", stringsAsFactors = FALSE, 
                           col.names = col.names, header = FALSE, na.strings = "?", 
                           dec = ".", nrows = (69517-66638+1), skip = (66638-1))

tbl.consumption <- tbl_df(df.consumption)
tbl.consumption <- mutate(tbl.consumption, Date = dmy(Date), Time = hms(Time))

rm("df.consumption")


                # --- Create a png file with the plot
                # Open png device, to write the plot

png(filename = "plot4.png")


                # Draw the plot

par(mfrow = c(2, 2), mar = c(4, 4, 3, 1), oma = c(0, 0, 2, 0))

with(tbl.consumption,{
        
        
        plot(Date+Time, Global_active_power, type = "l", lwd = 1,
             ylab = "Global Active Power", xlab = "" )
        
        
        plot(Date+Time, Voltage, type = "l", lwd = 1,
             ylab = "Voltage", xlab = "datetime" )
        
        
        plot(Date+Time, Sub_metering_1, type = "l", lwd = 1,
                                   ylab = "Energy sub metering", xlab = "")
        lines(Date+Time, Sub_metering_2, type = "l", lwd = 1,
                                    col = "red")
        lines(Date+Time, Sub_metering_3, type = "l", lwd = 1,
                                    col = "blue")
        legend("topright",   col = c("black", "red", "blue"), lty = c(1,1,1),
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))        
        
        
        plot(Date+Time, Global_reactive_power, type = "l", lwd = 1,
             ylab = "Global_reactive_power", xlab = "datetime" )
})


                # Close png device

dev.off()
