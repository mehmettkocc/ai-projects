function [ RLCL d_RLCL ] = calcRLCL_objfun( beta, X, Y, mu )
    [p, LCL] = getLCL2(X, Y, beta);
    RLCL = -LCL + mu*(beta'*beta)/2;
    d_RLCL = -X'*(Y-p) + mu * beta;
end