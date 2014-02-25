%{
Author: Mehmet Koc
Date: 2/24/14
--------------------------------------------------------------------------
Description: Given:
1. C-by-K pmfTable where C is the number of words in the
corpus and K is the number of components
2. The number of words to be selected for each component
3. The vocubulary indices corresponding to the rows of pmfTable
4. The actual vocabulary

The function returns K-by-1 cell where each cell entry has the best wordNum
words for its corresponding component.

%}

function highProbWords = selectHighProbWords(pmfTable, wordNum, vocInd, voc)
K = size(pmfTable, 2);
V = length(voc);

vocIndSorted = zeros(V, K);

[~, bestInd] = sort(pmfTable, 'descend');
for i = 1:K
    vocIndSorted(:, i) = unique(vocInd(bestInd(:, i)), 'stable');
end

highProbWords = voc(vocIndSorted(1:wordNum, :));

end