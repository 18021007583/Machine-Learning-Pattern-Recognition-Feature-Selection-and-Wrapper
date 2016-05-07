function [Error] = MSE(X_temp,LabelTrain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%To calculate MSE for evaluating performance of features
%1-of-k representation of training labels
for i=1:length(LabelTrain)
    if LabelTrain(i) == 1
        train_label(i,:) = [1 0 0];
    else if LabelTrain(i) == 6
        train_label(i,:) = [0 1 0];
    else if  LabelTrain(i) == 10
        train_label(i,:) = [0 0 1];
        end
    end
    end
end


%Calculating the weight matrix
w = (X_temp'*X_temp)\(X_temp'*train_label);
y = X_temp*w;
for i=1:length(y)
    if y(i,1)> y(i,2)
        if (y(i,1)>y(i,3))
            y_new(i) = 1;
        else
            y_new(i) = 10;
        end
    else
        if (y(i,2)>y(i,3))
            y_new(i) = 6;
        else
            y_new(i) = 10;
        end
    end
end

err = y_new'-LabelTrain;
f=0;
for i =1:length(err)
    if err(i)==0
    f = f + 1;
    end
end
Error = ((length(err) - f)/length(err))*100;
end
