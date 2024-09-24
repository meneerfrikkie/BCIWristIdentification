




data = load("../OwnResults/ExperimentsResults/Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow_ChanelPairsGreaterThan3/SortedFeaturesRanked/PLVTable_RankedOccuringFeatures_20240924.mat").rankedFeaturesTable;


channelPairs = data.FeatureName';

uniqueChannels = CheckChannelPairs(channelPairs);

countForChannels = zeros(1,length(uniqueChannels));


for i = 1:length(uniqueChannels)
    for j = 1:length(channelPairs)
        dashIndices = strfind(channelPairs{j}, '-');
        if strcmp(channelPairs{j}(1:dashIndices-1),uniqueChannels{i}) || strcmp(channelPairs{j}(dashIndices+1:end),uniqueChannels{i})
        countForChannels(i) = countForChannels(i) + 1; 
        end 
    end 
end 

[~,countForChannelsIndex] = sort(countForChannels, 'descend');

uniqueChannels = uniqueChannels(countForChannelsIndex);
countForChannels = countForChannels(countForChannelsIndex);


countForChannels = (countForChannels./(max(countForChannels)))*100;

% Create a bar plot
figure;
bar(countForChannels);

% Set x-axis tick labels to the channel names
xticks(1:length(uniqueChannels));  % Set ticks at 1, 2, 3, ..., n
xticklabels(uniqueChannels);  % Assign corresponding channel names

% Add labels and title
xlabel('Channels');
ylabel('Count');
title('Channel Count Histogram');

% Rotate x-axis labels for better visibility (optional)
xtickangle(45);