ExperimentName = "Exp1_LDA_ANOVA_IPDTable_SlidingWindow_NumberOfFeaturesCountGreaterThan2";
rng(1); % Fixed seed for consistent results
% Define all patient IDs and table names
PatientIDs = {'P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = {'PLVTable','IPDTable'};

FeatureList = GenerateFeatureList(0);

for p = 1:length(PatientIDs)
    for c = 1:2
        clearvars -except PatientIDs ChosenTableStrings ExperimentName p c FeatureList

        %Variables that vary per patient allowing quick interchanging
        PatientID = PatientIDs{p};
        ChosenTableString = ChosenTableStrings{c}; 
        if c == 2
        %Makes the file for storing all the required information for the specific
        %experiemnt.
        if ispc
                % For Windows
                folderPath = fullfile(sprintf('..\\OwnResults\\%sRH\\%s',PatientID,ExperimentName));
                
                % Check if the folder exists; if not, create it
                if ~exist(folderPath, 'dir')
                    mkdir(folderPath);
                end
            
        
            elseif ismac || isunix 
                folderPath = fullfile(sprintf('../OwnResults/%sRH/%s',PatientID,ExperimentName));
                
                % Check if the folder exists; if not, create it
                if ~exist(folderPath, 'dir')
                    mkdir(folderPath);
                end
        end

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
        predictorNames = FeatureList;
        
        predictors = ChosenTable(:, predictorNames);
        response = ChosenTable.Class;

        numFolds = 10; % Number of folds for cross-validation
        cvPartition = cvpartition(response, 'KFold', numFolds, 'Stratify', true);
        highestAccuracy = 0; 
       
        xtrain = predictors; 
        ytrain = response; 
            
            for fold = 1:numFolds
                trainIndices = cvPartition.training(fold);
                testIndices = cvPartition.test(fold);
            
                XtrainFold = xtrain(trainIndices, :);
                YtrainFold = ytrain(trainIndices);
                XtestFold = xtrain(testIndices, :);
                YtestFold = ytrain(testIndices);

                % Compute mean and standard deviation from training data
                meanTrain = mean(table2array(XtrainFold),1);
                stdTrain = std(table2array(XtrainFold),1);

                % Standardize the training data
                standardizedPredictors = (table2array(XtrainFold) - meanTrain) ./ stdTrain;
                
                % Train the LDA model
                LDAModel = fitcdiscr(standardizedPredictors, YtrainFold);
                
                % Standardize the test data using training data statistics
                standardizedTestData = (table2array(XtestFold) - meanTrain) ./ stdTrain;
                
                % Predict using the standardized test data
                YtestPred = predict(LDAModel, standardizedTestData);

            
                foldAccuracy(fold) = sum(YtestPred == YtestFold) / length(YtestFold);
                % Calculate confusion metrics for the current fold
                [precision, recall, f1Score, confusionAccuracy] = ConfusionMetrics(YtestFold, YtestPred);
                
                % Store average metrics across all classes for this fold
                foldPrecision(fold) = mean(precision);
                foldRecall(fold) = mean(recall);
                foldF1Score(fold) = mean(f1Score);
            end
            disp(mean(foldAccuracy))
        end       
    end 
end 
       