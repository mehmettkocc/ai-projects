%load the dataset
load('data/classic400.mat');
% preprocess the bag-of-words representation
[bowMatrix, eliminatedInd] = preprocessBowMatrix(classic400);
eliminatedWords = classicwordlist(eliminatedInd);

% parameters
K = 3;  % num. of components in the mixture
M = size(bowMatrix, 1); % num. of documents in the corpus
V = size(bowMatrix, 2); % num. of words in the vocabulary
docLength = sum(bowMatrix, 2);  % num. of words in each document
alpha0 = 50/K;  % Dirichlet dist. param. for prior p(z)
beta0 = 0.01;   % Dirichlet dist. param. for prior p(w|z)

alpha = alpha0 * ones(K, 1);
beta = beta0 * ones(V, 1);

[components, N, Q] = assignRandomComponents(bowMatrix, K);
%%
