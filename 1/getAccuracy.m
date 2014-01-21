%{
Author: Mehmet Koc
Date: 1/18/14
Description: Computes the predicted labels and compares them to actual labels
and then computes the accuracy . feats is mxn feature matrix where m is number of
examples and n is number of features. labels is mx1 labels column vector of 
type double (1 for positives and -1 for negatives). beta is nx1 coefficient 
column vector.
%}
function accuracy = getAccuracy(feats, labels, beta)
%predicted labels are 1 or -1
probs = 1./(1 + exp(-feats * beta));
predictedLabels = double(probs >= 0.5);
predictedLabels(~predictedLabels) = -1;
accuracy = sum(predictedLabels==labels)/length(labels);
end