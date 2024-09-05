ExperimentName = "Exp1_SVM_ANOVA";
rng(1); % Fixed seed for consistent results
% Define all patient IDs and table names
PatientIDs = {'P2'};
ChosenTableStrings = {'PLVTable', 'IPDTable', 'IPD_PLVTable'};
for p = 1:length(PatientIDs)
    for c = 1:length(ChosenTableStrings)
        clearvars -except PatientIDs ChosenTableStrings ExperimentName p c

        %Variables that vary per patient allowing quick interchanging
        PatientID = PatientIDs{p};
        ChosenTableString = ChosenTableStrings{c}; 

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
        predictorNames = columnNames(1,1:end-1);
        isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
        
        
        %Feature selection
        startingNumberofFeatures = 1; 
        stepsize = 20; 
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
        highestAccuracy = 0; 

        for i = startingNumberofFeatures:stepsize:totalNumberofFeatures
            includedPredictorNames = predictors.Properties.VariableNames(featureIndex(1:i));
            iterationspredictors = predictors(:,includedPredictorNames);
            numberofFeatures = [numberofFeatures, i]; 
        
            disp(size(iterationspredictors));

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
                    'Standardize', true);
            
                YtestPred = predict(SVMModel, XtestFold);
            
                foldAccuracy(fold) = sum(YtestPred == YtestFold) / length(YtestFold);
                % Calculate confusion metrics for the current fold
                [precision, recall, f1Score, confusionAccuracy] = ConfusionMetrics(YtestFold, YtestPred);
                
                % Store average metrics across all classes for this fold
                foldPrecision(fold) = mean(precision);
                foldRecall(fold) = mean(recall);
                foldF1Score(fold) = mean(f1Score);
            end
                
                accuracies = [accuracies, mean(foldAccuracy)];

                if mean(foldAccuracy) >= highestAccuracy
                    highestAccuracy = mean(foldAccuracy);
                    disp(['Average Cross-Validation Accuracy For ', num2str(i),': ', num2str(mean(foldAccuracy) * 100), '%']);
                    disp(['Average Cross-Validation Precision ', num2str(i),': ', num2str(mean(foldPrecision) * 100), '%']);
                    disp(['Average Cross-Validation Recall: ', num2str(i),': ', num2str(mean(foldRecall) * 100), '%']);
                    disp(['Average Cross-Validation F1-Score: ', num2str(i),': ', num2str(mean(foldF1Score) * 100), '%']);

                    
                    anovaFolderPath = fullfile(folderPath, 'AnovaFeatureSelection');

                    anovaFolderPath = fullfile(anovaFolderPath,ChosenTableString);
                        
                    % Check if the folder exists, if not, create it
                    if ~exist(anovaFolderPath, 'dir')
                        mkdir(anovaFolderPath);
                    end
                    
                    storedPredictorNames = includedPredictorNames';

                    % Construct the filename using the specified format
                    fileName = sprintf('SelectedFeatures_%d.mat',i);
                    
                    % Full path to save the .mat file in the AnovaFeatureSelection folder
                    fullFilePath = fullfile(anovaFolderPath, fileName);
                    
                    % Save the arrays to the .mat file
                    save(fullFilePath, 'storedPredictorNames');
                    
                    
                    %Store the results of the stratified k-fold cross-validation 
                    stratifiedCrossValidationPath = fullfile(folderPath, 'Stratified_K-Fold_CrossValidation');
                    
                    stratifiedCrossValidationPath = fullfile(stratifiedCrossValidationPath,ChosenTableString);
                    
                    % Create a filename based on the feature selection parameters
                    filename = sprintf('%s_EvaluationMetrics_%d.mat',ChosenTableString,i);
                    
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
        
    end 
end