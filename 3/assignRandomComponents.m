%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: Given the SPARSE M-by-V bag-of-word representation for all 
documents in the corpus and the number of components K in the mixture, this
function assigns random components from the set {1, 2, ..., K} to each word
of each document stochastically.

Since bowMatrix is expected to be highly sparse, this function assumes 
sparse bowMatrix and is optimized considering this fact.

The return variables are:
1. components: M-by-V cell in which the cell entry @(x, y) is a L-by-1 
vector where L = bowMatrix(x, y) (i.e. the number of appearances of 
word y in document x)
2. Nmatrix: M-by-K matrix whose (m, k) entry gives the number of words 
which have been assigned to component k in document m
3. Qmatrix: K-by-V matrix whose (k, v) entry gives the count of word v in 
the vocabulary with assigned component k.
%}

function [components, Nmatrix, Qmatrix] = assignRandomComponents(bowMatrix, K)
components = cell(size(bowMatrix));
M = size(bowMatrix, 1);
V = size(bowMatrix, 2);

Nmatrix = zeros(M, K);
Qmatrix = zeros(K, V);

% get non-zer0 entries of bowMatrix
[rowInd, colInd, val] = find(bowMatrix);

for i = 1:length(rowInd)
    % generate random component vector for each word in each document
    currRandVec = ceil(K * rand(val(i), 1));
    components{rowInd(i), colInd(i)} = currRandVec;
    for j = 1:length(currRandVec)
        Nmatrix(rowInd(i), currRandVec(j)) = Nmatrix(rowInd(i), currRandVec(j))+1;
        Qmatrix(currRandVec(j), colInd(i)) = Qmatrix(currRandVec(j), colInd(i))+1;
    end
end

end