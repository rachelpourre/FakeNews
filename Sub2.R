### SECOND Submission

#gtp2

# libraries
library(tidyverse)
library(bestglm)
library(corrplot)
library(glmnet)

# get cleaned data
tidyFake <- read.csv("~/Downloads/Fake.csv")

original <- tidyFake

#tidyFake <- tidyFake[,-c(1,3,4)]

# Ideas: variable selection, logistic model

tidyFake <- tidyFake %>% filter(Set == "train")
fake_x <-  as.matrix(tidyFake[, -c(1:4)])
fake_y <- tidyFake[, 2]

# use cross validation to pick the "best" lambda, based on MSE

net_ <- cv.glmnet(x = fake_x,
                          y = fake_y,
                          type.measure = "mse",
                          alpha = 1) # 1 is LASSO, 0 is ridge, 0.5 is elastic net


#net_$lambda.min
# Lambda.lse: value of lambda within 1 standard error of the minimum cross-validated error
lambda <- net_$lambda.1se

#coef(net_, s = "lambda.min")
#coef(net_, s = "lambda.1se")

fake_x_test <- original %>% filter(Set == "test")
fake_x_test <-  as.matrix(fake_x_test[, -c(1:4)])

predicted <- predict(net_, s = lambda, 
                     newx = fake_x_test,
                     type = "response")

predicted <- ifelse(predicted > 0.5, 1, 0)

fake_sub <- original %>% filter(Set == "test")

my_sub <- data_frame('id' = fake_sub$Id, 'label' = predicted)

write.table(my_sub, file = "Sub2.csv", sep = ",",row.names = FALSE, col.names=c("id", "label"))






#### 0.92435


