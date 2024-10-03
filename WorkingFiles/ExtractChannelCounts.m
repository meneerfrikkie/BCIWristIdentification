% Load the .mat file (replace with the correct path)
matfile = "/Users/muaawiyah/Desktop/Investigation/OwnResults/Exp1_LinearSVM_ANOVA_ChannelPair3_SlidingWindow/Exp1_LinearSVM_ANOVA_ChannelPair3_SlidingWindow/SortedFeaturesRanked/PLVTable_RankedOccuringFeatures_20241002.mat";
data = load(matfile).rankedFeaturesTable;

countValues = [data{:, 2}];

% Store unique count values
uniqueValues = unique(countValues);

% Sort the unique values in ascending order
sortedValues = sort(uniqueValues);

% Get the path of the .mat file
[filePath, ~, ~] = fileparts(matfile);

% Loop through each value in sortedValues
for i = 1:length(sortedValues)
    % Get features above the current sorted value
    channelPairs = GetFeaturesAboveCount(data, sortedValues(i));

    uniqueChannels = CheckChannelPairs(channelPairs);

    countForChannels = zeros(1, length(uniqueChannels));

    % Count occurrences for each unique channel
    for k = 1:length(uniqueChannels)
        for j = 1:length(channelPairs)
            dashIndices = strfind(channelPairs{j}, '-');
            if strcmp(channelPairs{j}(1:dashIndices-1), uniqueChannels{k}) || strcmp(channelPairs{j}(dashIndices+1:end), uniqueChannels{k})
                countForChannels(k) = countForChannels(k) + 1;
            end
        end
    end

    % Sort the channels based on their count in descending order
    [~, countForChannelsIndex] = sort(countForChannels, 'descend');
    uniqueChannels = uniqueChannels(countForChannelsIndex);
    countForChannels = countForChannels(countForChannelsIndex);

    % Normalize counts to percentage
    countForChannels = (countForChannels ./ max(countForChannels)) * 100;

    % Create a bar plot
    figure;
    bar(countForChannels);

    % Set x-axis tick labels to the channel names
    xticks(1:length(uniqueChannels));
    xticklabels(uniqueChannels);

    % Add labels and title
    xlabel('Channels');
    ylabel('Count');
    title(['Channel Count Histogram for Sorted Value: ', num2str(sortedValues(i))]);

    % Rotate x-axis labels for better visibility
    xtickangle(45);

    % Save the figure with a unique filename that includes the sorted value count
    saveFileName = fullfile(filePath, ['ChannelCountHistogram_SortedValue_' num2str(sortedValues(i)) '.png']);
    saveas(gcf, saveFileName);

    % Close the figure to free up memory
    close(gcf);
end