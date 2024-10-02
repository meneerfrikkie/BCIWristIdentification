clc;
% FeatureName = {'0-200', '200-400', '400-600', '500-800', '800-1000'};
% Count = [10, 5, 15, 11, 12];
% 
% rankedFeaturesTable = table(FeatureName', Count', 'VariableNames', {'FeatureName', 'Count'});
% save('test_features.mat', 'rankedFeaturesTable');



matfile = "D:/Github/BCIWristIdentification2/OwnResults/ExperimentsResults/Exp1_LinearSVM_ANOVA_ChannelPair3_SlidingWindow/SortedFeaturesRanked/PLVTable_RankedOccuringFeaturesTimestamps.mat";

data = load(matfile).rankedFeaturesTable;
timestamps = data.Count; 

    PlotFeatureUsage(matfile,30)


% PlotFeatureUsage('test_features.mat', 10);
