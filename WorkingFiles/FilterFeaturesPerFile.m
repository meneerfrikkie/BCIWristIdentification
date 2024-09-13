%% Load the selected .mat file
clc

[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

rankedFeaturesTable = load(fullfile(path, file)).rankedFeaturesTable;
minOccurrence = 4;

%% Filter features based on the minimum occurrence (minOccurrence)
filteredTable = rankedFeaturesTable(rankedFeaturesTable.Count >= minOccurrence, :);

% Initialize a map to track patients and their recommended features
patientFeatureMap = containers.Map();

% Iterate over the filtered features and their patient lists
for i = 1:height(filteredTable)
    featureName = filteredTable.FeatureName{i};
    patientIDs = filteredTable.PatientIDs{i};

    % Ensure each patient is linked to their corresponding features
    for j = 1:numel(patientIDs)
        patientID = patientIDs{j};

        if isKey(patientFeatureMap, patientID)
            % Append the feature if the patient already exists
            patientFeatureMap(patientID) = [patientFeatureMap(patientID), {featureName}];
        else
            % Create a new entry for the patient
            patientFeatureMap(patientID) = {featureName};
        end
    end
end

% Convert the map keys (patients) and values (features) to arrays
allPatients = keys(patientFeatureMap);
allRecommendedFeatures = values(patientFeatureMap);

%% Extract the numeric parts of patient IDs and sort them properly
patientNumbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), allPatients);  % Extract patient numbers
[~, sortIdx] = sort(patientNumbers);  % Sort based on the numeric values of patient IDs

sortedPatients = allPatients(sortIdx);
sortedRecommendedFeatures = allRecommendedFeatures(sortIdx);

%% Create a table with PatientID and RecommendedFeatures columns
recommendedFeaturesTable = table(sortedPatients', sortedRecommendedFeatures', ...
    'VariableNames', {'PatientID', 'RecommendedFeatures'});

%% Display the recommended features for each patient
disp('Recommended Features per Patient:');
disp(recommendedFeaturesTable);