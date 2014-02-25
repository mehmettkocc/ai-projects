%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: This function computes the component PMF using the counts and
prior distribution parameters.

For detailed explanation, see the report at ./data/ai-project3.pdf
%}

function componentPMF = getComponentPMF(N, Q, Qsum, alpha, beta, v, m, k)
K = length(Qsum);

aux1 = zeros(K, 1);  
aux1(k) = 1;

num1 = Q(:, v) - aux1 + beta(v) * ones(K, 1);
den1 = Qsum - aux1 + sum(beta) * ones(K, 1);

aux2 = zeros(K, 1);  
aux2(m) = 1;

num2 = N(m, :)' - aux2 + alpha(m) * ones(K, 1);

% unnormalized PMF
componentPMF = num1 .* num2 ./ den1;

end