%{
Author: 
Date: 2/8/14
//////////////////////////////////////////////////////////////////////////
Description: getScoreMatrix(...) is a function which has 3 arguments:
ind = the index of the example to calculate a score for using w. The actual
example can be retrieved from the workspace by X(ind, :) or Xtest(ind, :)
depending on isTrain
w = the Jx1 weight vector for features
isTrain = if the example belongs to the all training set, put a nonzero
value. if the example belongs to the test set, pass isTrain=0

getScoreMatrix(...) returns an m-by-m-by-(n-1) (m is the number of all 
possible labels) matrix G which has n-1 G_k layers each of which corresponds to 
transition scores from y_{k} to y_{k+1} for k=1 to n-1 (i.e. G_k is the 
incremental score table at position k). Note that G_1 includes the effect
of the START tag and G_{n-1} includes the effect of the STOP tag (START and
STOP are tags indicating the start and end of the sequence).

The rows of each layer G_k correspond to y_{k} and the columns correspond
to y_{k+1}
%}

function G = getScoreMatrix(ind, w, isTrain)
% get the following variables from the base workspace
ySet=evalin('base','ySet');
X=evalin('base','X');
Xtest=evalin('base','Xtest');

% retrieve the example from the relevant dataset
if (isTrain)
    x = X(ind, :);
else
    x = Xtest(ind, :);
end

% calculate m and n
m = length(ySet);
n = length(x{1});
G = zeros(m, m, n-1);

% G_k is the current layer of G
G_k = zeros(m, m);
for k = 1:n-1
    for i = 1:m
        for j = 1:m
            G_k(i,j) = sum(w.*lowFeatures(i,j,x,k));
        end
    end
    G(:, :, k) = G_k;
end


end