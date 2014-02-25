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
1. compInd: C-by-1 vector where C is the number of words in the whole
corpus and the values are the component indices from 1:K
2. vocInd: C-by-1 vector where the values are the vocabulary indices from
1:V
3. docInd: C-by-1 vector where the values are the document indices from
1:M. Note that compInd, vocInd and docInd are all coupled.
4. Nmatrix: M-by-K matrix whose (m, k) entry gives the number of words
which have been assigned to component k in document m
5. Qmatrix: K-by-V matrix whose (k, v) entry gives the count of word v in
the vocabulary with assigned component k.
%}

function [compInd, vocInd, docInd, Nmatrix, Qmatrix] =...
    assignRandomComponents2(bowMatrix, K)

M = size(bowMatrix, 1);
V = size(bowMatrix, 2);
C = sum(bowMatrix(:));

compInd = zeros(C, 1);
vocInd = zeros(C, 1);
docInd = zeros(C, 1);
Nmatrix = zeros(M, K);
Qmatrix = zeros(K, V);

% get non-zer0 entries of bowMatrix
[rowInd, colInd, val] = find(bowMatrix);

count = 1;
for i = 1:length(rowInd)
    % generate random component vector for each word in each document
    currWordCount = val(i);
    currDocInd = rowInd(i);
    currVocInd = colInd(i);
    
    currRandVec = ceil(K * rand(currWordCount, 1));
    compInd(count:(count+currWordCount-1)) = currRandVec;
    vocInd(count:(count+currWordCount-1)) = currVocInd * ones(currWordCount, 1);
    docInd(count:(count+currWordCount-1)) = currDocInd * ones(currWordCount, 1);
    
    for j = 1:length(currRandVec)
        Nmatrix(currDocInd, currRandVec(j)) = Nmatrix(currDocInd, currRandVec(j))+1;
        Qmatrix(currRandVec(j),currVocInd) = Qmatrix(currRandVec(j), currVocInd)+1;
    end
    
    count = count + currWordCount;
end

end