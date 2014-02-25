function baseGamma = FindBaseGamma(featMatrix)
distMatrixSq = pdist(featMatrix).^2;
variancee = sum(distMatrixSq(:))/numel(distMatrixSq);
baseGamma = 1/(2 * variancee);
end