function topfeatures = rankingfeat(TrainMat, LabelTrain)
%% input: TrainMat - a NxM matrix that contains the full list of features
%% of training data. N is the number of training samples and M is the
%% dimension of the feature. So each row of this matrix is the face
%% features of a single person.
%%        LabelTrain - a Nx1 vector of the class labels of training data

%% output: topfeatures - a Kx2 matrix that contains the information of the
%% top 1% features of the highest variance ratio. K is the number of
%% selected feature (K = ceil(M*0.01)). The first column of this matrix is
%% the index of the selected features in the original feature list. So the
%% range of topfeatures(:,1) is between 1 and M. The second column of this
%% matrix is the variance ratio of the selected features.


%% Selection Criterion: Augmented Variance Ratio / Variance Ratio
% For AVR/VR 
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

[d1 d2]= sort(VR(1,:),'descend');
VR= [d1; d2];


[d1 d2]= sort(AVR(1,:),'descend');
AVR= [d1; d2];

%  figure(5)
%  plot(1:numoffeat,VR(1,:));
% 
%  figure(6)
%  plot(1:numoffeat,AVR(1,:));

 %TOP 1% selected Feature list.
 
 selected_feat= 0.01*numoffeat;
 for i=1:selected_feat
     select (i,1)= VR(2,i);
     select (i,2)=VR(1,i);
 end
 
 topfeatures= select;
