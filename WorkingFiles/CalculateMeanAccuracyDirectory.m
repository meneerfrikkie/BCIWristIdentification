% File: CalculateMeanAccuracyDirectory
clc;

% Select the main folder containing the experiment subfolders
mainFolderPath = uigetdir('', 'Select the Main Folder Containing Experiment Subfolders');

if mainFolderPath == 0
    disp('User canceled the operation');
    return;
end

% Get a list of all subfolders in the main folder
subFolders = dir(fullfile(mainFolderPath, 'Exp*'));
subFolders = subFolders([subFolders.isdir]); % Keep only directories

% Initialize a table to store the results
resultsTable = table('Size', [0 4], 'VariableTypes', {'string', 'double', 'double', 'double'}, ...
                     'VariableNames', {'ExperimentName', 'OverallMeanAccuracy', 'MaxAccuracy', 'MinAccuracy'});

% Loop through each subfolder
for i = 1:numel(subFolders)
    subFolderPath = fullfile(mainFolderPath, subFolders(i).name);
    
    % Get a list of all .mat files in the current subfolder
    matFiles = dir(fullfile(subFolderPath, '*.mat'));

    % Process each .mat file if it contains "ExperimentResults" in its name
    for j = 1:numel(matFiles)
        % Get the full file path
        matFilePath = fullfile(subFolderPath, matFiles(j).name);

        % Check if the file name contains "ExperimentResults"
        if contains(matFiles(j).name, 'ExperimentResults')
            % Process the file using the CalculateMeanAccuracy function
            [overallMeanAccuracy, maxAccuracy, minAccuracy] = CalculateMeanAccuracy(matFilePath);
            
            % Create the experiment name by concatenating the subfolder name and the .mat file name
            experimentName = strcat(subFolders(i).name, '_', matFiles(j).name);

            % Append the results to the table
            newRow = {experimentName, overallMeanAccuracy, maxAccuracy, minAccuracy};
            resultsTable = [resultsTable; newRow];
            
            % Display the current results
            disp(['Processed ', experimentName]);
            disp(['Overall Mean Accuracy: ', num2str(overallMeanAccuracy), '%']);
            disp(['Maximum Accuracy: ', num2str(maxAccuracy), '%']);
            disp(['Minimum Accuracy: ', num2str(minAccuracy), '%']);
        end
    end
end

% Display the final results table
disp('Final Results Table:');
disp(resultsTable);

% Storing of the results
save(fullfile(mainFolderPath, 'ExperimentResultsSummary.mat'), 'resultsTable');
writetable(resultsTable, fullfile(mainFolderPath, 'ExperimentResultsSummary.csv'));
