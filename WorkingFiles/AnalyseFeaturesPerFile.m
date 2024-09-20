%% Load the selected .mat file
clc

matFilePath = '/Users/muaawiyah/Desktop/Investigation/OwnResults/ExperimentsResults/Getting Read and Hold Movement Window/Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow/PLVTable_ExperimentResults_20240919.mat';

disp(['Processing file: ', matFilePath]);
rankedFeaturesTable = FrikkiesAnalyseFeatures(matFilePath);
rankedFeaturesTableTimestamps = AnalyseFeaturesForTimestamps(matFilePath);



