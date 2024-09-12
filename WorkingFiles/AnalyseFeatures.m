function AnalyseFeatures(matFilePath)
    % Load the selected .mat file
    dataTable = load(matFilePath).dataTable;

    % Extract the "Selected Feature Names" column
    selectedFeaturesCell = dataTable{:,"Selected Feature Names"};

    % Flatten the cell array to get a list of all selected features
    allFeatures = [selectedFeaturesCell{:}];
    % allFeatures = regexprep(allFeatures, '^([^-]+-[^-]+)-.*$', '$1');
    % Uncomment above line if you want to remove the time stamps of the
    % features

    % Count the occurrences of each feature
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
    title('Ranked Occuring Features');

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