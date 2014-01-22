%{
Author: Mehmet Koc
Date: 1/21/14
Description: Computes the log-conditional-likelihood a dataset based
on beta and getProb.m. feats is mxn feature matrix where m is number of
examples and n is number of features. labels is mx1 labels column vector
of type double where positives are 1 and negatives are -1.beta is nx1
coefficient column vector.

This function computes LCL in a different way (but a mathematically equivalent
from) than getLCL(...) not to be affected from overflow/underflow.
%}
function LCL = getLCL2(feats, labels, beta)
LCL = 0;
logisticScores = (feats * beta) .* labels;
for i = 1:length(logisticScores)
    if(logisticScores(i) < 0)
        LCL = LCL + (logisticScores(i) - log(1 + exp(logisticScores(i))));
    else
        LCL = LCL + log(1 / (1 + exp(-logisticScores(i))));
    end
end
end