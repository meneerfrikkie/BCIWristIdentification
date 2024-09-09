%% Load the selected .mat file
[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
dataTable = load(fullfile(path, file)).dataTable;

%% Extract the "Selected Feature Names" column
selectedFeaturesCell = dataTable{:,"Selected Feature Names"};

% Flatten the cell array to get a list of all selected features
allFeatures = [selectedFeaturesCell{:}];

%% Count the occurrences of each feature
[uniqueFeatures, ~, idx] = unique(allFeatures);
uniqueFeatures = uniqueFeatures';
featureCounts = accumarray(idx, 1);

% Sort the features by count in descending order
[sortedCounts, sortIdx] = sort(featureCounts, 'descend');
sortedFeatures = uniqueFeatures(sortIdx);

% Remove the suffix "-5000-8000" from each feature name
sortedFeatures = regexprep(sortedFeatures, '-5000-8000$', '');

% Create a table to display the sorted features and their counts
sortedFeatureCountTable = table(sortedFeatures, sortedCounts, ...
    'VariableNames', {'FeatureName', 'Count'});

% Display the sorted results
clc
disp('Feature Occurrences (Sorted):');
disp(sortedFeatureCountTable);

%% Plotting of a Bar Graph (Horizontal)
figure;
barh(flip(sortedCounts), 'FaceColor', [0.2 0.4 0.6]);

% Set the y-axis labels to feature names
set(gca, 'YTickLabel', flip(sortedFeatures), 'YTick', 1:numel(sortedFeatures), ...
    'FontSize', 10);

% Add labels and title
ylabel('Feature Name');
xlabel('Count');
title('Feature Occurrences (Sorted)');

% Adjusting the figure size for better readability
set(gcf, 'Position', [100, 100, 1200, 600]);  % [left, bottom, width, height]
grid on;