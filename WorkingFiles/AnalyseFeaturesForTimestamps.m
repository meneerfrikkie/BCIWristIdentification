function [rankedFeaturesTable] = AnalyseFeaturesForTimestamps(matFilePath)
    % Load the selected .mat file
    dataTable = load(matFilePath).dataTable;

    sizeTable = size(dataTable, 1);
    i = 1; 
    % Loop and remove repeat patientIDs 
    while i < sizeTable 
        disp(i)
        if strcmp(dataTable{i, 1}, dataTable{i + 1, 1})
           dataTable(i + 1, :) = []; 
           sizeTable = sizeTable - 1; 
           if i == 1
               i = 1; 
           else
                i = i - 1;
           end 
           disp('deleted')
        else 
            i = i + 1;
        end 
    end 

    % Extract the "Selected Feature Names" column
    selectedFeaturesCell = dataTable{:,"Selected Feature Names"};

    % Flatten the cell array to get a list of all selected features
    allFeatures = [selectedFeaturesCell{:}];
    
    % Modify feature names to extract only the timestamps (e.g., 7700-8000)
    % The regular expression captures the timestamp portion
    allFeatures = regexprep(allFeatures, '^[^-]+-[^-]+-([^-]+-[^-]+)-.*$', '$1');
    
    % Count the occurrences of each timestamp
    [uniqueFeatures, ~, idx] = unique(allFeatures);
    uniqueFeatures = uniqueFeatures';
    featureCounts = accumarray(idx, 1);

    % Sort the features by count in descending order
    [sortedCounts, sortIdx] = sort(featureCounts, 'descend');
    sortedFeatures = uniqueFeatures(sortIdx);

    % Create a table to display the sorted features and their counts
    rankedFeaturesTable = table(sortedFeatures, sortedCounts, ...
        'VariableNames', {'FeatureName', 'Count'});

    % Display the sorted results
    disp('Feature Occurrences (Sorted):');
    disp(rankedFeaturesTable);

    % Extract the prefix (e.g., 'PLV', 'IPD_PLV') from the original file name
    [~, fileName, ~] = fileparts(matFilePath);
    prefix = regexp(fileName, '^[A-Z_]+(?=Table)', 'match', 'once'); % Capture everything before 'Table'

    % Generate a new file name with the prefix
    currentDate = datestr(now, 'yyyymmdd'); % Get the current date
    newFileName = sprintf('%sTable_RankedOccuringFeaturesChannels', prefix);

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
end
