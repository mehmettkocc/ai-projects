%{
Author: Mehmet Koc
Date: 1/29/14,  Last Update:2/8/14
//////////////////////////////////////////////////////////////////////////
Description: Given a score matrix generator getScoreMatrix(...) and 
an example x and the feature weights w, infer the best scores for every 
position k=1 to n where n is the length of the sequence whose labels are to
be found. In the end, backtrack from the best score to predict the labels 
for the whole sequence. --> VITERBI'S ALGORITHM

getScoreMatrix(x, w) must be a function which has 2 arguments:
x = the example whose labels are to be found
w = the weight vector for features

getScoreMatrix(...) must return an m-by-m-by-(n-1) (m is the cardinality of 
the labels) matrix G which has n-1 G_k layers each of which corresponds to 
transition scores from y_{k-1} to y_k for k=2 to n (i.e. G_k is the 
incremental score table at position k). 

The rows of each layer G_k correspond to y_{k-1} and the columns correspond
to y_k

This function in the end returns the best score and the best sequence of 
as the same length as the input example x.
%}
function [bestScore, bestLabels] = getBestLabelSequence(getScoreMatrix, x)
n = length(x);
% get the score matrix
G = getScoreMatrix(x, w);
m = size(G, 1);
% U is the best scores available k=column index given the last label is the row index
U = zeros(m, n);
bestLabels = zeros(n, 1);
% Q is used to store the best preceding label for all labels at each step
Q = zeros(m, n-1);

for k = 2:n        
    [U(:, k), Q(:, k-1)] = max(repmat(U(:, k-1), [1, m]) + G(:, :, k-1));
end

% find the best score and last label in the best label sequence
[bestScore, bestLabels(n)] = max(U(:, n)); 

% backtrack and find the best label sequence
for k = (n-1):-1:1
   bestLabels(k) = Q(bestLabels(k+1), k); 
end

% both bestScore and bestLabels found
end