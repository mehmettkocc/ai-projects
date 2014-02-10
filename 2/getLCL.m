%{
Author: Mehmet Koc
Date: 2/9/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns the average log conditional likelihood
of the examples whose indices in the dataset provided (actual examples are
not passed as argument for performance reasons) using the feature weights
w and logZ.

The last argument isTrain indicates whether the example belongs to all
training set or test set:
isTrain=nonzero, examples must be retrieved from all training set
isTrain=zero, examples must be retrieved from test set
For info on logZ, see getAlphaMatrix(...)

Ideally, one would like to see avgLCL=0. The lower is the avgLCL, the worse
is the performance of w passed as argument. So, avgLCL can be utilized to
compare the performance of various candidate models with different w using
a validation set.
%}
function avgLCL = getLCL(exInd, w, isTrain)
% get the features of the examples
exNum = length(exInd);
F = getFeatures(exInd, isTrain);
sumLCL = 0;

for i=1:exNum
    G = getScoreMatrix(exInd(i), w, isTrain);
    [~, logZ] = getAlphaMatrix(G);
    sumLCL = sumLCL + (w' * F(:, i) - logZ);
end
% score of the examples score = w' * F
avgLCL = sumLCL/exNum;

end