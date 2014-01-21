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
%%
%get base rates
trainBaseRate = sum(dataset.trainLabelsFull==1)/length(dataset.trainLabelsFull);
testBaseRate = sum(dataset.testLabels==1)/length(dataset.testLabels);

%split into actualTraining and validation sets
valSetRatio = 0.3;
[dataset.trainExNum, dataset.valExNum, dataset.trainLabels, dataset.trainFeats,...
    dataset.valLabels, dataset.valFeats] = splitIntoTrainingAndValidation(dataset, valSetRatio);

%normalize the sets
[dataset.trainFeatsN, dataset.trainMean, dataset.trainStd] = ...
    normalizeTrainZ(dataset.trainFeats);
dataset.valFeatsN = normalizeTestZ(dataset.valFeats, dataset.trainMean,...
    dataset.trainStd);
dataset.testFeatsN = normalizeTestZ(dataset.testFeats, dataset.trainMean,...
    dataset.trainStd);
%%
close all
format long;
%SGD LEARNING
%number of epoch in SGD
epochNum = 7;
%regularization weight
mu = 5.^[-6:3];
%SGD learning rate -> inversely proportional to decayRate
lambda0 = 0.1;   decayRate = 0.9;
%starting point for logistic regression coefficient
beta = zeros(dataset.featNum, 1);
%beta for each mu
betaAll = zeros(dataset.featNum, length(mu));
%log-conditional-likelihood for each mu and epoch
LCL = zeros(length(mu), epochNum);
%0-1 accuracy for each mu and epoch
valAccuracy = zeros(length(mu), epochNum);

%i --> index of current regularization weight
for i=1:length(mu)
    %j --> index of current epoch number
    for j=1:epochNum
        %use smaller learning rate for each epoch
        lambda = lambda0^(decayRate*(j-1));
        currentOrder = randperm(dataset.trainExNum);
        for k=1:dataset.trainExNum
            x = dataset.trainFeatsN(currentOrder(k), :)';
            y = dataset.trainLabels(currentOrder(k));
            p = getProb(x, y, beta);
            beta = beta + lambda * ((y - p) * x - mu(i) * beta);            
        end
        LCL(i, j) = getLCL(dataset.valFeatsN, dataset.valLabels, beta);
        valAccuracy(i, j) = getAccuracy(dataset.valFeatsN, dataset.valLabels, beta);
    end
    betaAll(:, i) = beta;
end

%get test accuracy
[~, bestInd] = max(max(valAccuracy, [], 2));
accuracy = getAccuracy(dataset.testFeatsN, dataset.testLabels, betaAll(:, bestInd));
