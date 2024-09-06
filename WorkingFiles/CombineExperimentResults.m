ExperimentName = 'Exp1_SVM_ANOVA';
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = {'PLVTable'};


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
        TablePathForAnovaFeatureSelection = fullfile(fullfile(folderPath,'AnovaFeatureSelection'),'PLVTable');
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
        TablePathForCrossValidation = fullfile(fullfile(folderPath,'Stratified_K-Fold_CrossValidation'),'PLVTable');
        filePatternCrossValidation = fullfile(TablePathForCrossValidation, sprintf('%s_EvaluationMetrics_*.mat','PLVTable'));

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



