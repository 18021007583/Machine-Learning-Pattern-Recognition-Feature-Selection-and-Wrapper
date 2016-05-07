function  [Error_train,Error_test]=KNNtest(newTrain,LabelTrain,LabelTest,newTest)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


JJ = knnclassify(newTest,newTrain,LabelTrain,3);

JJT = knnclassify(newTrain,newTrain,LabelTrain,3);

newTrain= [ones(length(LabelTrain(:,1)),1) newTrain];
newTest= [ones(length(LabelTest(:,1)),1) newTest];

%Calculating the training data and test data error
h = JJT-LabelTrain;
h1 = JJ-LabelTest;
f=0;
f1=0;
for i =1:length(h)
    if h(i)==0
    f = f + 1;
    end
end
for i =1:length(h1)
    if h1(i)==0
    f1 = f1 + 1;
    end
end
Error_train= ((length(h) - f)/length(h))*100;
Error_test= ((length(h1) - f1)/length(h1))*100;
end

