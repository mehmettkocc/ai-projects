%{
Author: Mehmet Koc
Date: 2/8/14
//////////////////////////////////////////////////////////////////////////
Description: This function returns the alpha matrix A which includes the
sum of probabilities of all possible label sequences up to k=columnIndex
and ending with y_k=rowIndex (forward vectors). This function is important
to normalize the scores obtained via getScoreMatrix to acquire the 
probabilities.

The function also returns logZ which is the log of the sum of exp(score) of
all possible labels. This term is important in the normalization of 
exp(score)'s to obtain probabilities.

Considering only the correlation b/w two successive labels, we obtain the
following recursive relation:
a(v, k) = sum{u} (a(u, k-1)*exp(g_k(u, v))) where g_k(u, v)=G(u, v, k)

Since the sum above is likely to overflow/underflow, this simple trick is
used to prevent that:
https://hips.seas.harvard.edu/blog/2013/01/09/computing-log-sum-exp/

So, instead of keeping the actual a(v, k) values, log(a(v, k)) values are
stored in A matrix.

For more info on G, read getScoreMatrix(...)
%}
function [A, logZ] = getAlphaMatrix(G)
% get m and n
m = size(G, 1);
n = size(G, 3);
A = zeros(m, n-1);

% get the first column of A so that we can compute the rest by recursing afterwards
maxVal = max(G(:, :, 1));
temp = G(:, :, 1) - repmat(maxVal, [m, 1]);
A(:, 1) = maxVal + log(sum(exp(temp)));

% compute the rest of the columns of A by recursions
for k=2:(n-1)
    GwithHistory = G(:, :, k) + repmat(A(:, k-1), [1, m]);
    maxVal = max(GwithHistory);
    temp = GwithHistory - repmat(maxVal, [m, 1]);
    A(:, k) = maxVal + log(sum(exp(temp)));
end

% A is calculated. So, let's calculate logZ
maxVal = max(A(:, end));
temp = A(:, end) - maxVal;
logZ = maxVal + log(sum(exp(temp)));

end

