%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: Given the input bag-of-words representation, preprocess it 
according to the criteria listed and return :
1. processed: New bag-of-words representation
2. eliminatedInd: The indices of words that are eliminated from vocabulary
%}

function [processed, eliminatedInd] = preprocessBowMatrix(inputBowMatrix)
% Criteria1: eliminate the words that occur <= 1
eliminatedInd = (sum(inputBowMatrix) <= 1);
processed = inputBowMatrix(:, ~eliminatedInd); 
end