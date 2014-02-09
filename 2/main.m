% split into validation and actual training sets
exSize = 1000;
featSize = 100;
valRatio = 0.3;

% load examples
valIndLogical = splitTrainingSet(exSize, valRatio);
tempInd = (1:exSize);
valInd = tempInd(valIndLogical);
trainingInd = tempInd(~valIndLogical);
valSize = length(valInd);
trainingSize = exSize - valSize;


%%
% perceptron training
% regularization parameter
muVal = 5.^(-1:2);
% learning parameter and its exponential decay at each epoch
lambda0Val = 10.^(-2:1); decayRate = 0.8;
% number of epochs used for training
epochNum = 5;

% store grid-search results in these variables
bestW = zeros(length(muVal), length(lambda0Val), featSize);
avgLCL = zeros(length(muVal), length(lambda0Val));

trainingFeatures = getFeatures(trainingInd);
% grid search 
for i=1:length(muVal)
    mu = muVal(i);
    for j=1:length(lambda0Val)
        lambda0 = lambda0Val(j);
        % reset w for each new hyperparameter pair (mu, lambda)
        w = zeros(featSize, 1);
        % obtain optimal w with the current parameters
        for k=1:epochNum
            lambda = lambda0* decayRate^(k-1);
            for l=1:valSize
                G = getScoreMatrix(trainingInd(l), w);
                [currBestSeq, ~] = getBestLabelSequence(G);                 
                expectedFeatures = getFeatures2(trainingInd(l), currBestSeq);
                % gradient ascent update
                w = w + lambda * (trainingFeatures(:, l)-expectedFeatures-2*mu*w);
            end
        end
        bestW(i, j, :) = w;
        [~, logZ] = getAlphaMatrix(G);
        avgLCL(i, j) = getLCL(valInd, w, logZ);
    end    
end



