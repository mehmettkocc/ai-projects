%{
Author: Mehmet Koc
Date: 1/29/14,  Last Update:2/12/14
//////////////////////////////////////////////////////////////////////////
Description: Given a score matrix G,  infer the best labels(tags)/scores 
for every position k=1 to n where n is the length of the sequence whose 
labels are to be found. In the end, backtrack from the best score to 
predict the labels for the whole sequence. --> VITERBI'S ALGORITHM

For more info on G, read getScoreMatrix(...)

This function in the end returns the unnormalized best score and the best
sequence which is the same length as the input example x.
%}
function [bestLabels, bestScore] = getBestLabelSequence(G)
n = size(G, 3);
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