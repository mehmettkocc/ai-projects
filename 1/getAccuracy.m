%{
Author: Mehmet Koc
Date: 1/18/14
Description: Computes the predicted labels and compares them to actual labels
and then computes the accuracy . feats is mxn feature matrix where m is number of
examples and n is number of features. labels is mx1 labels column vector.
beta is nx1 coefficient column vector.
%}
function accuracy = getAccuracy(feats, labels, beta)
%predicted labels are 1 or -1
predictedLabels = ones(size(labels));
for i=1:size(feats, 1)
   p = 1/(1 + exp(-feats(i, :) * beta));
   if(p < 0.5)
       predictedLabels(i) = -1;
   end
end
accuracy = sum(predictedLabels==labels)/length(labels);
end