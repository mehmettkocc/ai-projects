%{
According to the files, there are 70115 all training examples and 28027 
test examples. So, the each of 70115 rows in X and Y belong to one training
example.
%}

load('data/data.mat');
%{
X = X(1:1000);
Y = Y(1:1000);
Ytest = Ytest(1:1000);
Xtest = Xtest(1:1000);
%}
ySet = {'COMMA', 'PERIOD' , 'QUESTION_MARK', 'EXCLAMATION_POINT', 'COLON', 'SPACE'};
% split into validation and actual training sets
allTrainingSize = size(X, 1);
testSize = size(Xtest, 1);
% put the length of features here
featSize = 46;
% the [0, 1] percentage of validation set in all training set
valRatio = 0.3;

%split all training set into actual training set and validation set
valIndLogical = splitTrainingSet(allTrainingSize, valRatio);
tempInd = (1:allTrainingSize);
valInd = tempInd(valIndLogical);
trainingInd = tempInd(~valIndLogical);
valSize = length(valInd);
trainingSize = allTrainingSize - valSize;
%%
% perceptron training
% regularization parameter
muVal = 5.^(0:0);
% learning parameter and its exponential decay at each epoch
lambda0Val = 10.^(-1:-1); decayRate = 0.8;
% number of epochs used for training
epochNum = 5;

% store grid-search results in these variables
allW = zeros(length(muVal), length(lambda0Val), featSize);
avgLCL = zeros(length(muVal), length(lambda0Val));

trainingFeatures = getFeatures(trainingInd, 1);
trainingFeatsN = normalizeTrainZ(trainingFeatures);
% grid search 
for i=1:length(muVal)
    mu = muVal(i);
    for j=1:length(lambda0Val)
        lambda0 = lambda0Val(j);
        % reset w for each new hyperparameter pair (mu, lambda)
        w = zeros(featSize, 1);
        % obtain optimal w with the current parameters
        for k=1:epochNum
            lambda = lambda0 * decayRate^(k-1);
            for l=1:trainingSize
                G = getScoreMatrix(trainingInd(l), w, 1);
                [currBestSeq, ~] = getBestLabelSequence(G);                 
                expectedFeatures = getFeatures2(trainingInd(l), currBestSeq, 1);
                expectedFeatsN = normalizeTrainZ(expectedFeatures);
                % gradient ascent update
                w = w + lambda * (trainingFeatsN(:, l)-expectedFeatsN-2*mu*w);
            end
        end
        allW(i, j, :) = w;
        avgLCL(i, j) = getLCL(valInd, w, 1);
    end    
end
[bestLCL bestLCLInd] = max(avgLCL(:));
[bestLCLIndX, bestLCLIndY] = ind2sub([length(muVal), length(lambda0Val)], bestLCLInd);
bestW = allW(bestLCLIndX, bestLCLIndY, :);
%%
% test set results
[contingencyTable accuracy] = getContingencyTable(1:testSize, bestW, 0);

