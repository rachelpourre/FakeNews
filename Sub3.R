### FIRST Submission

# libraries
library(tidyverse)
library(bestglm) # for stepwise methods
library(glmnet) # for ridge, lasso, and elastic net
library(corrplot)


#library(randomForest)
#set.seed(12345)
#RF_model = randomForest(isFake ~ ., data = subbing)
#predictRF = predict(RF_model, newdata=testSparse)


### Trying this out
## gtp2
# https://blogs.rstudio.com/ai/posts/2020-07-30-state-of-the-art-nlp-models-from-r/#data-preparation
# http://www.sthda.com/english/articles/36-classification-methods-essentials/150-stepwise-logistic-regression-essentials-in-r/
# conclusion: try in python instead of R
# reticulate::py_install('transformers', pip = TRUE)
# 
# library(keras)
# library(tensorflow)
# library(dplyr)
# library(tfdatasets)
# 
# transformer = reticulate::import('transformers')
# 
# physical_devices = tf$config$list_physical_devices('GPU')
# tf$config$experimental$set_memory_growth(physical_devices[[1]],TRUE)
# 
# tf$keras$backend$set_floatx('float32')
# 
# 
# # get Tokenizer
# transformer$RobertaTokenizer$from_pretrained('roberta-base', do_lower_case=TRUE)
# 
# # get Model with weights
# transformer$TFRobertaModel$from_pretrained('roberta-base')



# Probably works, but it takes too long to run. 
# 
# 
# # get cleaned data
# tidyFake <- read.csv("~/Downloads/Fake.csv")
# 
# subbing <- tidyFake[,-c(1,3,4)]
# subbing$isFake <- as.factor(subbing$isFake)
# 
# mylogit <- glm(isFake ~ ., data = subbing, family = "binomial")
# 
# summary(mylogit)
# 
# coef(full.model)
# 
# 
# # do a step-wise variable selection
# 
# library(MASS)
# 
# step.model <- mylogit %>% stepAIC(trace = FALSE)
# 
# coef(step.model)
#

tidyFake <- read.csv("~/Downloads/Fake.csv")

original <- tidyFake

tidyFake <- tidyFake %>% filter(Set == "train")
fake_x <-  as.matrix(tidyFake[, -c(1:4)])
fake_y <- tidyFake[, 2]

net_ <- cv.glmnet(x = fake_x,
                  y = fake_y,
                  family = "binomial",
                  type.measure = "mse",
                  alpha = 0.5) # 1 is LASSO, 0 is ridge, 0.5 is elastic net



# Predict
fake_x_test <- original %>% filter(Set == "test")
fake_x_test <-  as.matrix(fake_x_test[, -c(1:4)])

predicted <- predict(net_,
                     newx = fake_x_test,
                     type = "response")

predicted <- ifelse(predicted > 0.5, 1, 0)

fake_sub <- original %>% filter(Set == "test")

my_sub <- data_frame('id' = fake_sub$Id, 'label' = predicted)

write.table(my_sub, file = "Sub3.csv", sep = ",",row.names = FALSE, col.names=c("id", "label"))





#### 0.95512

