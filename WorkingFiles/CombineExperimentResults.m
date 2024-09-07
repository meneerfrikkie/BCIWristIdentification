function dataTable = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableString)

    %Defining required variables 
    TablePatientIds = {};
    NumberOfSelectedFeatures = []; %Row vector 
    SelectedFeatureNames = {}; %Row vector
    meanAccuracies = []; %Row vector 
    meanPrecisions = []; %Row Vector
    meanRecalls = []; %Row Vector
    meanF1Scores = []; %Row vector 
    foldAccuracies = []; %Row Vector 
    foldPrecisions = []; %Row Vector
    foldRecalls = []; %Row Vector
    foldF1Scores = []; %Row Vector
    
    
    counter = 1;
    
    for p = 1:length(PatientIDs)
          if ispc
             % For Windows
             folderPath = fullfile(sprintf('..\\OwnResults\\%sRH\\%s',PatientIDs{p},ExperimentName));
                elseif ismac || isunix 
             folderPath = fullfile(sprintf('../OwnResults/%sRH/%s',PatientIDs{p},ExperimentName));
          end
    
            
         %Feature Selection
            % File pattern for where the .mat is for the selected Features
            TablePathForAnovaFeatureSelection = fullfile(fullfile(folderPath,'AnovaFeatureSelection'),ChosenTableString);
            filePatternSelectedFeatures = fullfile(TablePathForAnovaFeatureSelection, 'SelectedFeatures_*.mat');
    
            % Get a list of all files matching the pattern in the specified folder
            matFiles = dir(filePatternSelectedFeatures);   
        
            % Loop through each file found
            for k = 1:length(matFiles)
                % Get the full file path
                fileName = matFiles(k).name;
                fullFilePath = fullfile(TablePathForAnovaFeatureSelection, fileName);
                
                % Load the .mat file
                fileDataFeatureSelection = load(fullFilePath);
                numberStr = regexp(fileName, '\d+', 'match');  % Extracts the number as a string
                numberOfFeatures = str2double(numberStr{1});   % Convert the string to a number
                NumberOfSelectedFeatures(end+1,1) = numberOfFeatures;
                SelectedFeatureNames{end+1,1} = fileDataFeatureSelection.storedPredictorNames(1);
    
                %Need to fill column of PatientIDs with required number of
                %repeated patientIDs to cover all the selected features
                TablePatientIds{end+1,1} = PatientIDs{p};
            end
    
         %StratifiedCross-Validation
            % File pattern for where the .mat is for the selected Features
            TablePathForCrossValidation = fullfile(fullfile(folderPath,'Stratified_K-Fold_CrossValidation'),ChosenTableString);
            filePatternCrossValidation = fullfile(TablePathForCrossValidation, sprintf('%s_EvaluationMetrics_*.mat',ChosenTableString));
    
            % Get a list of all files matching the pattern in the specified folder
            matFiles = dir(filePatternCrossValidation);   
        
            % Loop through each file found
            for k = 1:length(matFiles)
                % Get the full file path
                fileName = matFiles(k).name;
                fullFilePath = fullfile(TablePathForCrossValidation, fileName);
                
                % Load the .mat file
                fileDataCrossValidation = load(fullFilePath);
    
                meanAccuracies(end+1,1) = fileDataCrossValidation.meanAccuracy; 
                meanPrecisions(end+1,1) = fileDataCrossValidation.meanPrecision; 
                meanRecalls(end+1,1) = fileDataCrossValidation.meanRecall; 
                meanF1Scores(end+1,1) = fileDataCrossValidation.meanF1Score; 
                foldAccuracies{end+1,1} = fileDataCrossValidation.foldAccuracy; 
                foldPrecisions{end+1,1} = fileDataCrossValidation.foldPrecision; 
                foldRecalls{end+1,1} = fileDataCrossValidation.foldRecall; 
                foldF1Scores{end+1,1} = fileDataCrossValidation.foldF1Score; 
            end
    
    end 
    
    
    dataTable = table(TablePatientIds, ...
                      NumberOfSelectedFeatures, ...
                      SelectedFeatureNames, ...
                      meanAccuracies, ...
                      meanPrecisions, ...
                      meanRecalls, ...
                      meanF1Scores, ...
                      foldAccuracies, ...
                      foldPrecisions, ...
                      foldRecalls, ...
                      foldF1Scores, ...
                      'VariableNames', {'PatientID', ...
                                       'Number of Selected Features', ...
                                       'Selected Feature Names', ...
                                       'Mean Accuracy', ...
                                       'Mean Precision', ...
                                       'Mean Recall', ...
                                       'Mean F1-Score', ...
                                       'Fold Accuracy', ...
                                       'Fold Precision', ...
                                       'Fold Recall', ...
                                       'Fold F1-Score'});


        if ispc
                % For Windows
                folderPath = fullfile(sprintf('..\\OwnResults\\ExperimentsResults\\%s',ExperimentName));

                % Define the file path and name within the new folder
                % Get the current date as a string in the format YYYYMMDD
                dateStr = datestr(now, 'yyyymmdd');
                
                % Combine the filename with the date
                fileName = sprintf('%s_ExperimentResults_%s.mat',ChosenTableString ,dateStr);

                
                % Check if the folder exists; if not, create it
                if ~exist(folderPath, 'dir')
                    mkdir(folderPath);
                end
            
                % Write the table
                filePath = fullfile(folderPath, fileName);
                save(filePath, 'dataTable');
            elseif ismac || isunix 
                folderPath = fullfile(sprintf('../OwnResults/ExperimentsResults/%s',ExperimentName));

                 % Define the file path and name within the new folder
                % Get the current date as a string in the format YYYYMMDD
                dateStr = datestr(now, 'yyyymmdd');
                
                % Combine the filename with the date
                fileName = sprintf('%s_ExperimentResults_%s.mat',ChosenTableString ,dateStr);

                
                % Check if the folder exists; if not, create it
                if ~exist(folderPath, 'dir')
                    mkdir(folderPath);
                end
            
                % Write the table
                filePath = fullfile(folderPath, fileName);
                save(filePath, 'dataTable');
        end
end

