%% Create training and testing set
% Choose from every consumer sample
% No normarlization needed
N=size(X,1); % No. of observations
P=0.3; % Percent of Test
Xtrain3D=zeros(ceil((1-P)*size(X,1)),size(X,2),size(X,3));
Ytrain2D=zeros(ceil((1-P)*size(X,1)),size(X,3));
Xtest3D=zeros(floor(P*size(X,1)),size(X,2),size(X,3));
Ytest2D=zeros(floor(P*size(X,1)),size(X,3));
for i=1:size(H,3)
    [Train, Test] = crossvalind('HoldOut', N, P); %Train is ceiled, Test is floored
    % Train set
    Xtrain3D(:,:,i)= X(Train,:,i);
    Ytrain2D(:,i)= Y2D(Train,i);
    % Test set 
    Xtest3D(:,:,i)=X(Test,:,i);
    Ytest2D(:,i)=Y2D(Test,i);
end
X_train= permute(Xtrain3D,[1 3 2]);
X_train= reshape(X_train,[],size(Xtrain3D,2),1);
% [X_train, minval, maxval]=normalizeFeatures(X_train); % Normalize Training Set
Y_train=Ytrain2D(:);
X_test= permute(Xtest3D,[1 3 2]);
X_test= reshape(X_test,[],size(Xtest3D,2),1); % Normalize Test set based to these values
%[X_test]=normalizeTest(X_test, minval, maxval);
Y_test=Ytest2D(:);

fprintf('\nSegmented Training and Testing.\n');
fprintf('Program paused. Press enter to continue.\n');
pause;

%% Apply anomalyDetection
% Estimate mu sigma2
[mu sigma2] = estimateGaussian(X_train);

%  Training set 
p = multivariateGaussian(X_train, mu, sigma2);

%  Cross-validation set
pval = multivariateGaussian(X_test, mu, sigma2);

%  Find the best threshold
[epsilon F1] = selectThreshold(Y_test, pval);

fprintf('\nBest epsilon found using cross-validation: %e\n', epsilon);
fprintf('Best F1 on Cross Validation Set:  %f\n', F1);
fprintf('# Outliers found: %d\n', sum(p < epsilon));
fprintf('   (you should see a value epsilon of about 1.38e-18)\n\n');
pause
