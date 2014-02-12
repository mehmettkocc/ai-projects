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

The last argument isTrain indicates whether the example belongs to all
training set or test set:
isTrain=nonzero, examples must be retrieved from all training set
isTrain=zero, examples must be retrieved from test set

For example, if length(exInd)=size(Y, 2)=n then it means that features for 
these n examples should be returned as features=[f1,f2,...,fn] where each f_i is a
column vector for the features for the i_th example.
%}
function features = getFeatures2(exInd, Y, isTrain)
exNum = length(exInd);
featSize=evalin('base','featSize');
X=evalin('base','X');
% featSize is the number of features
features = zeros(featSize, exNum);

for i=1:exNum
   % get current x and y from workspace
    if (isTrain)
        x = X(exInd(i), :);
        y = Y(i, :);
    else
        x = Xtest(exInd(i), :);
        y = Y(i, :);
    end
    % compute f_i=features(:, i)
    if (length(x{1})==length(y))
        start = lowFeatures(y{1}(1),7,x,1);
        ending = lowFeatures(8,y{1}(length(x)),x,length(x));
        middle = zeros(length(x));
        % compute f_i=features(:, i)
        for i=2:(length(x{1})-1)
            middle = middle + lowFeatures(y{1}(i),y{1}(i-1),x,i);
        end
        features(:,j) = start+middle+ending;
    end
end

end