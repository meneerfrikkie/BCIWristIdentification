clc;
% FeatureName = {'0-200', '200-400', '400-600', '500-800', '800-1000'};
% Count = [10, 5, 15, 11, 12];
% 
% rankedFeaturesTable = table(FeatureName', Count', 'VariableNames', {'FeatureName', 'Count'});
% save('test_features.mat', 'rankedFeaturesTable');



matfile = "D:\Documents\GitHub\BCIWristIdentification\OwnResults\Getting Read and Hold Movement Window\Getting Read and Hold Movement Window\Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow\SortedFeaturesRanked\PLVTable_RankedOccuringFeaturesTimestamps.mat";
PlotFeatureUsage(matfile,42)

% PlotFeatureUsage('test_features.mat', 10);
