%{
Author: Mehmet Koc
Date: 2/25/14
--------------------------------------------------------------------------
Description: Separates the whole training set into actual training set
and validation set. A struct named dataset which should include
those as its fields is needed as one of the inputs:
all features --> dataset.trainFeatsFullN
all labels --> dataset.trainLabelsFull
number of all examples --> dataset.exNum
%}
function [trainExNum, valExNum, trainLabels, trainFeats, valLabels, valFeats] = ...
    splitIntoSets(dataset, valSetRatio)
%example numbers from validation and training sets
valExNum = floor(dataset.exNum * valSetRatio);
trainExNum = dataset.exNum - valExNum;

%get the indices randomly
trainExInd = randperm(dataset.exNum, trainExNum);
trainExIndLogical = false(dataset.exNum, 1);
trainExIndLogical(trainExInd) = 1;

%find actualTraining/validation labels and features
trainLabels = dataset.trainLabelsFull(trainExIndLogical);
valLabels = dataset.trainLabelsFull(~trainExIndLogical);
trainFeats = dataset.trainFeatsFull(trainExIndLogical, :);
valFeats = dataset.trainFeatsFull(~trainExIndLogical, :);

end