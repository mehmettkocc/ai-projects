%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: In-place function, that modifies N and Q matrices according to
the input arguments:
N = M-by-K matrix whose (m, k) entry gives the number of words 
which have been assigned to component k in document m
Q = K-by-V matrix whose (k, v) entry gives the count of word v in 
the vocabulary with assigned component k
Nsum := sum(N, 2)
k0 = the old component number from the range 1:K
k1 = the new component number from the range 1:K
v = the vocabulary index of the current word
m = the document index of the current document
%}

function [N, Q, Qsum] = updateCounts(N, Q, Qsum, k0, k1, v, m)
N(m, k0) = N(m, k0) - 1;
N(m, k1) = N(m, k1) + 1;

Q(k0, v) = Q(k0, v) - 1;
Q(k1, v) = Q(k1, v) + 1;

Qsum(k0) = Qsum(k0) - 1;
Qsum(k1) = Qsum(k1) + 1;
end