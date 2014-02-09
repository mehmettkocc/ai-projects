%{
Author: 
Date: 2/8/14
//////////////////////////////////////////////////////////////////////////
Description: getScoreMatrix(...) is a function which has 3 arguments:
x = the example to calculate a score for using w
ySet = the set of the possible labels
w = the weight vector for features

getScoreMatrix(...) returns an m-by-m-by-(n-1) (m is the cardinality of 
the labels) matrix G which has n-1 G_k layers each of which corresponds to 
transition scores from y_{k-1} to y_k for k=2 to n (i.e. G_k is the 
incremental score table at position k). 

The rows of each layer G_k correspond to y_{k-1} and the columns correspond
to y_k
%}

function G = getScoreMatrix(x, ySet, w)
% calculate m and n
m = length(ySet);
n = length(x);
G = zeros(m, m, n-1);


end