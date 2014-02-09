%{
This function creates an arbitrary split in training set into validation
set and actual training set.

The function takes "exSize:the number of examples in the training set" and 
"valSetRatio:the percentage of validation set" (in [0, 1] range) in the 
whole training set as parameter and returns a logical column vector of size
exSize-by-1 whose entries are either true or false (i.e. a value for each
example in the training set)

If the entry is true, it means it belongs to the validation set. Otherwise,
it is a member of actual training set.
%}

function valInd = splitTrainingSet(exSize, valSetRatio)
% the number of elements in the validation set
valSetSize = floor(exSize*valSetRatio);
valInd = false(exSize, 1);

randomOrder = randperm(exSize);
valInd(randomOrder(1:valSetSize)) = true;

end