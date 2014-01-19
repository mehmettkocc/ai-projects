close all
%get train/test labels and features
dataset.trainAll = importdata('data/newtrain.txt');
dataset.testAll = importdata('data/newtest.txt');
%total number of features (subtract 1 for labels and add 1 for constant x0=1)
dataset.featNum = size(dataset.trainAll, 2);
%count of examples from actualTraining+validation and test sets
dataset.exNum = size(dataset.trainAll, 1);
dataset.testExNum = size(dataset.testAll, 1);
%train/test labels and features
dataset.trainLabelsFull = dataset.trainAll(:, 1);
dataset.testLabels = dataset.testAll(:, 1);
dataset.trainFeatsFull = [ones(dataset.exNum, 1), dataset.trainAll(:, 2:end)];
dataset.testFeats = [ones(size(dataset.testAll, 1), 1), dataset.testAll(:, 2:end)];
%show the dataset statistics
getFeatureStats(dataset.trainFeatsFull);
getFeatureStats(dataset.testFeats);
%get base rate
trainBaseRate = sum(dataset.testExNum)/length(dataset.trainLabelsFull);
%split into actualTraining and validation sets
valSetRatio = 0.35;
[dataset.trainExNum, dataset.valExNum, dataset.trainLabels, dataset.trainFeats,...
    dataset.valLabels, dataset.valFeats] = SplitIntoTrainingAndValidation(dataset, valSetRatio);
%%
close all
%SGD LEARNING
%number of epoch in SGD
epochNum = 3;
%regularization weight
mu = 10.^[-2:2];
%SGD learning rate -> inversely proportional to
lambda0 = 0.1;   decayRate = 0.75;
%starting point for logistic regression coefficient
beta = zeros(dataset.featNum, 1);
%beta for each mu
betaAll = zeros(length(mu), 1);
%log-conditional-likelihood for each epoch
LCL = zeros(epochNum, length(mu));


%i --> index of current regularization weight
for i=1:length(mu)
    %j --> index of current epoch number
    for j=1:epochNum
        %use smaller learning rate for each epoch
        lambda = lambda0^(decayRate*(j-1));
        currentOrder = randperm(exNum);
        for k=1:exNum
            
           beta = beta + lambda * (dataset.trainLabels)
        end
    end
end
