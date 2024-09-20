% File: AnalyseFeaturesPerDirectory
% Select the main folder containing the experiment subfolders
clc;
mainFolderPath = uigetdir('', 'Select the Main Folder Containing Experiment Subfolders');

if mainFolderPath == 0
    disp('User canceled the operation');
    return;
end

% Get a list of all subfolders in the main folder
subFolders = dir(fullfile(mainFolderPath, 'Exp*'));
subFolders = subFolders([subFolders.isdir]); % Keep only directories

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
            % Process the file
            disp(['Processing file: ', matFilePath]);
            rankedFeaturesTable = FrikkiesAnalyseFeatures(matFilePath);
            rankedFeaturesTableTimestamps = AnalyseFeaturesForTimestamps(matFilePath);
        end
    end
end
