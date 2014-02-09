% split into validation and actual training sets
exSize = 1000;
valSetRatio = 0.3;


valInd = splitTrainingSet(exSize, valSetRatio);
valSetSize = sum(valInd==true);
trainingSetSize = exSize - valSetSize;


%%
% perceptron training
% regularization parameter
muVal = 5.^(-2:2);
% learning parameter and its exponential decay at each epoch
lambda0Val = 10.^(-2:1); decayRate = 0.8;
% number of epochs used for training
epochNum = 5;

for i=1:length(muVal)
    mu = muVal(i);
    for j=1:length(lambda0Val)
        lambda0 = lambda0Val(j);
        for k=1:epochNum
            lambda = lambda0(j) * decayRate^(k-1);
            
        end
    end
    
end