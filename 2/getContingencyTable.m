%{
Author: Mehmet Koc
Date: 2/9/14
//////////////////////////////////////////////////////////////////////////
Description: getContingencyTable(...) takes the indices of examples,
predicts a sequence for each of them and compares them to the actual
sequence to obtain an m-by-m contingency table where m is the cardinality
of the each label. Using the computed contingency table, 0/1 accuracy is
also returned.

w is the Jx1 weight column vector for the features.

The last argument shows whether the examples should be chosen from the
training set and test set. If isTrain=nonzero, example is chosen from the
all training set, otherwise from the test set.
%}
function [contingencyTable, accuracy]= getContingencyTable(exInd, w, isTrain)

ySet=evalin('base','ySet');
Ytest=evalin('base','Ytest');
Y=evalin('base','Y');    

exNum = length(exInd);
m = length(ySet);
contingencyTable = zeros(m, m);

% infer the best sequence for each example and update its entry in the table
for i=1:exNum
    G = getScoreMatrix(exInd(i), w, isTrain);    
    [seq, ~] = getBestLabelSequence(G);
    if (isTrain)
        realSeq = Y(exInd(i), :);        
    else
        realSeq = Ytest(exInd(i), :);        
    end
    for j=1:length(realSeq)
        contingencyTable(realSeq{1}(j), seq(j))=contingencyTable(realSeq{1}(j), seq(j))+1;
    end
end

accuracy = sum(diag(contingencyTable))/sum(contingencyTable(:));

end