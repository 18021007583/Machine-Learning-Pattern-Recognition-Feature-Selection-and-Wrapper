clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load the data
FeatureMatOD=dlmread('data/ODFeatureMat.txt');
FeatureMatHD=dlmread('data/HDFeatureMat.txt');
FeatureMat=[FeatureMatOD FeatureMatHD(:,2:end)];
clear FeatureMatHD;
clear FeatureMatOD;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%the flow of your code should look like this
Dim = size(FeatureMat,2)-1; %dimension of the feature
countfeat(Dim,2) = 0;
%%countfeat is a Mx2 matrix that keeps track of how many times a feature has been selected, where M is the dimension of the original feature space.
%%The first column of this matrix records how many times a feature has ranked within top 1% during 100 times of feature ranking.
%%The second column of this matrix records how many times a feature was selected by forward feature selection during 100 times.

%%%%%%%%%%%%%%%%%%%% test code %%%%%
%comment this out 
tmp = randperm(Dim);
sel(:,1) = tmp(1:1000)';
sel(:,2) = 100*rand(1000,1);
forwardselected = tmp(1:100)';
%%%%%%%%%%%%%%%%%%%%%%%%************


for i=1:20
    
    % randomly divide into equal test and traing sets
    [TrainMat, LabelTrain, TestMat, LabelTest]= randomDivideMulti(FeatureMat);

    % start feature ranking
    topfeatures = rankingfeat(TrainMat, LabelTrain); 
    
    countfeat(topfeatures(:,1),1) =  countfeat(topfeatures(:,1),1) +1;
    
    %% visualize the variance ratio of the top 1% features
    if i==1
        %% colorbar indicates the correspondance between the variance ratio
        %% of the selected feature
       plotFeat(topfeatures);
    end

    % start forward feature selection
    forwardselected = forwardselection(TrainMat, LabelTrain, topfeatures);
    countfeat(forwardselected,2) =  countfeat(forwardselected,2) +1;    
    
    % start Grouping the TrainMat and TestMat into the new Train and Test
    % Sets
    
    newTrain= zeros(53,length(forwardselected(:,1))); 
    newTest= zeros(51,length(forwardselected(:,1))); 
    
    for k=1:length(forwardselected(:,1));
        newTrain(:,k)= TrainMat(:,forwardselected(k,1)); 
        newTest(:,k)= TestMat(:,forwardselected(k,1));
    end

    [Error_Train(i) Error_Test(i)]= KNNtest(newTrain,LabelTrain,LabelTest,newTest);
    
    
%error rate with 15500 features  
JJT = knnclassify(TrainMat,TrainMat,LabelTrain,3);

JJ = knnclassify(TestMat,TrainMat,LabelTrain,3);
  
%Calculating the training data and test data error
h = JJT-LabelTrain;
h1 = JJ-LabelTest;
f=0;
f1=0;
for t =1:length(h)
    if h(t)==0
    f = f + 1;
    end
end
for t =1:length(h1)
    if h1(t)==0
    f1 = f1 + 1;
    end
end
ErrorfullTrain(i)= ((length(h) - f)/length(h))*100;
ErrorfullTest(i)= ((length(h1) - f1)/length(h1))*100;

end



%%% visualize the features that have ranked within top 1% most during 100 times of feature ranking
 data(:,1)=[1:Dim]';
 data(:,2) = countfeat(:,1);
% %% colorbar indicates the number of times a feature at that location was
% %% ranked within top 1%
 plotFeat(data);
% %% visualize the features that have been selected most during 100 times of
% %% forward selection
 data(:,2) = countfeat(:,2);
% %% colorbar indicates the number of times a feature at that location was
% %% selected by forward selection
 plotFeat(data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: You don't need this step for classification. This is just for the inquisitive minds who want to see how the features actually look like.
% Suppose you want to visualize 5th subject in the Test set. The following code shows how the feature of the 5'th subject would look like:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % uncomment to visualize the features
% FeatureMat=dlmread('data/HDFeatureMat.txt');
% k=reshape(TrainMat(5,:),[125 62]);
% imagesc(flipud([k fliplr(k)]));
% COLORBAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% %% CODE: Rutvij Dhotey
% %% Augmented Variance Ratio 
% 
%% Selection Criterion: Augmented Variance Ratio
% AVR and VR 
%Dividing into classes


class0=[];
class1=[];
numofsamples= size(TrainMat,1);
numoffeat= length(TrainMat(1,:));
for i=1:numofsamples
    if (LabelTrain(i,1)==0)
        class0 = [class0 ; TrainMat(i,:)];
    else
        class1 = [class1 ; TrainMat(i,:)];
    end
end

%Mean of each class
u0= mean(class0);
u1= mean(class1);

%overall mean of each feature on the TrainMat
u=mean (TrainMat);

%Inter-Class Variance
%VarSf = length(class0(:,1))* ((u0 - u)'* (u0- u)) + length(class1(:,1))* ((u1 - u)'*(u1 - u));
VarSf=var(TrainMat);
%IntraClassVariance 
VarSfclass0 = var(class0);
VarSfclass1 = var(class1);

%Selection criterion
VR= zeros(numoffeat,1); 
AVR= zeros(numoffeat,1);

for f=1: numoffeat
    num= VarSf(1,f);
    min0 = abs(u0(1,f)-u1(1,f));
    min1 = abs(u1(1,f)-u0(1,f));
    x1=VarSfclass0(1,f)/min0;
    x2=VarSfclass1(1,f)/min1;
    %minimum= min(min1,min2);
    den= 1/2*(VarSfclass0(1,f) + VarSfclass1(1,f));
    denforAVR=0.5*( x1+ x2);   
    VR(f,1)= num/den;
    AVR(f,1)=num/denforAVR;
end
   
for i=1:numoffeat
    num(i,1)= i;
end

VR=[VR num]';
AVR= [AVR num]';
VRresults=VR;
AVRresults=AVR;

% [d1 d2]= sort(VR(1,:),'descend');
% VR= [d1; d2];
% 
% 
% [d1 d2]= sort(AVR(1,:),'descend');
% AVR= [d1; d2];
% 
  figure(5)
  plot(1:numoffeat,VRresults(1,:));
% 
  figure(6)
  plot(1:numoffeat,AVRresults(1,:));

%error rate with 15500 features  
JJT = knnclassify(TrainMat,TrainMat,LabelTrain,3);

JJ = knnclassify(TestMat,TrainMat,LabelTrain,3);
  
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
ErrorfullTrain(i)= ((length(h) - f)/length(h))*100;
ErrorFullTEst(i)= ((length(h1) - f1)/length(h1))*100;

 
 mean_train= mean(Error_Train);
 mean_test=mean(Error_Test);
 
 mean_trainfull= mean(ErrorfullTrain);
 mean_testfull=mean(ErrorfullTest);
 
 