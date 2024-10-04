% File: AnalyseFeaturesPerExperiment
% Select the folder containing the .mat files
clc
folderPath = uigetdir('', 'Select the Folder Containing .mat Files');

if folderPath == 0
    disp('User canceled the operation');
    return;
end

% Get a list of all .mat files in the folder
matFiles = dir(fullfile(folderPath, '*.mat'));

% Process each .mat file if it contains "ExperimentResults" in its name
for i = 1:numel(matFiles)
    % Get the full file path
    matFilePath = fullfile(folderPath, matFiles(i).name);
    
    % Check if the file name contains "ExperimentResults"
    if contains(matFiles(i).name, 'ExperimentResults')
        % Process the file
        disp(matFilePath)
        rankedFeaturesTable = AnalyseFeatures(matFilePath);
        rankedFeaturesTableTimestamps = AnalyseFeaturesForTimestamps(matFilePath);
    end
end
