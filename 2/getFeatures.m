%{
Author:
Date: 2/8/14 Updated:2/9/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns all the J features of a number of
examples whose indices (exInd) are provided. The reason for passing the indices
instead of actual x and y are for enhanced performance. Simply, make sure
dataset is loaded in workspace before calling this function and then access
them using their indices passed as argument to this function.

The second argument isTrain indicates whether the example belongs to all
training set or test set:
isTrain=nonzero, examples must be retrieved from all training set
isTrain=zero, examples must be retrieved from test set

For example, if length(exInd)=n then it means features for these n
examples should be returned as features=[f1,f2,...,fn] where each f_i is a
column vector for the features for the i_th example.
%}
function features = getFeatures(exInd, isTrain, featSize, X, Y)
exNum = length(exInd);
% featSize is the number of features
features = zeros (featSize, exNum);

for j=1:exNum
    % get current x andy y from workspace
    if (isTrain)
        x = X(exInd(j), :);
        y = Y(exInd(j), :);
    else
        x = Xtest(exInd(j), :);
        y = Ytest(exInd(j), :);
    end
    start = lowFeatures(y(1),7,x,1);
    ending = lowFeatures(8,y(length(x)),x,length(x));
    middle = zeros(length(x));
    % compute f_i=features(:, i)
    for i=2:length(x)-1
        middle = middle + lowFeatures(y(i),y(i-1),x,i);
    end
    f(:,j) = start+middle+ending;
end
end