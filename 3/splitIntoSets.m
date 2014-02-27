%{
Author: Mehmet Koc
Date: 2/25/14
--------------------------------------------------------------------------
Description: Separates the dataset into training and test sets whose ratio
is determined by testRatio which is the [0, 1] ratio of test set in the
dataset.
%}
function [trainData, trainLabels, testData, testLabels] = ...
    splitIntoSets(dataset, labels, testRatio)
%example numbers from validation and training sets
exNum = size(dataset, 1);

testExNum = ceil(exNum * testRatio);
randOrder = randperm(exNum);

testExInd = false(exNum, 1);
testExInd(randOrder(1:testExNum)) = true;

trainData = dataset(~testExInd, :);
testData = dataset(testExInd, :);

trainLabels = labels(~testExInd);
testLabels = labels(testExInd);

end