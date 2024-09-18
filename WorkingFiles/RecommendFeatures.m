function RecommendFeatures(matFilePath, rankedFeaturesTable, minOccurrence)
    % Check if the input table contains required variables
    if ~ismember('FeatureName', rankedFeaturesTable.Properties.VariableNames) || ...
       ~ismember('PatientIDs', rankedFeaturesTable.Properties.VariableNames) || ...
       ~ismember('Count', rankedFeaturesTable.Properties.VariableNames)
        error('The input table must contain "FeatureName", "PatientIDs", and "Count" variables.');
    end
    
    % Filter features based on the minimum occurrence (minOccurrence)
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

    % Extract the numeric parts of patient IDs and sort them properly
    patientNumbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), allPatients);  % Extract patient numbers
    [~, sortIdx] = sort(patientNumbers);  % Sort based on the numeric values of patient IDs

    sortedPatients = allPatients(sortIdx);
    sortedRecommendedFeatures = allRecommendedFeatures(sortIdx);

    % Create a table with PatientID and RecommendedFeatures columns
    recommendedFeaturesTable = table(sortedPatients', sortedRecommendedFeatures', ...
        'VariableNames', {'PatientID', 'RecommendedFeatures'});

    % Display the recommended features for each patient
    disp('Recommended Features per Patient:');
    disp(recommendedFeaturesTable);

    % Extract the prefix (e.g., 'PLV', 'IPD_PLV') from the original file name
    [~, fileName, ~] = fileparts(matFilePath);
    prefix = regexp(fileName, '^[A-Z_]+(?=Table)', 'match', 'once'); % Capture everything before 'Table'

    % Generate a new file name with the prefix
    currentDate = datestr(now, 'yyyymmdd'); % Get the current date
    newFileName = sprintf('%sTable_RecommendedFeatures_%s', prefix, currentDate);

    % Define the directory path and create it if it does not exist
    outputDir = fullfile(fileparts(matFilePath), 'SortedFeaturesRanked');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % Save the table as a .mat file
    matFilePath = fullfile(outputDir, [newFileName, '.mat']);
    save(matFilePath, 'recommendedFeaturesTable');

    % Save the table as a .csv file
    csvFilePath = fullfile(outputDir, [newFileName, '.csv']);
    writetable(recommendedFeaturesTable, csvFilePath);

    % Display paths to confirm saving
    fprintf('Table saved as .mat file: %s\n', matFilePath);
    fprintf('Table saved as .csv file: %s\n', csvFilePath);
end