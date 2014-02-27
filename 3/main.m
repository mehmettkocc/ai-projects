%load the dataset
load('data/classic400.mat');
% preprocess the bag-of-words representation
[bowMatrix, eliminatedInd] = preprocessBowMatrix(classic400);
eliminatedWords = classicwordlist(eliminatedInd);
vocWords = classicwordlist(~eliminatedInd);
%%
load('yelpdata.mat');
[bowMatrix, eliminatedInd] = preprocessBowMatrix(yelpTrain);
eliminatedWords = classicwordlist(eliminatedInd);
vocWords = classicwordlist(~eliminatedInd);
%%
% initial parameters
K = 5;  % num. of components in the mixture
M = size(bowMatrix, 1); % num. of documents in the corpus
V = size(bowMatrix, 2); % num. of words in the vocabulary%
C = full(sum(bowMatrix(:)));  % num. of words in the whole corpus
docLength = full(sum(bowMatrix, 2));  % num. of words in each document
alpha0 = 50/K;  % Dirichlet dist. param. for prior p(z)
beta0 = 0.01;   % Dirichlet dist. param. for prior p(w|z)

alpha = alpha0 * ones(K, 1);
beta = beta0 * ones(V, 1);

[compInd, vocInd, docInd, N, Q] = assignRandomComponents2(bowMatrix, K);
Qsum = sum(Q, 2);
%%
% parameters
epochNum = 500;
saveTimeNum = 4;
NsaveTimes = ceil(logspace(0, log10(epochNum), saveTimeNum));
Nsaved = zeros(M, K, saveTimeNum);
saveCount = 1;

componentPMFTable = zeros(C, K);

for i = 1:epochNum
    if (i == NsaveTimes(saveCount))
        Nsaved(:, :, saveCount) = N;
        saveCount = saveCount + 1;
    end
    randOrder = randperm(C);
    for j = 1:C
        componentPMF = getComponentPMF(N, Q, Qsum, alpha, beta, vocInd(randOrder(j)),...
            docInd(randOrder(j)), compInd(randOrder(j)));
        if (i == epochNum)
            componentPMFTable(randOrder(j), :) = componentPMF';
        end
        % find the new component label
        k1 = selectNewComponent(componentPMF);
        % update the counts
        [N, Q, Qsum] = updateCounts(N, Q, Qsum, compInd(randOrder(j)), k1,...
            vocInd(randOrder(j)), docInd(randOrder(j)));
        % update the component label
        compInd(randOrder(j)) = k1;
    end
end
%%
%{
probThreshold = 0.95;
highProbWords = cell(K, 1);

for i=1:K
    ind = unique(vocInd(componentPMFTable(:, i, epochNum) > probThreshold));
    highProbWords{i} = vocWords(ind);
end
%}
% select the best 0.7% of all vocabulary for each k in 1:K
wordNum = ceil(V/150);

%lastPMF = componentPMFTable(:, :, epochNum);
highProbWords = selectHighProbWords(componentPMFTable, wordNum, vocInd, vocWords);
%%
alphaVal = [0.1, 1, 10];

figure,
for i = 1:length(alphaVal)
    subplot(1, 3, i), plotDirichletDist(alphaVal(i) * ones(3, 1));
end
%%
figure,
for i = 1:saveTimeNum
    theta = Nsaved(:, :, i) ./ repmat(docLength, [1 K]);
    if (i == saveTimeNum)
        finalTheta = theta;
    end
    subplot(2, 2, i),
    for j = 1:3
        currTheta = theta(truelabels==j, :);
        if (j == 1)
            plot3(currTheta(:, 1), currTheta(:, 2), currTheta(:, 3), 'r.');
        elseif (j == 2)
            plot3(currTheta(:, 1), currTheta(:, 2), currTheta(:, 3), 'b.');
        else
            plot3(currTheta(:, 1), currTheta(:, 2), currTheta(:, 3), 'g.');
        end
        hold on;
    end
    hold off;
    xlabel('\theta_1'); ylabel('\theta_2'); zlabel('\theta_3');
    title(['Epoch number = ', num2str(NsaveTimes(i))]);
    %legend('trueLabel=1', 'trueLabel=2', 'trueLabel=3');
end
rotate3d on;
%%
% SVM training
FoldNo = 4;
bestcv = 0;     bestc = 0;
cstart = -1; cend = 4;
c = 10.^(cstart:cend);

baseGamma = ceil(FindBaseGamma(finalTheta));
gstart = log10(baseGamma) - 5;
gend = log10(baseGamma) + 3;
g = 10.^(gstart:gend);

CVAcc = zeros(length(c), length(g));

testRatio = 0.3;
[trainData, trainLabels, testData, testLabels] = ...
    splitIntoSets(finalTheta, truelabels', testRatio);
%%
for i=1:length(c)
    for j=1:length(g)
        options=['-m 4000 -q -t 0 -v ', num2str(FoldNo),...
            ' -c ', num2str(c(i)), ' -g ', num2str(g(j))];
        cv = svmtrain2(trainLabels, trainData, options);
        CVAcc(i, j) = cv;
        if(cv>bestcv)
            bestcv = cv;
            bestc = c(i);
            bestg = g(j);
        end
    end
end
fprintf('\tbestrate for Gaussian=%g\n\tbestc=%g\n\tbestg=%g\n\t\n\n\n\n\n', bestcv, bestc, bestg);

options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc), ' -g ', num2str(bestg)];
model=svmtrain2(trainLabels, trainData, options);
% w = model.sv_coef' * model.SVs;
[predicted, acc, score] = svmpredict(testLabels, testData, model);
