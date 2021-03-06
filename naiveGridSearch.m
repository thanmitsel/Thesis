function [C, gamma] = naiveGridSearch (X,Y,K)
% X must NOT be normalized, cause i ll normalize it later
% Grid Search on C and gamma using cross-validation
C_test=[2^(-5) 2^(-3) 2^(-1) 2^(1) 2^(3)...
    2^(5) 2^(7) 2^(9) 2^(11) 2^(13) 2^(15)];
gamma_test=[2^(-15) 2^(-13) 2^(-11) 2^(-9)...
    2^(-7) 2^(-5) 2^(-3) 2^(-1) 2^(1) 2^(3)];

min=10000;
for i=1:length(C_test)
  for j=1:length(gamma_test)
        gamma_temp=gamma_test(j);
        C_temp=C_test(i);
        indices=crossvalind('Kfold',size(X,1),K);
        error=0;
        for folds=1:K
            Xval3D=X(indices==folds,:,:);
            Yval2D=Y(indices==folds,:);
            Xtrain3D=X(indices~=folds,:,:);
            Ytrain2D=Y(indices~=folds,:,:);   
            
            Xtrain= permute(Xtrain3D,[1 3 2]);
            Xtrain= reshape(Xtrain,[],size(Xtrain3D,2),1);
            [Xtrain, minval, maxval]=normalizeFeatures(Xtrain); % Normalize Training Set
            Ytrain=Ytrain2D(:);
            Xval= permute(Xval3D,[1 3 2]);
            Xval= reshape(Xval,[],size(Xval3D,2),1); 
            [Xval]=normalizeTest(Xval, minval, maxval); % Normalize Test set based to these values
            Yval=Yval2D(:);
            
            arguments=['-t ' num2str(2) ' -g ' num2str(gamma_temp) ' -c ' num2str(C_temp)]; 
            model=svmtrain(Ytrain,Xtrain,arguments);
            predictions= svmpredict(Yval,Xval,model);
            temp_err=mean(double(predictions~= Yval));
            error=error+temp_err;
        end
        error=error/K; % mean of error on crossvalidation
        if (error < min)
            min=error;
            C=C_test(i);
            gamma=gamma_test(j);
        end

  end
end
end
