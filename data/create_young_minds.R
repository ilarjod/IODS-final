library("dplyr")

# got the data from https://www.kaggle.com/miroslavsabo/young-people-survey 
# there's some empty datapoints in addition to NA's

youngpeople <- read.table("responses.csv", sep = ",",header = TRUE, na.strings="")


# flip some positive thinking variables around to be added with the depressed thinking / anxiety variables
# put them together by averaging
youngpeople <- mutate(youngpeople, happiness = abs(Happiness.in.life-6))
youngpeople <- mutate(youngpeople, energy = abs(Energy.levels-6))
youngpeople <- mutate(youngpeople, pers = abs(Personality-6))
youngpeople <- mutate(youngpeople, social = abs(Socializing-6))

# create a new variable about depressed thinking
depressed_thinking <- c("Self.criticism", "Hypochondria", "Loneliness", "Changing.the.past","Life.struggles","Getting.up", "happiness", "energy", "pers", "social")
depressed_columns <- dplyr::select(youngpeople, one_of(depressed_thinking))
youngpeople$depression <- rowMeans(depressed_columns)

# put the sports variables together
sports <- c("Passive.sport", "Active.sport")
sports_columns <- select(youngpeople, one_of(sports))
youngpeople$sports <- rowMeans(sports_columns)

# calculate the BMI of the slovakians 
youngpeople <- mutate(youngpeople, BMI = (Weight / ((Height / 100)^2)))

# categorical variable for depressed people
youngpeople <- mutate(youngpeople, Depressed = depression > 3.3)

# choose the variables to keep
# included all music and movie variables, dancing, sports, healthy.eating, age, gender, depression and BMI 
colnames(youngpeople)

young_minds <- select(youngpeople, c(141, 145, 157, 155, 158, 156, 76, 51, 1:31))
colnames(young_minds)

# filter out all rows with NA values
young_minds_ <- filter(young_minds, complete.cases(young_minds)==TRUE)

# edit the column names
colnames(young_minds_) <- c("Age",
                            "Gender",
                            "BMI",
                            "Depression", 
                            "Depressed",
                            "Sports",
                            "Healthy_eating", 
                            "Dancing",
                            "Music", 
                            "Slow_vs_Fast", 
                            "Dance" , 
                            "Folk" , 
                            "Country", 
                            "Classical",  
                            "Musical", 
                            "Pop", 
                            "Rock", 
                            "Metal_Hardrock" , 
                            "Punk", 
                            "Hiphop_Rap",
                            "Reggae_Ska" , 
                            "Swing_Jazz", 
                            "Rocknroll", 
                            "Alternative", 
                            "Latino", 
                            "Techno_Trance", 
                            "Opera", 
                            "Movies", 
                            "Horror", 
                            "Thriller", 
                            "Comedy",  
                            "Romantic", 
                            "Sci-fi",
                            "War",  
                            "Tales", 
                            "Animated", 
                            "Documentary", 
                            "Western", 
                            "Action")

# save the data
write.table(young_minds_, "young_minds.txt")
