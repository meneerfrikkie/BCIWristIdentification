
ExperimentName = "Exp2_SVM_ANOVA_BayesianOptimization";
rng(1); % Fixed seed for consistent results

%Variables that vary per patient allowing quick interchanging
PatientID = "P1";
ChosenTableString = 'IPDTable'; 

 
%Makes the file for storing all the required information for the specific
%experiemnt.
if ispc
        % For Windows
        folderPath = fullfile(sprintf('..\\OwnResults\\%sRH\\%s',PatientID,ExperimentName));
        
        % Check if the folder exists; if not, create it
        if ~exist(folderPath, 'dir')
            mkdir(folderPath);
        end
    

    elseif ismac
        folderPath = fullfile(sprintf('../OwnResults/%sRH/%s',PatientID,ExperimentName));
        
        % Check if the folder exists; if not, create it
        if ~exist(folderPath, 'dir')
            mkdir(folderPath);
        end
    
end


%GenerateIPD_PLVTables(PatientID);


if ispc
        % For Windows
        % Construct the file path using sprintf
        IPDTable = load(sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\IPDTable.mat', PatientID)).IPDTable;
        PLVTable = load(sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\PLVTable.mat', PatientID)).PLVTable;
        IPD_PLVTable = load(sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\IPD_PLVTable.mat', PatientID)).IPD_PLVTable;
    elseif ismac || isunix
        IPDTable = load(sprintf('../OwnResults/%sRH/MatlabGeneratedData/IPDTable.mat', PatientID)).IPDTable;
        PLVTable = load(sprintf('../OwnResults/%sRH/MatlabGeneratedData/PLVTable.mat', PatientID)).PLVTable;
        IPD_PLVTable = load(sprintf('../OwnResults/%sRH/MatlabGeneratedData/IPD_PLVTable.mat', PatientID)).IPD_PLVTable;
end

% Use a switch statement to match the table name and assign the correct table
switch ChosenTableString
    case 'IPDTable'
        ChosenTable = IPDTable; 
    case 'PLVTable'
        ChosenTable = PLVTable; 
    case 'IPD_PLVTable'
        ChosenTable = IPD_PLVTable; 
    otherwise
        error('Table name not recognized.');
end


columnNames = ChosenTable.Properties.VariableNames;
predictorNames = columnNames(1,1:end-1);
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


%Feature selection
startingNumberofFeatures = 1; 
stepsize = 1; 
%totalNumberofFeatures = 1; 
totalNumberofFeatures = length(predictorNames); 

predictors = ChosenTable(:, predictorNames);
response = ChosenTable.Class;

predictors = standardizeMissing(predictors, {Inf, -Inf});
predictorMatrix = normalize(predictors);
newPredictorMatrix = zeros(size(predictorMatrix));

for i = 1:size(predictorMatrix, 2)
    if isCategoricalPredictor(i)
        newPredictorMatrix(:,i) = grp2idx(predictorMatrix{:,i});
    else
        newPredictorMatrix(:,i) = predictorMatrix{:,i};
    end
end
predictorMatrix = newPredictorMatrix;
responseVector = grp2idx(response);

% Rank features using ANOVA algorithm
for i = 1:size(predictorMatrix, 2)
    pValues(i) = anova1(...
        predictorMatrix(:,i), ...
        responseVector, ...
        'off');
end
[~,featureIndex] = sort(-log(pValues), 'descend');


%Generating the plot to determine the best number of features
accuracies = [];
numberofFeatures = []; 

numFolds = 10; % Number of folds for cross-validation
cvPartition = cvpartition(response, 'KFold', numFolds, 'Stratify', true);


for i = startingNumberofFeatures:stepsize:totalNumberofFeatures
    includedPredictorNames = predictors.Properties.VariableNames(featureIndex(1:i));
    iterationspredictors = predictors(:,includedPredictorNames);
    numberofFeatures = [numberofFeatures, i]; 

    disp(size(iterationspredictors))

    % Define the SVM model function for Bayesian Optimization
    svmModel = @(params)fitcsvm(iterationspredictors, response, ...
        'KernelFunction', 'rbf', ...
        'BoxConstraint', params.BoxConstraint, ...
        'KernelScale', params.KernelScale, ...
        'Standardize', true, ...
        'CrossVal', 'on', ...
        'CVPartition',cvPartition);
    
    % Define the optimization variables
    optimVars = [
        optimizableVariable('BoxConstraint', [1e-3, 1e3], 'Transform', 'log');
        optimizableVariable('KernelScale', [1e-3, 1e3], 'Transform', 'log')
        ];
    
    % Define the objective function for Bayesian optimization
    minfn = @(params)kfoldLoss(svmModel(params));
    
    % Run Bayesian Optimization without plots
    results = bayesopt(minfn, optimVars, ...
        'MaxObjectiveEvaluations', 30, ...
        'Verbose', 0, ...  % Set to 0 for minimal output
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus', ...
        'PlotFcn', []); % Suppress the plots

    
    % Extract the best hyperparameters
    bestParams = bestPoint(results);

    % Use the full combined table for cross-validation
    xtrain = iterationspredictors;
    ytrain = response;
    
    
    foldAccuracy = zeros(numFolds, 1);
    
    for fold = 1:numFolds
        trainIndices = cvPartition.training(fold);
        testIndices = cvPartition.test(fold);
    
        XtrainFold = xtrain(trainIndices, :);
        YtrainFold = ytrain(trainIndices);
        XtestFold = xtrain(testIndices, :);
        YtestFold = ytrain(testIndices);
    
        SVMModel = fitcsvm(XtrainFold, YtrainFold, ...
            'KernelFunction', 'rbf', ...
            'BoxConstraint', bestParams.BoxConstraint, ...
            'KernelScale', bestParams.KernelScale, ...
            'Standardize', true);
    
        YtestPred = predict(SVMModel, XtestFold);
    
        foldAccuracy(fold) = sum(YtestPred == YtestFold) / length(YtestFold);
    end

        accuracies = [accuracies, mean(foldAccuracy)];
end 
% Create the plot
figure; % Open a new figure window
plot(numberofFeatures, 100.*accuracies, '-o');
xlabel('Number of Features');
ylabel('Accuracy (%)');
title(sprintf('Accuracy vs Number of Features For Patient %s',PatientID));
grid on;


%Required to store the accuracies and the number of features for the
%feature selection stage. 

% Define the path for Anova Feature Selection folder
anovaFolderPath = fullfile(folderPath, 'AnovaFeatureSelection');

anovaFolderPath = fullfile(anovaFolderPath,ChosenTableString);

% Check if the folder exists, if not, create it
if ~exist(anovaFolderPath, 'dir')
    mkdir(anovaFolderPath);
end

% Construct the filename using the specified format
fileName = sprintf('%s_%d_%d_%d.mat', ...
                   ChosenTableString,startingNumberofFeatures, stepsize, totalNumberofFeatures);

% Full path to save the .mat file in the AnovaFeatureSelection folder
fullFilePath = fullfile(anovaFolderPath, fileName);

% Construct the filename using the specified format
plotFileName = sprintf('%s_%d_%d_%d.fig', ...
                       ChosenTableString,startingNumberofFeatures, stepsize, totalNumberofFeatures);
plotFileNamePNG = sprintf('%s_%d_%d_%d.png', ...
                       ChosenTableString,startingNumberofFeatures, stepsize, totalNumberofFeatures);

% Full path to save the plot in the AnovaFeatureSelection folder
fullPlotPath = fullfile(anovaFolderPath, plotFileName);
fullPlotPathPNG = fullfile(anovaFolderPath, plotFileNamePNG);
% Save the accuracies and number of features to the .mat file
save(fullFilePath, 'accuracies', 'numberofFeatures');

% Save the plot with the constructed filename
saveas(gcf, fullPlotPath);
saveas(gcf, fullPlotPathPNG);

%% 

highestAccuracy = max(accuracies); 
highAccuracyFeatures = [];
for i = 1:length(accuracies)
    if(accuracies(i) == highestAccuracy)
        highAccuracyFeatures = [highAccuracyFeatures, numberofFeatures(i)];
    end 
end 

for i = 1:length(highAccuracyFeatures)
    numFeaturesToKeep = highAccuracyFeatures(i); %Features that will determine cross-validation results
    
    includedPredictorNames = predictors.Properties.VariableNames(featureIndex(1:numFeaturesToKeep));
    reducedpredictors = predictors(:,includedPredictorNames);
    
    
    storedPredictorNames = includedPredictorNames';
    
    
    % Construct the filename using the specified format
    fileName = sprintf('SelectedFeatures_%d.mat', ...
                       numFeaturesToKeep);
    
    % Full path to save the .mat file in the AnovaFeatureSelection folder
    fullFilePath = fullfile(anovaFolderPath, fileName);
    
    % Save the arrays to the .mat file
    save(fullFilePath, 'storedPredictorNames');
    
    
    % Define the SVM model function for Bayesian Optimization
    svmModel = @(params)fitcsvm(reducedpredictors, response, ...
        'KernelFunction', 'rbf', ...
        'BoxConstraint', params.BoxConstraint, ...
        'KernelScale', params.KernelScale, ...
        'Standardize', true, ...
        'CrossVal', 'on', ...
        'CVPartition',cvPartition);
    
    % Define the optimization variables
    optimVars = [
        optimizableVariable('BoxConstraint', [1e-3, 1e3], 'Transform', 'log');
        optimizableVariable('KernelScale', [1e-3, 1e3], 'Transform', 'log')
        ];
    
    % Define the objective function for Bayesian optimization
    minfn = @(params)kfoldLoss(svmModel(params));
    
    % Run Bayesian Optimization
    results = bayesopt(minfn, optimVars, ...
        'MaxObjectiveEvaluations', 30, ...
        'Verbose', 1, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus');
    
    % Extract the best hyperparameters
    bestParams = bestPoint(results);
    
    %box constraint = 991.6607
    %kernel scale = 561.2574
    %with 50 features for P3
    
    
    % Define the path for Anova Feature Selection folder
    hyperparametertuningFolderPath = fullfile(folderPath, 'HyperParameterTuning');
    
    
    hyperparametertuningFolderPath = fullfile(hyperparametertuningFolderPath,ChosenTableString);
    
    
    % Check if the folder exists, if not, create it
    if ~exist(hyperparametertuningFolderPath, 'dir')
        mkdir(hyperparametertuningFolderPath);
    end
    
    % Construct the filename using the specified format
    fileName = sprintf('%s_TunedParameters_%d.mat', ...
                       ChosenTableString,numFeaturesToKeep);
    
    % Full path to save the .mat file in the AnovaFeatureSelection folder
    fullFilePath = fullfile(hyperparametertuningFolderPath, fileName);
    
    % Save the arrays to the .mat file
    save(fullFilePath, 'bestParams');
    
    
    numFolds = 10; % Number of folds for cross-validation
    
    % Use the full combined table for cross-validation
    xtrain = reducedpredictors;
    ytrain = response;
    
    
    
    foldAccuracy = zeros(numFolds, 1);
    foldPrecision = zeros(numFolds,1);
    foldRecall = zeros(numFolds,1);
    foldF1Score = zeros(numFolds,1); 
    
    for fold = 1:numFolds
        trainIndices = cvPartition.training(fold);
        testIndices = cvPartition.test(fold);
    
        XtrainFold = xtrain(trainIndices, :);
        YtrainFold = ytrain(trainIndices);
        XtestFold = xtrain(testIndices, :);
        YtestFold = ytrain(testIndices);
    
        SVMModel = fitcsvm(XtrainFold, YtrainFold, ...
        'KernelFunction', 'rbf', ...
        'BoxConstraint', bestParams.BoxConstraint, ...
        'KernelScale', bestParams.KernelScale, ...
        'Standardize', true);
    
        YtestPred = predict(SVMModel, XtestFold);
    
        foldAccuracy(fold) = sum(YtestPred == YtestFold) / length(YtestFold);
        [foldPrecision(fold), foldRecall(fold), foldF1Score(fold)] = EvaluateModel(YtestPred,YtestFold);
    end
    
    meanAccuracy = mean(foldAccuracy);
    disp(['Average Cross-Validation Accuracy For ', num2str(numberofFeatures(i)),': ', num2str(meanAccuracy * 100), '%']);
    disp(['Average Cross-Validation Precision ', num2str(numberofFeatures(i)),': ', num2str(mean(foldPrecision) * 100), '%']);
    disp(['Average Cross-Validation Recall: ', num2str(numberofFeatures(i)),': ', num2str(mean(foldRecall) * 100), '%']);
    disp(['Average Cross-Validation F1-Score: ', num2str(numberofFeatures(i)),': ', num2str(mean(foldF1Score) * 100), '%']);
    
    
    %Store the results of the stratified k-fold cross-validation 
    stratifiedCrossValidationPath = fullfile(folderPath, 'Stratified_K-Fold_CrossValidation');
    
    stratifiedCrossValidationPath = fullfile(stratifiedCrossValidationPath,ChosenTableString);
    
    % Create a filename based on the feature selection parameters
    filename = sprintf('%s_EvaluationMetrics_%d.mat',ChosenTableString,numFeaturesToKeep);
    
    % Specify the path where you want to save the file
    savePath = fullfile(stratifiedCrossValidationPath, filename);
    
    % Check if the folder exists, if not, create it
    if ~exist(stratifiedCrossValidationPath, 'dir')
        mkdir(stratifiedCrossValidationPath);
    end
    
    meanAccuracy = mean(foldAccuracy);
    meanPrecision = mean(foldPrecision);
    meanRecall = mean(foldRecall);
    meanF1Score = mean(foldF1Score); 
    
    % Save the arrays to the .mat file
    save(savePath, 'foldAccuracy', 'foldPrecision', 'foldRecall', 'foldF1Score','meanAccuracy','meanPrecision','meanRecall','meanF1Score');
end
