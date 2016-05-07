clear all;
close all;
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load the EEG data  - DO NOT SUBMIT THIS PROJECT WITH EEG DATA!
%%%
%%% Data contain EEG features extracted from 25 different people over multiple sessions 
%%% EEG data is from the Wallpaper Groups P2, PMG, P4M.  You can find out
%%% more about how the data was collected and Wallpaper Groups in the paper
%%% below:  
%%%
%%% Representation of Maximally Regular Textures in Human Visual Cortex
%%% Peter Kohler, Alasdair Clarke, Alexandra Yakovleva, Yanxi Liu and Anthony Norcia
%%% The Journal of Neuroscience: The Official Journal of the Society of Neuroscience
%%% Volume 36(3)
%%% Pages 714-729
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('eeg_data.mat')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%the flow of your code should look like this
Dim = size(eeg_data,2)-1; %dimension of the feature
countfeat(Dim,2) = 0;
%%countfeat is a Mx2 matrix that keeps track of how many times a feature has been selected, where M is the dimension of the original feature space.
%%The first column of this matrix records how many times a feature has ranked within top 1% during 100 times of feature ranking.
%%The second column of this matrix records how many times a feature was selected by forward feature selection during 100 times.

%%%%%%%%%%%%%%%%%%%% test code %%%%%
%comment this out 
tmp = randperm(Dim);
topfeatures(:,1) = tmp(1:1000)';
topfeatures(:,2) = 100*rand(1000,1);
forwardselected = tmp(1:100)';
%%%%%%%%%%%%%%%%%%%%%%%%************


for i=1:2 %cannot put many more iterations because of the huge dataset
    
    % randomly divide into train and test sets with 80%/20% split
    [TrainMat, LabelTrain, TestMat, LabelTest]= randomDivideMulti([labels,eeg_data]);

    %start feature ranking
    topfeatures = rankingfeat(TrainMat, LabelTrain); 
    countfeat(topfeatures(:,1),1) =  countfeat(topfeatures(:,1),1) +1;
    
    %% visualize the variance ratio of the top 1% features
    if i==1
        %% colorbar indicates the correspondance between the variance ratio
        %% of the selected feature
       plotFeat(topfeatures,feature_names,20);
    end

% start forward feature selection
    forwardselected = forwardselection(TrainMat, LabelTrain, topfeatures);
    countfeat(forwardselected,2) =  countfeat(forwardselected,2) +1;    
    
    % start Grouping the TrainMat and TestMat into the new Train and Test
    % Sets
    
    newTrain= zeros(951,length(forwardselected(:,1))); 
    newTest= zeros(237,length(forwardselected(:,1))); 
    
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
 mean_train= mean(Error_Train);
 mean_test=mean(Error_Test);
 
 mean_trainfull= mean(ErrorfullTrain);
 mean_testfull=mean(ErrorfullTest);
 

%% visualize the features that have ranked within top 20 (or however many you can display) most during 100 times of feature ranking
data(:,1)=[1:Dim]';
data(:,2) = countfeat(:,1);
%% colorbar indicates the number of times a feature at that location was
%% ranked within top 1%
plotFeat(data,feature_names,20);
%% visualize the features that have been selected most during 100 times of
%% forward selection
data(:,2) = countfeat(:,2);
%% colorbar indicates the number of times a feature at that location was
%% selected by forward selection
plotFeat(data,feature_names,20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class1=[];
class6=[];
class10=[];
numofsamples= size(TrainMat,1);
numoffeat= length(TrainMat(1,:));
for i=1:numofsamples
    if (LabelTrain(i,1)==1)
        class1 = [class1 ; TrainMat(i,:)];
    else if (LabelTrain(i,1)==6)
        class6 = [class6 ; TrainMat(i,:)];
    else 
        class10=[class10; TrainMat(i,:)];
        end
    end
end

%Inter-Class Variance
%VarSf = length(class0(:,1))* ((u0 - u)'* (u0- u)) + length(class1(:,1))* ((u1 - u)'*(u1 - u));
VarSf=var(TrainMat);
%IntraClassVariance 
VarSfclass6 = var(class6);
VarSfclass1 = var(class1);
VarSfclass10 = var(class10);



%Selection criterion
VR= zeros(numoffeat,1); 

for f=1: numoffeat
    num= VarSf(1,f);

    den= 1/2*(VarSfclass10(1,f) + VarSfclass1(1,f)+ VarSfclass6(1,f));
    
    VR(f,1)= num/den;
    
end

for i=1:numoffeat
    num(i,1)= i;
end

VR=[VR num]';
VRresults=VR;



figure(5)
plot(1:numoffeat,VRresults(1,:));

