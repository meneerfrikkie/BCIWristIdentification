clc;
PatientID = 'P1';

% Define the channel pairs to be analyzed
CH_pairs = GenerateAllChannelPairs();

% Select the channel pairs that are available in the dataset
CH_selection = CheckChannelPairs(CH_pairs);

% Process EEG data for a specific participant
% ProcessEEGData({PatientID}, CH_selection);

% Load the selected .mat file
if ispc
    % For Windows
    data = load(sprintf('OwnData\\%sRH\\MatlabGeneratedData\\%sRH_Data_MultipleCH_ERDS.mat', PatientID, PatientID));
elseif ismac
    % For macOS
    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
    data = load(fullfile(path, file));
else
    % For other operating systems (e.g., Linux)
    disp('ERROR: Unsupported operating system. This script is designed for Windows or macOS only.');
end

% Multi-Trial Analysis for Wrist Extension (WE)
class_WE = 1;
data_WE = data.data_WE; 
WETable = MultiTrialIDP(data_WE, CH_pairs, CH_selection, 5000, 8000, data.times, class_WE, PatientID);

% Multi-Trial Analysis for Wrist Flexion (WF)
class_WF = 0;
data_WF = data.data_WF; 
WFTable = MultiTrialIDP(data_WF, CH_pairs, CH_selection, 5000, 8000, data.times, class_WF, PatientID);

% Generate PLV features for Wrist Extension (WE)
PLVTable_WE = MultiTrialPLV(data_WE, CH_pairs, CH_selection, 5000, 8000, data.times, class_WE, PatientID);

% Generate PLV features for Wrist Flexion (WF)
PLVTable_WF = MultiTrialPLV(data_WF, CH_pairs, CH_selection, 5000, 8000, data.times, class_WF, PatientID);

% Remove the 'Class' column from the PLV tables to avoid duplication
WETable.Class = [];
WFTable.Class = [];

% Combine IDP and PLV features for WE and WF
WETable = [WETable, PLVTable_WE];
WFTable = [WFTable, PLVTable_WF];

% Combine WETable and WFTable vertically to create a single table
combinedTable = [WETable; WFTable];

% Extract features and labels
X = combinedTable{:, 1:end-1};  % Features
Y = combinedTable.Class;         % Labels

% Split the data into a training set and a test set (e.g., 80% training, 20% test)
cv = cvpartition(Y, 'HoldOut', 0.2);
X_train = X(training(cv), :);
Y_train = Y(training(cv), :);
X_test = X(test(cv), :);
Y_test = Y(test(cv), :);

% Define the SVM model function for Bayesian Optimization
svmModel = @(params)fitcsvm(X_train, Y_train, ...
    'KernelFunction', 'rbf', ...
    'BoxConstraint', params.BoxConstraint, ...
    'KernelScale', params.KernelScale, ...
    'Standardize', true, ...
    'CrossVal', 'on', ...
    'KFold', 10);

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

% Train the final SVM model with the best hyperparameters on the training set
finalSVMModel = fitcsvm(X_train, Y_train, ...
    'KernelFunction', 'rbf', ...
    'BoxConstraint', bestParams.BoxConstraint, ...
    'KernelScale', bestParams.KernelScale, ...
    'Standardize', true);

% Predict labels on the training data
trainPredictedLabels = predict(finalSVMModel, X_train);

% Predict labels on the test data
testPredictedLabels = predict(finalSVMModel, X_test);

% Calculate the training accuracy
trainAccuracy = sum(trainPredictedLabels == Y_train) / length(Y_train) * 100;

% Calculate the test accuracy
testAccuracy = sum(testPredictedLabels == Y_test) / length(Y_test) * 100;

% Display the training and test accuracy
fprintf('Final SVM model training accuracy: %.2f%%\n', trainAccuracy);
fprintf('Final SVM model test accuracy: %.2f%%\n', testAccuracy);

% Save the final SVM model
outputDir = fullfile('..', 'OwnResults', [PatientID 'RH'], 'MatlabGeneratedData');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
outputFilename = fullfile(outputDir, ['FinalSVMModel_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
save(outputFilename, 'finalSVMModel');

fprintf('Final SVM model saved to %s\n', outputFilename);