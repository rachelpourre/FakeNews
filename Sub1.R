### FIRST Submission

#gtp2

# libraries
library(tidyverse)
library(bestglm)
library(corrplot)

# get cleaned data
tidyFake <- read.csv("~/Downloads/Fake.csv")

subbing <- tidyFake[,-c(1,3,4)]
# Just top half
#corrplot(cor(plottingcor), type = "upper")

# Ideas: variable selection, logistic model

subbing$isFake <- as.factor(subbing$isFake)

mylogit <- glm(isFake ~ ., data = subbing, family = "binomial")

summary(mylogit)





# Predict
predicted <- predict.glm(mylogit, newdata = (tidyFake %>% filter(Set == "test")), type = "response")

predicted <- ifelse(predicted > 0.5, 1, 0)

fake_sub <- tidyFake %>% filter(Set == "test")

my_sub <- data_frame('id' = fake_sub$Id, 'label' = predicted)

write.table(my_sub, file = "Sub1.csv", sep = ",",row.names = FALSE, col.names=c("id", "label"))






#### 0.91153
