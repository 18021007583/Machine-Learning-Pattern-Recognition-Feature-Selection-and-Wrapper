function [Error] = MSE(X_temp,LabelTrain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%To calculate MSE for evaluating performance of features
%1-of-k representation of training labels
for i=1:length(LabelTrain)
    if LabelTrain(i) == 1
        train_label(i,:) = [0 1];
    else
        train_label(i,:) = [1 0];
    end
end

%JJ = knnclassify(X_temp,X_temp,LabelTrain,3);
%Calculating the weight matrix
w = (X_temp'*X_temp)\(X_temp'*train_label);
y = X_temp*w;
for i=1:length(y)
    if y(i,1)> y(i,2)
        y_new(i) = 0;
    else
        y_new(i) = 1;
    end
end
%Calculating the error
err = y_new'-LabelTrain;
f=0;
for i =1:length(err)
    if err(i)==0
    f = f + 1;
    end
end
Error = ((length(err) - f)/length(err))*100;
end





