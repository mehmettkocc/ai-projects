%load the dataset
load('data/classic400.mat');
% preprocess the bag-of-words representation
[bowMatrix, eliminatedInd] = preprocessBowMatrix(classic400);
eliminatedWords = classicwordlist(eliminatedInd);

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
%%
% parameters 
epochNum = 10;

for i = 1:epochNum
    randOrder = randperm(C);
end