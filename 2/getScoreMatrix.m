%{
Author: 
Date: 2/8/14
//////////////////////////////////////////////////////////////////////////
Description: getScoreMatrix(...) is a function which has 3 arguments:
ind = the index of the example to calculate a score for using w. The actual
example can be retrieved from the workspace by X(ind, :)
w = the weight vector for features
isTrain = if the example belongs to the all training set, put a nonzero
value. if the example belongs to the test set, pass 0

getScoreMatrix(...) returns an m-by-m-by-(n-1) (m is the number of all 
possible labels) matrix G which has n-1 G_k layers each of which corresponds to 
transition scores from y_{k-1} to y_k for k=2 to n (i.e. G_k is the 
incremental score table at position k). 

The rows of each layer G_k correspond to y_{k-1} and the columns correspond
to y_k
%}

function G = getScoreMatrix(ind, w, isTrain)
% get the example from the relevant dataset
if (isTrain)
    x = X(ind, :);
else
    x = Xtest(ind, :);
end
% calculate m and n
m = length(ySet);
n = length(x);
G = zeros(m, m, n-1);
gi = zeros(m, m);
sum = 0;

for k = 1:n-1
    for i = 1:m
        for j = 1:m
            gi(i,j) = sum(w.*lowFeatures(ySet(i),ySet(j),x,k));
        end
    end
    G(:,:,k) = gi;
end
end