% This a script for an SVM for one consumer
% script1 should give all the input arguments
% for these functions


[f_data,y, F_data,Y] = type3Fraud(H);
[maxi,maxT,mini,minT,suma,av,stdev...
, lfactor, mintoav,mintomax,night,skew,kurt,varia, X]=extractFeatures(F_data);
P=size(X,1);
% Details for Fraud
[kWh_count, time_count, kWh_rate, time_rate] = frauDetails(H, F_data);

% Normalize befo
[Xn]=normalizeFeatures(X);

% Cross-Validation
[trainidx, testidx]=crossValind(P,0.3);
% Train set
Xtrain= Xn(trainidx,:);
Ytrain= Y(trainidx);
% Test set 
Xval=Xn(testidx,:);
Yval=Y(testidx);


% Iteratively seek parameters
[C, gamma]=findSVMparams(Xtrain, Ytrain, Xval, Yval);

% Get best fitted arguments
arguments=['-t ' num2str(2) ' -g ' num2str(gamma) ' -c ' num2str(C)]; 
model=svmtrain(Ytrain,Xtrain,arguments);
prediction= svmpredict(Yval,Xval,model);

% Create confusion Matrix
[precision, recall, accuracy, F1score] = confusionMatrix (Yval, prediction);
fprintf('\n| Precision %4.2f | Recall %4.2f | Accuracy %4.2f | F1score %4.2f |\n',precision,recall,accuracy,F1score);
fprintf('| Actual %d Days | Predicted Right %d Days | kWh Rate %4.2fper | Time Rate %4.2fper |\n',sum(Yval==1),sum(prediction==1&Yval==prediction),kWh_rate,time_rate);