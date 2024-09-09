%% Load the selected .mat file
clc

[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
dataTable = load(fullfile(path, file)).dataTable;

%% Extract the "Selected Feature Names" column
clc

selectedFeaturesCell = dataTable{:,"Selected Feature Names"};

% Flatten the cell array to get a list of all selected features
allFeatures = [selectedFeaturesCell{:}];

%% Count the occurrences of each feature

% Remove the suffix "-5000-8000" and any following text from each feature name
allFeatures = regexprep(allFeatures, '-5000-8000.*$', '');

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
clc
disp('Feature Occurrences (Sorted):');
disp(rankedFeaturesTable);

%% Storing of the Table

% Extract the prefix (e.g., 'PLV', 'IPD') from the original file name
prefix = regexp(file, '^[A-Z]+', 'match', 'once');

% Generate a new file name with the prefix
currentDate = datestr(now, 'yyyymmdd'); % Get the current date
newFileName = sprintf('%sTable_RankedOccuringFeatures_%s', prefix, currentDate);

% Save the table as a .mat file
matFilePath = fullfile(path, [newFileName, '.mat']);
save(matFilePath, 'rankedFeaturesTable');

% Save the table as a .csv file
csvFilePath = fullfile(path, [newFileName, '.csv']);
writetable(rankedFeaturesTable, csvFilePath);

% Display paths to confirm saving
fprintf('Table saved as .mat file: %s\n', matFilePath);
fprintf('Table saved as .csv file: %s\n', csvFilePath);

%% Plotting of a Bar Graph (Horizontal)
figure;
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
figFilePath = fullfile(path, [newFileName, '.fig']);
savefig(figFilePath);

pngFilePath = fullfile(path, [newFileName, '.png']);
saveas(gcf, pngFilePath);

% Display paths to confirm saving
fprintf('Figure saved as .fig file: %s\n', figFilePath);
fprintf('Figure saved as .png file: %s\n', pngFilePath);
