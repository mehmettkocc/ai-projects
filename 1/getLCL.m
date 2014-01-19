%{
Author: Mehmet Koc
Date: 1/18/14
Description: Computes the log-conditional-likelihood a dataset based
on beta and getProb.m. feats is mxn feature matrix where m is number of
examples and n is number of features. labels is mx1 labels column vector.
beta is nx1 coefficient column vector.
%}
function LCL = getLCL(feats, labels, beta)
LCL = 0;
for i=1:size(feats, 1)
   p = getProb(feats(i, :)', labels(i), beta);
   LCL = LCL + log(p);
end
end