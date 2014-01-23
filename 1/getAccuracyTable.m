%{
Author: Mehmet Koc
Date: 1/23/14
Description: Computes the predicted labels and compares them to actual labels
and then computes the number of true positives (tp), false positives (fp), 
true negatives (tn) and false negatives (fn). Output is a struct named table
with fields tp, fp, tn and fn. feats is mxn feature matrix 
where m is number of examples and n is number of features. 
labels is mx1 labels column vector of type double (1 for positives and -1 for negatives).
beta is nx1 coefficient column vector.
%}
function table = getAccuracyTable(feats, labels, beta)
%predicted labels are 1 or -1
probs = 1./(1 + exp(-feats * beta));
predictedLabels = double(probs >= 0.5);
predictedLabels(~predictedLabels) = -1;
%get tp, fp, tn and fn
table.tp = sum(predictedLabels==1 & labels==1);
table.fp = sum(predictedLabels==1 & labels==-1);
table.tn = sum(predictedLabels==-1 & labels==-1);
table.fn = sum(predictedLabels==-1 & labels==1);
end