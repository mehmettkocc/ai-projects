%{
Author: Mehmet Koc
Date: 1/29/14
//////////////////////////////////////////////////////////////////////////
Description: Given a score matrix generator getCurrentScoreMatrix(...) and 
an example x, infer the best scores for every position k=1 to n where n is 
the length of the sequence whose labels are to be found. In the end, backtrack
from the best score to predict the labels for the whole sequence. --> VITERBI'S ALGORITHM

getCurrentScoreMatrix(x, k) must be  a function which has 2 arguments:
x = the example whose labels are to be found
k = the current position k

getCurrentScoreMatrix(...) must return an m-by-m (m is the cardinality of 
the labels) matrix Gk for k=2 to n which is the incremental score table 
at position k. It must return only a m-by-1 column vector for k=1. 
The rows of Gk correspond to y_{k-1} and the columns correspond to y_k

This function in the end returns the best score and the best sequence of 
as the same length as the input example x.
%}
function [bestScore, bestLabels] = getBestLabelSequence(getCurrentScoreMatrix, x)

n = length(x);
% get the starting score column vector
g1 = getCurrentScoreMatrix(x, 1);
m = length(g1);
% U is the best scores available at the column index given last label is the row index
U = [g1; zeros(m, n-1)];
bestLabels = zeros(n, 1);
% Q is used to store the best preceding label for all labels at each step
Q = zeros(m, n-1);

for k = 2:n
    Gk = getCurrentScoreMatrix(x, k);
    temp = repmat(U(:, k-1), [1, m]);
    [U(:, k), Q(:, k-1)] = max(temp + Gk);
end

% find the best score and last label in the best label sequence
[bestScore, bestLabels(n)] = max(U(:, n)); 

% backtrack and find the best label sequence
for k = (n-1):-1:1
   bestLabels(k) = Q(bestLabels(k+1), k); 
end

% both bestScore and bestLabels found
end