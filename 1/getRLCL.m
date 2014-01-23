%{
Author: Mehmet Koc
Date: 1/21/14
Description: Computes the regularized log-conditional-likelihood (RLCL) of 
a dataset based on beta (logistic regression coefficient) and mu (regularization
parameter). feats is mxn feature matrix where m is number of
examples and n is number of features. labels is mx1 labels column vector
of type double where positives are 1 and negatives are -1.beta is nx1
coefficient column vector.

Uses getLCL2(...) and adds regularization term
%}
function [p, RLCL] = getRLCL(feats, labels, beta, mu)
%regularization cost halved due to the formulation is Stochastic Gradient Ascent
[p, LCL] = getLCL2(feats, labels, beta);
RLCL = -LCL + mu*(beta'*beta)/2;
end