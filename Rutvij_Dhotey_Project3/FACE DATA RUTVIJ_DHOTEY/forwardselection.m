function forwardselected = forwardselection(TrainMat, LabelTrain, topfeatures)
%% input: TrainMat - a NxM matrix that contains the full list of features
%% of training data. N is the number of training samples and M is the
%% dimension of the feature. So each row of this matrix is the face
%% features of a single person.
%%        LabelTrain - a Nx1 vector of the class labels of training data
%%        topfeatures - a Kx2 matrix that contains the information of the
%% top 1% features of the highest variance ratio. K is the number of
%% selected feature (K = ceil(M*0.01)). The first column of this matrix is
%% the index of the selected features in the original feature list. So the
%% range of topfeatures(:,1) is between 1 and M. The second column of this
%% matrix is the variance ratio of the selected features.

%% output: forwardselected - a Px1 vector that contains the index of the 
%% selected features in the original feature list, where P is the number of
%% selected features. The range of forwardselected is between 1 and M. 


 %% Matrix Set with the selected Features: 
 
 for i=1: length(topfeatures(:,1))
     train_set(:,i)= TrainMat(:, topfeatures(i,1));
 end
 
 %% Minimum Square Error Classification and then Forward Selection
 
temp_set = train_set;
final = 100;
X_train = ones(length(LabelTrain),1); % the 0th order column
%Wrapper for forward selection of features
y=length(topfeatures);
 for i=1:length(topfeatures)
     for j=1:y
         X_temp = [X_train temp_set(:,j)];  % Training Data Set.= W= X'X\X*t
         output(j) = MSE(X_temp,LabelTrain); %Evaluation of features using MSE
     end
     [mini ind] = min(output);
     X_train = [X_train temp_set(:,ind)];
     if ind == 1
         temp_set = temp_set(:,2:end);
     elseif ind == length(train_set)
         temp_set = temp_set(:,1:length(train_set)-1);
     else
         temp_set = [temp_set(:,1:ind-1) temp_set(:,ind+1:end)];
     end
     y=y-1;
     if final > mini   %Stopping criterion.
         final = mini;
     else
         break
     end
 end
 X_train = X_train(:,2:end);
 %Forming the set of forwardselected features using the Wrapper Method
 for i=1:size(X_train,2)
     for j=1:length(topfeatures)
         if X_train(:,i) - train_set(:,j) == 0
            forwardselected(i,1) = topfeatures(j,1);
         end
     end
 end
 

