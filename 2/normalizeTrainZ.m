function [FM_N, meann, sd] = normalizeTrainZ(FM)
%z-scoring
FM_N = FM;
meann = zeros(size(FM, 2), 1);
sd = -1 * ones(size(FM, 2), 1);
for i=1:size(FM, 2)
    distinctValNum = length(unique(FM(:, i)));
    %do not normalize unary or binary features
    if(distinctValNum > 2)
        meann(i) = mean(FM(:, i));
        sd(i) = std(FM(:, i));
        FM_N(:, i) = (FM(:, i)-meann(i))/sd(i);
    end
end
end