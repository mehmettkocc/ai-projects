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
    dataset.valLabels, dataset.valFeats] = SplitIntoTrainingAndValidation(dataset, valSetRatio);

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
mu = 2.^[-1:0.2:1.4]';
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
        [~, LCL(i, j)] = getLCL2(dataset.valFeatsN, dataset.valLabels, beta);
        valAccuracy(i, j) = getAccuracy(dataset.valFeatsN, dataset.valLabels, beta);
    end
    betaAll(:, i) = beta;
end
%plots for LCL and valAccuracy
%for LCL
figure, subplot(1,3,1), semilogy(1:epochNum, -LCL');
legend(num2str(mu)); 
xlim([1, epochNum]);
title('(a)LCL for all \mu values');
xlabel('Epoch number'); ylabel('log(-LCL)');

subplot(1,3,2), semilogy(1:epochNum, -LCL(1:(end-2), :)');
%legend(num2str(mu(1:(end-2))));
xlim([1, epochNum]);
title(['(b)LCL for all \mu values', 10, 'except last two']);
xlabel('Epoch number'); ylabel('log(-LCL)');

subplot(1,3,3), plot(3:epochNum, -LCL(1:(end-1), 3:end)');
%legend(num2str(mu(1:(end-1))));
xlim([3, epochNum]);
title(['(c)LCL for all \mu values except last', 10, 'one starting from 3rd epoch']);
xlabel('Epoch number'); ylabel('-LCL');


%for accuracy
figure, subplot(1,2,1), plot(1:epochNum, valAccuracy');
legend(num2str(mu)); 
xlim([1, epochNum]);
title('(a)0/1 accuracy on the validation set');
xlabel('Epoch number'); ylabel('0/1 Accuracy');

subplot(1,2,2), plot(1:epochNum, valAccuracy'); 
xlim([3, epochNum]); ylim([0.82, 0.87]);
title('(b)Zoomed 0/1 accuracy on the validation set');
xlabel('Epoch number'); ylabel('0/1 Accuracy');
%%
%get test accuracy
[~, bestInd] = max(max(LCL, [], 2));
bestBeta = betaAll(:, bestInd);
accuracy = getAccuracy(dataset.testFeatsN, dataset.testLabels, bestBeta);
accuracyTable = getAccuracyTable(dataset.testFeatsN, dataset.testLabels, bestBeta);
%%
close all
format long;
%LBFGS LEARNING
%beta for each mu
%mu2 = 2.^[-1:8]';
mu2 = 2.^[-1:0.2:2]';
options=[];
options.Method = 'lbfgs';
options.useMex = 0;
betaAll2 = zeros(dataset.featNum, length(mu2));
%log-conditional-likelihood for each mu and epoch
LCL2 = zeros(length(mu2), 1);
%0-1 accuracy for each mu and epoch
valAccuracy2 = zeros(length(mu2), 1);

%i --> index of current regularization weight
for i=1:length(mu2)
    beta2 = zeros(dataset.featNum, 1);
	[beta2, RLCL, exitflag, output] = minFunc(@calcRLCL_objfun,beta2,options,dataset.trainFeatsN,dataset.trainLabels, mu2(i));
    [~, LCL2(i)] = getLCL2(dataset.valFeatsN, dataset.valLabels, beta2);
    valAccuracy2(i) = getAccuracy(dataset.valFeatsN, dataset.valLabels, beta2);
    betaAll2(:, i) = beta2;
end
%%
[~, bestInd2] = max(LCL2);
bestBeta2 = betaAll2(:, bestInd2);
accuracy2 = getAccuracy(dataset.testFeatsN, dataset.testLabels, bestBeta2);
%plots for LCL and valAccuracy
%for LCL
% figure, subplot(1,3,1), semilogy(1:epochNum, -LCL');
% legend(num2str(mu)); 
% xlim([1, epochNum]);
% title('(a)LCL for all \mu values');
% xlabel('Epoch number'); ylabel('log(-LCL)');
% 
% subplot(1,3,2), semilogy(1:epochNum, -LCL(1:(end-2), :)');
% %legend(num2str(mu(1:(end-2))));
% xlim([1, epochNum]);
% title(['(b)LCL for all \mu values', 10, 'except last two']);
% xlabel('Epoch number'); ylabel('log(-LCL)');
% 
% subplot(1,3,3), plot(3:epochNum, -LCL(1:(end-1), 3:end)');
% %legend(num2str(mu(1:(end-1))));
% xlim([3, epochNum]);
% title(['(c)LCL for all \mu values except last', 10, 'one starting from 3rd epoch']);
% xlabel('Epoch number'); ylabel('-LCL');
% 
% 
% %for accuracy
% figure, subplot(1,2,1), plot(1:epochNum, valAccuracy');
% legend(num2str(mu)); 
% xlim([1, epochNum]);
% title('(a)0/1 accuracy on the validation set');
% xlabel('Epoch number'); ylabel('0/1 Accuracy');
% 
% subplot(1,2,2), plot(1:epochNum, valAccuracy'); 
% xlim([3, epochNum]); ylim([0.82, 0.87]);
% title('(b)Zoomed 0/1 accuracy on the validation set');
% xlabel('Epoch number'); ylabel('0/1 Accuracy');