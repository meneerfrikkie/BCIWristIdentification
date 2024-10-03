clc;

matfile = "/Users/muaawiyah/Desktop/Investigation/OwnResults/Exp1_LinearSVM_ANOVA_ChannelPair3_SlidingWindow/Exp1_LinearSVM_ANOVA_ChannelPair3_SlidingWindow/SortedFeaturesRanked/PLVTable_RankedOccuringFeaturesTimestamps.mat";

countValues = [rankedFeaturesTable{:, 2}];

% Store unique count values
uniqueValues = unique(countValues);

% Sort the unique values in ascending order
sortedValues = sort(uniqueValues);

% Loop through each value in sortedValues and call PlotFeatureUsage
for i = 1:length(sortedValues)
    PlotFeatureUsage(matfile, sortedValues(i));
end

