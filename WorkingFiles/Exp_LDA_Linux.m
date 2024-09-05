%% Experiment Name and Patient specification
% Set the name of the experiment and specify the patient
% This string identifies the specific experiment setup, including the method and optimization used.
ExperimentName = "Exp_LDA";

% Define patient-specific variables for easy swapping between patients
% PatientID specifies the patient being analyzed in this experiment.
PatientID = "P1";

% ChosenTableString indicates the table being used for feature selection (e.g., IDPTable, PLVTable).
ChosenTableString = "IPDTable"; 

% Feature selection parameters
% These variables control how many features are selected and used in the model.
startingNumberofFeatures = 1;  % Starting point for feature selection
stepsize = 1;                  % Increment in the number of features selected
totalNumberofFeatures = 1;      % Total features used for this specific run

% Number of features to retain after feature selection
% This defines how many features will be kept for evaluating cross-validation results.
numFeaturesToKeep = 10; 

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

%% Table Generation of Required Patient 
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


%% Simple LDA Classification of Combined Table
% Extract features and labels
predictor = IPD_PLVTable{:, 1:end-1};  % Features
response = IPD_PLVTable.Class;         % Labels

% Split the data into a training set and a test set (75% training, 25% test)
cv = cvpartition(response, 'HoldOut', 0.25);
predictor_train = predictor(training(cv), :);
response_train = response(training(cv), :);
predictor_test = predictor(test(cv), :);
response_test = response(test(cv), :);

% Train the LDA model on the training set
finalLDAModel = fitcdiscr(predictor_train, response_train);

% Predict labels on the training data
trainPredictedLabels = predict(finalLDAModel, predictor_train);

% Predict labels on the test data
testPredictedLabels = predict(finalLDAModel, predictor_test);

% Calculate the training accuracy
trainAccuracy = sum(trainPredictedLabels == response_train) / length(response_train) * 100;

% Calculate the test accuracy
testAccuracy = sum(testPredictedLabels == response_test) / length(response_test) * 100;

% Display the training and test accuracy
fprintf('Final LDA model training accuracy: %.2f%%\n', trainAccuracy);
fprintf('Final LDA model test accuracy: %.2f%%\n', testAccuracy);
%% Stratified K-Fold Cross-Validation of Combined Table
% Define the number of folds for cross-validation
numFolds = 10; % Number of folds for cross-validation
rng(1); % Fixed seed for consistent results

% Use the full combined table for cross-validation
xtrain = predictor;
ytrain = response;

% Create a stratified partition object
cvPartition = cvpartition(ytrain, 'KFold', numFolds, 'Stratify', true);

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
filename = sprintf('%s_EvaluationMetrics.mat',ChosenTableString);

% Specify the path where you want to save the file
savePath = fullfile(stratifiedCrossValidationPath, filename);

% Check if the folder exists, if not, create it
if ~exist(stratifiedCrossValidationPath, 'dir')
    mkdir(stratifiedCrossValidationPath);
end

% Save the arrays to the .mat file
save(savePath, 'foldAccuracy', 'foldPrecision', 'foldRecall', 'foldF1Score','meanAccuracy','meanPrecision','meanRecall','meanF1Score');



