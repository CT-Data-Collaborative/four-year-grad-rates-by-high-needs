library(dplyr)
library(datapkg)
library(tidyr)

##################################################################
#
# Processing Script for Four-Year-Grad-Rates-by-High-Needs
# Created by Jenna Daly
# On 03/22/2017
#
##################################################################

#Setup environment
sub_folders <- list.files()
data_location <- grep("High", sub_folders, value=T)
path_to_top_level <- (paste0(getwd(), "/", data_location))
path_to_raw_data <- (paste0(getwd(), "/", data_location, "/", "raw"))

all_grad_csvs <- dir(path_to_raw_data, recursive=T, pattern = "_grad") 
all_nongrad_csvs <- dir(path_to_raw_data, recursive=T, pattern = "nongrad") 

all_state_csvs <- dir(path_to_raw_data, recursive=T, pattern = "ct.csv") 
all_grad_state_csvs <- all_state_csvs[grep("_grad", all_state_csvs)]
all_nongrad_state_csvs <- all_state_csvs[grep("nongrad", all_state_csvs)]

all_grad_dist_csvs <- all_grad_csvs[!all_grad_csvs %in% all_state_csvs]
all_nongrad_dist_csvs <- all_nongrad_csvs[!all_nongrad_csvs %in% all_state_csvs]

#Grads District
four_yr_gr_grad_dist <- data.frame(stringsAsFactors = F)
four_yr_gr_grad_dist_noTrend <- grep("trend", all_grad_dist_csvs, value=T, invert=T)
for (i in 1:length(four_yr_gr_grad_dist_noTrend)) {
  current_file <- read.csv(paste0(path_to_raw_data, "/", four_yr_gr_grad_dist_noTrend[i]), stringsAsFactors=F, header=F )
  #remove first 3 rows
  current_file <- current_file[-c(1:3),]
  colnames(current_file) = current_file[1, ]
  current_file = current_file[-1, ] 
  #Remove "District Code" column if exists
  dc_col <- grep("Code", colnames(current_file), ignore.case = T, value = T)
  if (!identical(dc_col, character(0))) {
    current_file <- current_file[ , -which(names(current_file) == dc_col)]
  } 
  #Relabel columns
  names(current_file) <- gsub("Still Enrolled", "Still Enrolled After Four Years", names(current_file) )
  names(current_file) <- gsub("Graduation", "Four Year Graduation", names(current_file) )
  names(current_file) <- gsub("Four-Year", "Total", names(current_file) )
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(four_yr_gr_grad_dist_noTrend[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  four_yr_gr_grad_dist <- rbind(four_yr_gr_grad_dist, current_file)
}

#Nongrads District
four_yr_gr_nongrad_dist <- data.frame(stringsAsFactors = F)
four_yr_gr_nongrad_dist_noTrend <- grep("trend", all_nongrad_dist_csvs, value=T, invert=T)
for (i in 1:length(four_yr_gr_nongrad_dist_noTrend)) {
  current_file <- read.csv(paste0(path_to_raw_data, "/", four_yr_gr_nongrad_dist_noTrend[i]), stringsAsFactors=F, header=F )
  #remove first 3 rows
  current_file <- current_file[-c(1:3),]
  colnames(current_file) = current_file[1, ]
  current_file = current_file[-1, ] 
  #Remove "District Code" column if exists
  dc_col <- grep("Code", colnames(current_file), ignore.case = T, value = T)
  if (!identical(dc_col, character(0))) {
    current_file <- current_file[ , -which(names(current_file) == dc_col)]
  }   
  #Relabel columns
  names(current_file) <- gsub("Still Enrolled", "Still Enrolled After Four Years", names(current_file) )
  names(current_file) <- gsub("Graduation", "Four Year Graduation", names(current_file) )
  names(current_file) <- gsub("Four-Year", "Total", names(current_file) )
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(four_yr_gr_nongrad_dist_noTrend[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  four_yr_gr_nongrad_dist <- rbind(four_yr_gr_nongrad_dist, current_file)
}

#Grads State
four_yr_gr_grad_state <- data.frame(stringsAsFactors = F)
four_yr_gr_grad_state_noTrend <- grep("trend", all_grad_state_csvs, value=T, invert=T)
for (i in 1:length(four_yr_gr_grad_state_noTrend)) {
  current_file <- read.csv(paste0(path_to_raw_data, "/", four_yr_gr_grad_state_noTrend[i]), stringsAsFactors=F, header=F )
  current_file <- current_file[-c(1:3),]
  colnames(current_file) = current_file[1, ]
  current_file = current_file[-1, ] 
  rownames(current_file) <- NULL
  #Remove "District Code" column if exists
  dc_col <- grep("Code", colnames(current_file), ignore.case = T, value = T)
  if (!identical(dc_col, character(0))) {
    current_file <- current_file[ , -which(names(current_file) == dc_col)]
  } 
  #Relabel columns
  names(current_file) <- gsub("Still Enrolled", "Still Enrolled After Four Years", names(current_file) )
  names(current_file) <- gsub("Graduation", "Four Year Graduation", names(current_file) )
  names(current_file) <- gsub("Four-Year", "Total", names(current_file) )
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(four_yr_gr_grad_state_noTrend[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  four_yr_gr_grad_state <- rbind(four_yr_gr_grad_state, current_file)
}

#Nongrads State
four_yr_gr_nongrad_state <- data.frame(stringsAsFactors = F)
four_yr_gr_nongrad_state_noTrend <- grep("trend", all_nongrad_state_csvs, value=T, invert=T)
for (i in 1:length(four_yr_gr_nongrad_state_noTrend)) {
  current_file <- read.csv(paste0(path_to_raw_data, "/", four_yr_gr_nongrad_state_noTrend[i]), stringsAsFactors=F, header=F )
  current_file <- current_file[-c(1:3),]
  colnames(current_file) = current_file[1, ]
  current_file = current_file[-1, ] 
  rownames(current_file) <- NULL
  #Remove "District Code" column if exists
  dc_col <- grep("Code", colnames(current_file), ignore.case = T, value = T)
  if (!identical(dc_col, character(0))) {
    current_file <- current_file[ , -which(names(current_file) == dc_col)]
  } 
  #Relabel columns
  names(current_file) <- gsub("Still Enrolled", "Still Enrolled After Four Years", names(current_file) )
  names(current_file) <- gsub("Graduation", "Four Year Graduation", names(current_file) )
  names(current_file) <- gsub("Four-Year", "Total", names(current_file) )
  get_year <- as.numeric(substr(unique(unlist(gsub("[^0-9]", "", unlist(four_yr_gr_nongrad_state_noTrend[i])), "")), 1, 4))
  get_year <- paste0(get_year, "-", get_year + 1) 
  current_file$Year <- get_year
  four_yr_gr_nongrad_state <- rbind(four_yr_gr_nongrad_state, current_file)
}

#Combine district and state
#rename Organization column in state data
names(four_yr_gr_grad_state)[names(four_yr_gr_grad_state)=="Organization"] <- "District"
names(four_yr_gr_nongrad_state)[names(four_yr_gr_nongrad_state)=="Organization"] <- "District"

#set District column to CT
four_yr_gr_grad_state$District <- "Connecticut"
four_yr_gr_nongrad_state$District <- "Connecticut"

#create grad and nongrad data
four_yr_gr_grad <- rbind(four_yr_gr_grad_dist, four_yr_gr_grad_state)
four_yr_gr_nongrad <- rbind(four_yr_gr_nongrad_dist, four_yr_gr_nongrad_state)

#####################################################################################################################################
#merge grad and nongrad
four_yr_gr <- merge(four_yr_gr_grad, four_yr_gr_nongrad, by = c("District", "High Needs Status", "Total Cohort Count", "Year"))

#backfill Districts
district_dp_URL <- 'https://raw.githubusercontent.com/CT-Data-Collaborative/ct-school-district-list/master/datapackage.json'
district_dp <- datapkg_read(path = district_dp_URL)
districts <- (district_dp$data[[1]])

four_yr_gr_fips <- merge(four_yr_gr, districts, by.x = "District", by.y = "District", all=T)

four_yr_gr_fips$District <- NULL

four_yr_gr_fips<-four_yr_gr_fips[!duplicated(four_yr_gr_fips), ]

#backfill year
years <- c("2010-2011",
           "2011-2012",
           "2012-2013",
           "2013-2014",
           "2014-2015", 
           "2015-2016", 
           "2016-2017",
           "2017-2018",
           "2018-2019")

backfill_years <- expand.grid(
  `FixedDistrict` = unique(districts$`FixedDistrict`),
  `High Needs Status` = unique(four_yr_gr$`High Needs Status`),
  `Year` = years
)

backfill_years$FixedDistrict <- as.character(backfill_years$FixedDistrict)
backfill_years$Year <- as.character(backfill_years$Year)

backfill_years <- arrange(backfill_years, FixedDistrict)

complete_four_yr_gr <- merge(four_yr_gr_fips, backfill_years, all=T)

#remove duplicated Year rows
complete_four_yr_gr <- complete_four_yr_gr[!with(complete_four_yr_gr, is.na(complete_four_yr_gr$Year)),]

#remove duplicated Category rows
complete_four_yr_gr <- complete_four_yr_gr[!with(complete_four_yr_gr, is.na(complete_four_yr_gr$`High Needs Status`)),]

#wide to long
complete_four_yr_gr_long <- gather(complete_four_yr_gr, Variable, Value, 4:10)

#Rename FixedDistrict to District
names(complete_four_yr_gr_long)[names(complete_four_yr_gr_long) == 'FixedDistrict'] <- 'District'

#reorder columns and remove ID column
complete_four_yr_gr_long <- complete_four_yr_gr_long[order(complete_four_yr_gr_long$District, complete_four_yr_gr_long$Year),]

#setup Measure Type column based on Variable column
complete_four_yr_gr_long$"Measure Type" <- NA
complete_four_yr_gr_long$"Measure Type"[which(complete_four_yr_gr_long$Variable %in% c("Total Cohort Count",                   
                                                                                       "Four Year Graduation Count",            
                                                                                       "Still Enrolled After Four Years Count",
                                                                                       "Other Count" ))] <- "Number" 
complete_four_yr_gr_long$"Measure Type"[which(complete_four_yr_gr_long$Variable %in% c("Four Year Graduation Rate",  
                                                                                       "Still Enrolled After Four Years Rate", 
                                                                                       "Other Rate" ))] <- "Percent" 

#return blank in FIPS if not reported
complete_four_yr_gr_long$FIPS <- as.character(complete_four_yr_gr_long$FIPS)
complete_four_yr_gr_long[["FIPS"]][is.na(complete_four_yr_gr_long[["FIPS"]])] <- ""

#recode missing data with -6666
complete_four_yr_gr_long$Value[is.na(complete_four_yr_gr_long$Value)] <- -6666

#recode suppressed data with -9999
complete_four_yr_gr_long$Value[complete_four_yr_gr_long$Value == "*"]<- -9999

#recode not applicable with -6666
complete_four_yr_gr_long$Value[complete_four_yr_gr_long$Value == "N/A"]<- -6666

complete_four_yr_gr_long$Value <- as.numeric(complete_four_yr_gr_long$Value)

#Order columns
complete_four_yr_gr_long <- complete_four_yr_gr_long %>% 
  select(`District`, `FIPS`, `Year`, `High Needs Status`, `Variable`, `Measure Type`, `Value`) %>% 
  arrange(desc(Value))

#Use this to find if there are any duplicate entries for a given district
test <- complete_four_yr_gr_long[,c("District", "Year", "High Needs Status", "Variable")]
test2<-test[duplicated(test), ]

#Write CSV
write.table(
  complete_four_yr_gr_long,
  file.path(path_to_top_level, "data", "four_year_grad_rate_by_high_needs_2011-2019.csv"),
  sep = ",",
  row.names = F
)
