%{
Author:
Date: 2/8/14 Updated:2/9/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns all the J features of a number of
examples whose indices (exInd) in the dataset and labels Y are provided. 
The reason for passing the indices instead of actual x is for enhanced 
performance. Simply, make sure dataset is loaded in workspace before calling
this function and then access x using exInd passed as argument to this function.
Y is alrady provided as the second argument. For i_th example label
sequence, use y = Y(i, :)

For example, if length(exInd)=size(Y, 2)=n then it means that features for 
these n examples should be returned as features=[f1,f2,...,fn] where each f_i is a
column vector for the features for the i_th example.
%}
function features = getFeatures2(exInd, Y)
exNum = length(exInd);
featNum = size(X, 2);
features = zeros(featNum, exNum);
for i=1:exNum
   x = X(exInd, :);
   y = Y(i, :);
   % do the rest
end

end