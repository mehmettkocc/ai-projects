%{
Author: Mehmet Koc
Date: 01/18/14
Description: Calculate P(y=1 | x; beta) in logistic regression model
x and beta need to be column vectors
%}
function p = getProb(x, y, beta)
p = 1/(1 + exp(beta' * x));
if(y)
    p = 1 - p;
end
end