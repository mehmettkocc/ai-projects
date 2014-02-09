%{
Author:
Date: 2/8/14 Updated:2/9/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns all the J features of a number of
examples whose indices (exInd) are provided. The reason for passing the indices
instead of actual x and y are for enhanced performance. Simply, make sure
dataset is loaded in workspace before calling this function and then access
them using their indices passed as argument to this function.

For example, if length(valInd)=n then it means features for these n
examples should be returned as features=[f1,f2,...,fn] where each f_i is a
column vector for the features for the i_th example.
%}
function features = getFeatures(exInd)
exNum = length(exInd);
% fLength is the number of features
features = zeros (fLength, exNum);
for i=1:exNum
    % get current x andy y from workspace
    x = X(exInd(i), :);
    y = Y(exInd(i), :);
    % compute f_i=features(:, i)
    %F(:, i) = ...    
    
end

end