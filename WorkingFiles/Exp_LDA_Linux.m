




ExperimentName = "Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow";
Data  = 'GetReady'; 
ChannelPair = 3;
rng(1); % Fixed seed for consistent results

countTimeSlot = 0;
countChannels = 0;

% Define all patient IDs and table names
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = {'PLVTable','IPDTable'};
for p = 1:length(PatientIDs)
    for c = 1:length(ChosenTableStrings)
        clearvars -except PatientIDs ChosenTableStrings ExperimentName countTimeSlot countChannels ChannelPair Data p c

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
                experimentdatafilepath = sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\%s\\IPDTable%d.mat', PatientID,Data,ChannelPair);
                IPDTable = load(experimentdatafilepath).IPDTable;
                experimentdatafilepath = sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\%s\\PLVTable%d.mat', PatientID,Data,ChannelPair); 
                PLVTable = load(experimentdatafilepath).PLVTable;
                %IPD_PLVTable = load(sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\IPD_PLVTable.mat', PatientID)).IPD_PLVTable;

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
        
        %Feature selection
        startingNumberofFeatures = 1; 
        stepsize = 1; 
        totalNumberofFeatures = 200; 
        %totalNumberofFeatures = length(predictorNames); 
        
        predictors = ChosenTable(:, predictorNames);
        response = ChosenTable.Class;
        
        predictors = standardizeMissing(predictors, {Inf, -Inf});
        predictorMatrix = normalize(predictors);
        newPredictorMatrix = zeros(size(predictorMatrix));
        
        for i = 1:size(predictorMatrix, 2)
                newPredictorMatrix(:,i) = predictorMatrix{:,i};

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
        highestAccuraciesNumberFeatures = [];
        HighestincludedPredictorNames = {};

        HighestAccuracyBestParam = [];
                   
        HighestfoldAccuracies = [];
        HighestfoldPrecisions = []; 
        HighestfoldRecalls = []; 
        HighestfoldF1Scores = []; 
          
        
        numFolds = 10; % Number of folds for cross-validation
        cvPartition = cvpartition(response, 'KFold', numFolds, 'Stratify', true);
        highestAccuracy = 0; 
        %if c == 2 || c == 1
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
                    
                    accuracies = [accuracies, mean(foldAccuracy)];
    
                    if (floor(mean(foldAccuracy) * 10000) / 10000) >= (floor(highestAccuracy * 10000) / 10000)
    
                        if (floor(mean(foldAccuracy) * 10000) / 10000) > (floor(highestAccuracy * 10000) / 10000)
                            highestAccuracy = mean(foldAccuracy);
                            %Reset the varaibles for the new highest accuracy
                            highestAccuraciesNumberFeatures = i;
                            HighestincludedPredictorNames = {includedPredictorNames};
                            HighestfoldAccuracies = foldAccuracy;
                            HighestfoldPrecisions = foldPrecision';
                            HighestfoldRecalls = foldRecall';
                            HighestfoldF1Scores = foldF1Score';
                        elseif (floor(mean(foldAccuracy) * 10000) / 10000) == (floor(highestAccuracy * 10000) / 10000)
                            %Assing with the new highest stuff 
                            highestAccuraciesNumberFeatures = [highestAccuraciesNumberFeatures,i];
                            HighestincludedPredictorNames(end+1) = {includedPredictorNames};
                            HighestfoldAccuracies = [HighestfoldAccuracies,foldAccuracy];
                            HighestfoldPrecisions = [HighestfoldPrecisions,foldPrecision']; 
                            HighestfoldRecalls = [HighestfoldRecalls,foldRecall']; 
                            HighestfoldF1Scores = [HighestfoldF1Scores,foldF1Score'];
    
                        end
                        disp(['Average Cross-Validation Accuracy For ', num2str(i),': ', num2str(mean(foldAccuracy) * 100), '%']);
                        disp(['Average Cross-Validation Precision ', num2str(i),': ', num2str(mean(foldPrecision) * 100), '%']);
                        disp(['Average Cross-Validation Recall: ', num2str(i),': ', num2str(mean(foldRecall) * 100), '%']);
                        disp(['Average Cross-Validation F1-Score: ', num2str(i),': ', num2str(mean(foldF1Score) * 100), '%']);
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
            csvFileName = sprintf('%s_%d_%d_%d.csv', ...
                              ChosenTableString,startingNumberofFeatures, stepsize, totalNumberofFeatures);
    
            anovaFolderPath = fullfile(folderPath, 'AnovaFeatureSelection');
    
            anovaFolderPath = fullfile(anovaFolderPath,ChosenTableString);
                            
            % Check if the folder exists, if not, create it
             if ~exist(anovaFolderPath, 'dir')
                mkdir(anovaFolderPath);
             end
            
            % Full path to save the .mat file in the AnovaFeatureSelection folder
            fullFilePath = fullfile(anovaFolderPath, fileName);
    
            fullFilePathCSV = fullfile(anovaFolderPath, csvFileName);
            accuracyAndFeatures = table(accuracies, numberofFeatures, 'VariableNames', {'Accuracy', 'NumberOfFeatures'});
            
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
            save(fullFilePathCSV,'accuracies','numberofFeatures');
            writetable(accuracyAndFeatures, fullFilePathCSV);
            
            % Save the plot with the constructed filename
            saveas(gcf, fullPlotPath);
            saveas(gcf, fullPlotPathPNG);
    
            for f = 1:length(highestAccuraciesNumberFeatures)
                        storedPredictorNames = HighestincludedPredictorNames(1,f);
    
                        % Construct the filename using the specified format
                        fileName = sprintf('SelectedFeatures_%d.mat',highestAccuraciesNumberFeatures(f));
                        csvFilename = sprintf('SelectedFeatures_%d.csv',highestAccuraciesNumberFeatures(f));
                        
                        % Full path to save the .mat file in the AnovaFeatureSelection folder
                        fullFilePath = fullfile(anovaFolderPath, fileName);
                        fullFilePathCSV = fullfile(anovaFolderPath,csvFilename);
                        
                        % Save the arrays to the .mat file
                        save(fullFilePath, 'storedPredictorNames');
                        % writecell(storedPredictorNames, fullFilePathCSV)
                        
                        
                        %Store the results of the stratified k-fold cross-validation 
                        stratifiedCrossValidationPath = fullfile(folderPath, 'Stratified_K-Fold_CrossValidation');
                        
                        stratifiedCrossValidationPath = fullfile(stratifiedCrossValidationPath,ChosenTableString);
                        
                        % Create a filename based on the feature selection parameters
                        filename = sprintf('%s_EvaluationMetrics_%d.mat',ChosenTableString,highestAccuraciesNumberFeatures(f));
                        csvFilename = sprintf('%s_EvaluationMetrics_%d.csv',ChosenTableString,highestAccuraciesNumberFeatures(f));
                        
                        % Specify the path where you want to save the file
                        savePath = fullfile(stratifiedCrossValidationPath, filename);
                        savePathCSV = fullfile(stratifiedCrossValidationPath,csvFilename); 
                        
                        % Check if the folder exists, if not, create it
                        if ~exist(stratifiedCrossValidationPath, 'dir')
                            mkdir(stratifiedCrossValidationPath);
                        end
                        
                        foldAccuracy = HighestfoldAccuracies(:,f);
                        foldPrecision = HighestfoldPrecisions(:,f);
                        foldRecall = HighestfoldRecalls(:,f);
                        foldF1Score = HighestfoldF1Scores(:,f);
                        meanAccuracy = mean(HighestfoldAccuracies(:,f));
                        meanPrecision = mean(HighestfoldPrecisions(:,f));
                        meanRecall = mean(HighestfoldRecalls(:,f));
                        meanF1Score = mean(HighestfoldF1Scores(:,f)); 
                        
                        % Save the arrays to the .mat file
                        save(savePath, 'foldAccuracy', 'foldPrecision', 'foldRecall', 'foldF1Score','meanAccuracy','meanPrecision','meanRecall','meanF1Score');
                        % Combine the metrics into a table
                        evaluationMetricsTable = table(foldAccuracy, foldPrecision, foldRecall, foldF1Score, ...
                                                       'VariableNames', {'Accuracy', 'Precision', 'Recall', 'F1Score'});
                        
                        % Append mean values as a new row if needed
                        meanRow = table(meanAccuracy, meanPrecision, meanRecall, meanF1Score, ...
                                        'VariableNames', {'Accuracy', 'Precision', 'Recall', 'F1Score'});
                        
                        % Optionally add the mean row to the table for completeness
                        evaluationMetricsTable = [evaluationMetricsTable; meanRow];
                        
                        % Save the table to the CSV file
                        writetable(evaluationMetricsTable, savePathCSV);
            end
        %end 
    end

end 