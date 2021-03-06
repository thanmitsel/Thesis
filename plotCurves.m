function plotCurves(X,Y, IDs, fraud_rate,thresh)
% This funstion is used to plot ROC curves
% X and Y should be matrices 
% X coordinate is FPR-inverse recall
% Y coordinate is DR-recall

%reference
x=1:1:100;
y=x;
plot(x,y,'color','b'); hold on;

plot(X(:,1),Y(:,1),'color', 'r'); hold on;
plot(X(:,2),Y(:,2),'color','m'); hold on;
plot(X(:,3),Y(:,3),'color','g');

min_t=min(thresh);
max_t=max(thresh);
str = sprintf('ROC curve: %d IDs\n %4.2f Fraud rate, %d-%d threshold',IDs, fraud_rate, min_t, max_t);
title(str);
xlabel('False Positive Rate');
ylabel('Detection Rate');

legend('Reference','High Intrusion 80%');%, 'Medium Intrusion 50%');%,'Low Intrusion 20%');
end