dirP = 'txt_sentoken\pos500\';
dirN = 'txt_sentoken\neg500\';
vLength = 2e4;
[vocLong, vocPLong, vocNLong, wordCountLong, wordCountPLong, wordCountNLong] =...
    CreateVocabularyLong(vLength, dirP, dirN);
%%
dirP = '500_500\p\';
dirN = '500_500\n\';
stopWordsFilename = 'common10kEdited.txt';
stopWordsCount = 500;
stopWordsAll = importdata(stopWordsFilename, '\n');
stopWords = stopWordsAll(1:stopWordsCount);
[voc, vocP, vocN, wordCount, wordCountP, wordCountN] =...
    CreateVocabulary(vLength, dirP, dirN, stopWords);
%%
testPFilename = '500_500\stsppos2.txt';
testNFilename = '500_500\stspneg2.txt';
trainPFilename = '500_500\p\stsppos1.txt';
trainNFilename = '500_500\n\stspneg1.txt';
trainP = GetFeatureMatrix(trainPFilename, voc);
trainN = GetFeatureMatrix(trainNFilename, voc);
testP = GetFeatureMatrix(testPFilename, voc);
testN = GetFeatureMatrix(testNFilename, voc);
trainPLong = GetFeatureMatrix(trainPFilename, vocLong);
trainNLong = GetFeatureMatrix(trainNFilename, vocLong);
testPLong = GetFeatureMatrix(testPFilename, vocLong);
testNLong = GetFeatureMatrix(testNFilename, vocLong);
%%
datasetTrain = sparse([trainP; trainN]);
datasetTest = sparse([testP; testN]);
labelsTrain = [ones(size(trainP, 1), 1); -1*ones(size(trainN, 1), 1)];
labelsTest = [ones(size(testP, 1), 1); -1*ones(size(testN, 1), 1)];
%
FoldNo = 5; bestcv1 = 0; bestcv2 = 0; bestcv3 = 0; bestcv4 = 0; bestcv5 = 0; bestcv6 = 0;
bestc1 = 0; bestc2 = 0; bestc3 = 0; bestc4 = 0; bestc5 = 0; bestc6 = 0;
cstart = -3; cend = 2;
c=[cstart:cend]; c=10.^c; cstep=size(c, 2);
CVAcc1 = zeros(cstep, 1);   CVAcc2 = zeros(cstep, 1);
CVAcc3 = zeros(cstep, 1); CVAcc4 = zeros(cstep, 1);
CVAcc5 = zeros(cstep, 1);   CVAcc6 = zeros(cstep, 1);
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrain, datasetTrain, options);
    CVAcc1(i) = cv;
    if(cv>bestcv1)
        bestcv1=cv;
        bestc1=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv1, bestc1);
options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc1)];
model1=svmtrain2(labelsTrain, datasetTrain, options);
w1 = model1.sv_coef' * model1.SVs;
[predicted1, acc1, score1] = svmpredict(labelsTest, datasetTest, model1);
%%
datasetTrainLong = sparse([trainPLong; trainNLong]);
datasetTestLong = sparse([testPLong; testNLong]);
labelsTrainLong = [ones(size(trainPLong, 1), 1); -1*ones(size(trainNLong, 1), 1)];
labelsTestLong = [ones(size(testPLong, 1), 1); -1*ones(size(testNLong, 1), 1)];
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrainLong, datasetTrainLong, options);
    CVAcc2(i) = cv;
    if(cv>bestcv2)
        bestcv2=cv;
        bestc2=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv2, bestc2);
options = ['-m 4000 -t 0 -q' ' -c ', num2str(bestc2)];
model2 = svmtrain2(labelsTrainLong, datasetTrainLong, options);
w2 = model2.sv_coef' * model2.SVs;
[predicted2, acc2, score2] = svmpredict(labelsTestLong, datasetTestLong, model2);
%%
datasetTrainLog = sparse([log(1+trainP); log(1+trainN)]);
datasetTestLog = sparse([log(1+testP); log(1+testN)]);
%
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrain, datasetTrainLog, options);
    CVAcc3(i) = cv;
    if(cv>bestcv1)
        bestcv3=cv;
        bestc3=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv3, bestc3);
options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc3)];
model3=svmtrain2(labelsTrain, datasetTrainLog, options);
w3 = model3.sv_coef' * model3.SVs;
[predicted3, acc3, score3] = svmpredict(labelsTest, datasetTestLog, model3);
%%
[datasetTrainWeighted, featWeight] = WeightFeaturesTrain(trainP, trainN);
datasetTestWeighted = WeightFeaturesTest([testP; testN], featWeight);
%
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrain, datasetTrainWeighted, options);
    CVAcc4(i) = cv;
    if(cv>bestcv4)
        bestcv4=cv;
        bestc4=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv4, bestc4);
options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc4)];
model4=svmtrain2(labelsTrain, datasetTrainWeighted, options);
w4 = model4.sv_coef' * model4.SVs;
[predicted4, acc4, score4] = svmpredict(labelsTest, datasetTestWeighted, model4);
%%
ratioLim = 1.4; 
[vocSelected, wordCountSelected] = SelectVocabulary(vocP, vocN, wordCountP, wordCountN, ratioLim);
trainPSelected = GetFeatureMatrix(trainPFilename, vocSelected);
trainNSelected = GetFeatureMatrix(trainNFilename, vocSelected);
testPSelected = GetFeatureMatrix(testPFilename, vocSelected);
testNSelected = GetFeatureMatrix(testNFilename, vocSelected);
%%
datasetTrainSelected = sparse([trainPSelected; trainNSelected]);
datasetTestSelected = sparse([testPSelected; testNSelected]);
%
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrain, datasetTrainSelected, options);
    CVAcc5(i) = cv;
    if(cv>bestcv5)
        bestcv5=cv;
        bestc5=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv5, bestc5);
options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc5)];
model5=svmtrain2(labelsTrain, datasetTrainSelected, options);
w5 = model5.sv_coef' * model5.SVs;
[predicted5, acc5, score5] = svmpredict(labelsTest, datasetTestSelected, model5);
%%
[datasetTrainWeighted2, featWeight2] = WeightFeaturesTrain(trainPSelected, trainNSelected);
datasetTestWeighted2 = WeightFeaturesTest([testPSelected; testNSelected], featWeight2);
%
for i=1:cstep    
    options=['-m 4000 -q -t 0 -v ', num2str(FoldNo), ' -c ', num2str(c(i))];
    cv=svmtrain2(labelsTrain, datasetTrainWeighted2, options);
    CVAcc6(i) = cv;
    if(cv>bestcv6)
        bestcv6=cv;
        bestc6=c(i);        
    end
end
fprintf('\tbestrate for linear=%g\n\tbestc=%g\n\t\n\n\n\n\n', bestcv6, bestc6);
options=['-m 4000 -t 0 -q' ' -c ', num2str(bestc6)];
model6=svmtrain2(labelsTrain, datasetTrainWeighted2, options);
w6 = model6.sv_coef' * model6.SVs;
[predicted6, acc6, score6] = svmpredict(labelsTest, datasetTestWeighted2, model6);
%%
allPredicted = {predicted1, predicted2, predicted3, predicted4, predicted5, predicted6};
contingencyTables = CreateContingencyTable(allPredicted, labelsTest);
%%
howManyWords = 20;
[sortedW, sortedIndices] = sort(w4');
wordsForGoodReview = flipud(voc(sortedIndices((end-howManyWords+1):end)));
strengthForGoodReview = flipud(sortedW((end-howManyWords+1):end))*-1;
wordsForBadReview = voc(sortedIndices(1:howManyWords));
strengthForBadReview = sortedW(1:howManyWords)*-1;