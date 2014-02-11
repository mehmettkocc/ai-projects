function testMatrixN = normalizeTestZ(testMatrix, mean, sd)
testMatrixN = testMatrix;
for i=1:size(testMatrix, 2)
    if(sd(i) ~= -1)
        testMatrixN(:, i) = (testMatrix(:, i)-mean(i))/sd(i);
    end
end
end