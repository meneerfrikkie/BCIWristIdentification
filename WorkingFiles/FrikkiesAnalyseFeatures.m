function [rankedFeaturesTable] = FrikkiesAnalyseFeatures(matFilePath)
    % Load the selected .mat file
    dataTable = load(matFilePath).dataTable;


    sizeTable = size(dataTable,1);
    i = 1; 
    %Loop and remove repeat patientIDs 
    while i < sizeTable 
        disp(i)
        if (strcmp(dataTable{i,1}, dataTable{i+1,1}))
           dataTable(i+1,:) = []; 
           sizeTable = sizeTable -1; 
           if i == 1
               i = 1; 
           else
                i = i-1;
           end 
           disp('deleted')
        else 
            i = i+1;
        end 
    end 


    % Extract the "Selected Feature Names" and "PatientID" columns
    selectedFeaturesCell = dataTable{:,"Selected Feature Names"};
    patientIDCell = dataTable{:,"PatientID"};

    % Initialize a map to track features and their corresponding PatientIDs
    featurePatientMap = containers.Map();

    % Flatten the cell array and track PatientIDs for each feature
    for i = 1:numel(selectedFeaturesCell)
        features = selectedFeaturesCell{i}; % Get features for this patient
        patientID = patientIDCell{i};       % Get the PatientID for this row

        for j = 1:numel(features)
            feature = features{j};
            
            if isKey(featurePatientMap, feature)
                % Append the current PatientID if the feature already exists
                featurePatientMap(feature) = [featurePatientMap(feature), patientID];
            else
                % Create a new entry with the current PatientID
                featurePatientMap(feature) = {patientID};
            end
        end
    end

    % Convert the map keys and values to arrays
    allFeatures = keys(featurePatientMap);
    allPatientIDs = values(featurePatientMap);

    % Count the occurrences of each feature
    featureCounts = cellfun(@numel, allPatientIDs);

    % Sort the features by count in descending order
    [sortedCounts, sortIdx] = sort(featureCounts, 'descend');
    sortedFeatures = allFeatures(sortIdx);
    sortedPatientIDs = allPatientIDs(sortIdx);

    % Debugging: Check the lengths of the variables before creating the table
    disp('Length of sortedFeatures:');
    disp(size(sortedFeatures'));
    disp('Length of sortedCounts:');
    disp(size(sortedCounts'));
    disp('Length of patientIDStrings:');
    disp(size(sortedPatientIDs'));

    disp(sortedFeatures')
    disp(sortedCounts')
    disp(sortedPatientIDs')
    % Create a table to display the sorted features, counts, and PatientIDs
    rankedFeaturesTable = table(sortedFeatures', sortedCounts', sortedPatientIDs', ...
        'VariableNames', {'FeatureName', 'Count', 'PatientIDs'});

    % Display the sorted results
    disp('Feature Occurrences (Sorted):');
    disp(rankedFeaturesTable);
    
    % Extract the experiment name (e.g., 'Exp1_LDA_ANOVA_ChannelPairs2_SlidingWindow_IPD') 
    % from the original file name by capturing everything before '_ExperimentResults'
    [fileDir, fileName, ~] = fileparts(matFilePath);
    
    % Extract the folder name from the file directory path
    [~, folderName] = fileparts(fileDir);

    % Extract the prefix (e.g., 'IPD', 'PLV') from the original file name before 'Table'
    prefix = regexp(fileName, '[A-Z_]+(?=Table)', 'match', 'once');
    
    % Generate a new file name with the prefix
    newFileName = sprintf('%s_%s_RankedFeatures', folderName, prefix);
    
    % Define the directory path and create it if it does not exist
    outputDir = fullfile(fileparts(matFilePath), 'SortedFeaturesRanked');
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % Save the table as a .mat file
    matFilePath = fullfile(outputDir, [newFileName, '.mat']);
    save(matFilePath, 'rankedFeaturesTable');

    % Save the table as a .csv file
    csvFilePath = fullfile(outputDir, [newFileName, '.csv']);
    writetable(rankedFeaturesTable, csvFilePath);

    % Display paths to confirm saving
    fprintf('Table saved as .mat file: %s\n', matFilePath);
    fprintf('Table saved as .csv file: %s\n', csvFilePath);

    % Plotting of a Bar Graph (Horizontal)
    figure('Visible', 'off');  % Create the figure, but do not display it
    barh(flip(sortedCounts), 'FaceColor', [0.2 0.4 0.6]);

    % Set the y-axis labels to feature names
    set(gca, 'YTickLabel', flip(sortedFeatures), 'YTick', 1:numel(sortedFeatures), ...
        'FontSize', 10);

    % Add labels and title
    ylabel('Feature Name');
    xlabel('Count');
    title('Ranked Occurring Features');

    % Adjusting the figure size for better readability
    set(gcf, 'Position', [100, 100, 1200, 600]);  % [left, bottom, width, height]
    grid on;

    % Storing of the Bar Graph Figure
    figFilePath = fullfile(outputDir, [newFileName, '.fig']);
    savefig(figFilePath);

    pngFilePath = fullfile(outputDir, [newFileName, '.png']);
    saveas(gcf, pngFilePath);

    % Display paths to confirm saving
    fprintf('Figure saved as .fig file: %s\n', figFilePath);
    fprintf('Figure saved as .png file: %s\n', pngFilePath);
end
