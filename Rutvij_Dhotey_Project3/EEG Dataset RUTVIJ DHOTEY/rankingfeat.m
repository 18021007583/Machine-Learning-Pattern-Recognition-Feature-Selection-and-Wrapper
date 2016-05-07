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


%% Selection Criteria and Variance Ratio

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

VR(isnan(VR))= 0;

for i=1:numoffeat
    num(i,1)= i;
end

VR=[VR num]';
VRresults=VR;

[d1 d2]= sort(VR(1,:),'descend');
VR= [d1; d2];

selected_feat= 0.01*numoffeat;
 for i=1:selected_feat
     select (i,1)= VR(2,i);
     select (i,2)=VR(1,i);
 end
 
 topfeatures= select;

