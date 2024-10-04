ExperimentName = "Exp1_LDA_ANOVA_SlidingWindow_ReducedPairsGreaterThan9";
rng(1); % Fixed seed for consistent results
response = [1,2,3,4,5,6,7,8,9,10];
data = [1;2;3;4;5;6;7;8;9;10];
numFolds = 10; 
for i = 1:2 
    for j = 1:2
        clearvars -except response ExperimentName numFolds i j data
        cvPartition = cvpartition(response, 'KFold', numFolds, 'Stratify', true);

        if j == 2

        xtrain = data; 
        ytrain = response; 

         trainIndices = cvPartition.training(1);
         testIndices = cvPartition.test(1);
            
         XtrainFold = xtrain(trainIndices, :);
         YtrainFold = ytrain(trainIndices);
         XtestFold = xtrain(testIndices, :);
         YtestFold = ytrain(testIndices);
        end 
    end 
end 
