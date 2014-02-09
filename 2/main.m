% split into validation and actual training sets
exSize = 1000;
valSetRatio = 0.3;


valInd = splitTrainingSet(exSize, valSetRatio);


%%
% perceptron training
w = 