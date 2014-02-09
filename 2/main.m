% split into validation and actual training sets
exSize = 1000;
valSetRatio = 0.3;


valInd = splitTrainingSet(exSize, valSetRatio);
valSetSize = sum(valInd==true);
trainingSetSize = exSize - valSetSize;


%%
% perceptron training
% regularization parameter
mu = 2.^(-2:2);
% learning parameter and its exponential decay at each epoch
lambda0 = 0.1; decayRate = 0.9;
% number of epochs used for training
epochNum = 5;

for i=1:length(mu)
    
   for j=1:epochNum
       lambda = lambda0 * decayRate^(j-1);
       
   end
   
end