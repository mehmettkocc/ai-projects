%load the dataset
load('data/classic400.mat');
% preprocess the bag-of-words representation
[bowMatrix, eliminatedInd] = preprocessBowMatrix(classic400);
eliminatedWords = classicwordlist(eliminatedInd);
vocWords = classicwordlist(~eliminatedInd);

% initial parameters
K = 3;  % num. of components in the mixture
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
% select the best 0.1% of all vocabulary for each k in 1:K
wordNum = ceil(V*K/1000);

lastPMF = componentPMFTable(:, :, epochNum);
highProbWords = selectHighProbWords(lastPMF, wordNum, vocInd, vocWords);
%%
figure,
for i = 1:saveTimeNum
    theta = Nsaved(:, :, i) ./ repmat(docLength, [1 K]);
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
