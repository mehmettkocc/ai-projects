%{
Author: Mehmet Koc
Date: 2/9/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns the average log conditional likelihood
of the examples whose indices in the dataset provided (actual examples are
not passed as argument for performance reasons) using the feature weights
w and logZ.

For info on logZ, see getAlphaMatrix(...)

Ideally, one would like to see avgLCL=0. The lower is the avgLCL, the worse
is the performance of w passed as argument. So, avgLCL can be utilized to
compare the performance of various candidate models with different w using 
a validation set.
%}
function avgLCL = getLCL(exInd, w, logZ)
% get the features of the examples
F = getFeatures(exInd);

% score of the examples score = w' * F
avgLCL = mean(w' * F) - logZ;

end