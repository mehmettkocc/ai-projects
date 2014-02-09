% parameters
exSize = 1000;
valSetRatio = 0.3;

% split into validation and actual training sets
valInd = splitTrainingSet(exSize, valSetRatio);


%%
% perceptron training