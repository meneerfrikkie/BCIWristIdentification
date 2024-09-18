%% Experiment Name and Patient specification
ExperimentName = "Exp_LDA_ANOVA_BayesianOptimization_Linux";
rng(1); 

%Variables that vary per patient allowing quick interchanging
PatientID = "P2";
ChosenTableString = 'IPD_PLVTable'; 

 
% Determine the folder path for storing results specific to the experiment and patient
% The path is created based on the operating system and the specified PatientID and ExperimentName.
if ispc
    % For Windows systems, use backslashes in the file path
    folderPath = fullfile(sprintf('..\\OwnResults\\%sRH\\%s', PatientID, ExperimentName));
    
    % Check if the folder exists; if not, create it
    % This ensures that results have a designated location to be stored.
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
    
elseif ismac || isunix
    % For macOS systems, use forward slashes in the file path
    folderPath = fullfile(sprintf('../OwnResults/%sRH/%s', PatientID, ExperimentName));
    
    % Check if the folder exists; if not, create it
    % This ensures that results have a designated location to be stored.
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
end

%% Generation of IDP and PLV Value's
% Define PatientIDs
PatientID = char(PatientID);
PatientIDs = {PatientID}; 

% Define the base folder path where results are stored
baseFolderPath = fullfile('..', 'OwnResults');

% Flag to check if processing is needed
processNeeded = false;

% Loop through each patient to check if their files exist
for i = 1:length(PatientIDs)
    PatientID = PatientIDs{i};
    
    % Define the patient-specific folder path
    patientFolderPath = fullfile(baseFolderPath, [PatientID 'RH'], 'MatlabGeneratedData');
    
    % Define filenames for the .mat files
    IPDMatFile = fullfile(patientFolderPath, 'IPDTable.mat');
    PLVMatFile = fullfile(patientFolderPath, 'PLVTable.mat');
    IPD_PLVMatFile = fullfile(patientFolderPath, 'IPD_PLVTable.mat');
    
    % Check if all required files exist for this patient
    if exist(IPDMatFile, 'file') && exist(PLVMatFile, 'file') && exist(IPD_PLVMatFile, 'file')
        % Files exist, skip generation
        disp(['Files for patient ' PatientID ' already exist. Skipping generation.']);
        continue;  % Skip to the next patient
    else
        % Files are missing, processing is needed
        processNeeded = true;
        disp(['Files for patient ' PatientID ' are missing. Processing needed.']);
        break;  % Exit the loop as we need to process files for this patient
    end
end

% Call GenerateIPD_PLVTables only if processing is needed
if processNeeded
    GenerateIPD_PLVTables(PatientIDs);
else
    disp('All required files already exist and were skipped as per user input.');
end

%% Load a specific patients data to allow Classification learn to Use specific data 
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

%% ANOVA one way but determining the best number of features for highest accuracy
columnNames = ChosenTable.Properties.VariableNames;
predictorNames = columnNames(1,1:end-1);
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


%Feature selection
startingNumberofFeatures = 1; 
stepsize = 20; 
% totalNumberofFeatures = 100; 
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
    
    %Determine which iteration it is at 
    disp(size(iterationspredictors));

    % Define the LDA model function for Bayesian Optimization
    ldaModel = @(params)fitcdiscr(iterationspredictors, response, ...
        'Delta', params.Delta, ...
        'Gamma', params.Gamma, ...
        'CrossVal', 'on', ...
        'CVPartition', cvPartition, ... 
        'KFold', 10);

    
    % Define the optimization variables
    optimVars = [
        optimizableVariable('Delta', [0, 1]), ... % Range for Delta
        optimizableVariable('Gamma', [0, 1])  ... % Range for Gamma
        ];
    
    % Define the objective function for Bayesian optimization
    minfn = @(params)kfoldLoss(ldaModel(params));
    
    % Run Bayesian Optimization
    results = bayesopt(minfn, optimVars, ...
        'MaxObjectiveEvaluations', 30, ...
        'Verbose', 0, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus', ... % Corrected comma
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

        LDAModel = fitcdiscr(XtrainFold, YtrainFold, ...
        'Delta', bestParams.Delta, ...
        'Gamma', bestParams.Gamma);
    
        YtestPred = predict(LDAModel, XtestFold);
    
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

%% Store the plot and its corresponding data 
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

%% Select ideal number of features
numFeaturesToKeep = 50; %Features that will determine cross-validation results

includedPredictorNames = predictors.Properties.VariableNames(featureIndex(1:numFeaturesToKeep));
predictors = predictors(:,includedPredictorNames);
reducedPredictors = predictors(:,includedPredictorNames);

%% Storing the Selected Features
storedPredictorNames = includedPredictorNames';


% Construct the filename using the specified format
fileName = sprintf('SelectedFeatures_%d.mat', ...
                   numFeaturesToKeep);

% Full path to save the .mat file in the AnovaFeatureSelection folder
fullFilePath = fullfile(anovaFolderPath, fileName);

% Save the arrays to the .mat file
save(fullFilePath, 'storedPredictorNames');

%% Hyperparameter tuning
% Define the LDA model function for Bayesian Optimization
    ldaModel = @(params)fitcdiscr(reducedPredictors, response, ...
        'Delta', params.Delta, ...
        'Gamma', params.Gamma, ...
        'CrossVal', 'on', ...
        'CVPartition', cvPartition, ... 
        'KFold', 10);
    
    % Define the optimization variables
    optimVars = [
        optimizableVariable('Delta', [0, 1]), ... % Range for Delta
        optimizableVariable('Gamma', [0, 1])  ... % Range for Gamma
        ];
    
    % Define the objective function for Bayesian optimization
    minfn = @(params)kfoldLoss(ldaModel(params));
    
    % Run Bayesian Optimization
    results = bayesopt(minfn, optimVars, ...
        'MaxObjectiveEvaluations', 30, ...
        'Verbose', 1, ...
        'IsObjectiveDeterministic', false, ...
        'AcquisitionFunctionName', 'expected-improvement-plus');
    
    % Extract the best hyperparameters
    bestParams = bestPoint(results);

%% Store the hyperparameters 
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

%% Stratified K-Fold Cross-Validation of Combined Table
% Define the number of folds for cross-validation
numFolds = 10; % Number of folds for cross-validation

% Use the full combined table for cross-validation
xtrain = reducedPredictors;
ytrain = response;

% Initialize arrays to hold metrics for each fold
foldAccuracy = zeros(numFolds, 1);
foldPrecision = zeros(numFolds, 1);
foldRecall = zeros(numFolds, 1);
foldF1Score = zeros(numFolds, 1);

% Perform stratified cross-validation
for fold = 1:numFolds
    % Extract the training and test sets for the current fold
    trainIndices = cvPartition.training(fold);
    testIndices = cvPartition.test(fold);

    XtrainFold = xtrain(trainIndices, :);
    YtrainFold = ytrain(trainIndices);
    XtestFold = xtrain(testIndices, :);
    YtestFold = ytrain(testIndices);

    % Train the LDA model on the training set of the current fold
    LDAModel = fitcdiscr(XtrainFold, YtrainFold);

    % Predict labels on the test data for the current fold
    YtestPred = predict(LDAModel, XtestFold);

    % Calculate the accuracy for the current fold
    foldAccuracy(fold) = sum(YtestPred == YtestFold) / length(YtestFold);
    
    % Calculate confusion metrics for the current fold
    [precision, recall, f1Score, confusionAccuracy] = ConfusionMetrics(YtestFold, YtestPred);
    
    % Store average metrics across all classes for this fold
    foldPrecision(fold) = mean(precision);
    foldRecall(fold) = mean(recall);
    foldF1Score(fold) = mean(f1Score);
end

meanAccuracy = mean(foldAccuracy);
meanPrecision = mean(foldPrecision);
meanRecall = mean(foldRecall);
meanF1Score = mean(foldF1Score);

% Display the average cross-validation metrics
disp(['Average Cross-Validation Accuracy: ', num2str(meanAccuracy * 100), '%']);
disp(['Average Cross-Validation Precision: ', num2str(meanPrecision * 100), '%']);
disp(['Average Cross-Validation Recall: ', num2str(meanRecall * 100), '%']);
disp(['Average Cross-Validation F1 Score: ', num2str(meanF1Score * 100), '%']);
%% Storing of Stratified Cross-Validation 
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

% Save the arrays to the .mat file
save(savePath, 'foldAccuracy', 'foldPrecision', 'foldRecall', 'foldF1Score','meanAccuracy','meanPrecision','meanRecall','meanF1Score');

