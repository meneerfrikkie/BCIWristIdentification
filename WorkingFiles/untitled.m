
startingNumberofFeatures = 1; 
stepsize = 1; 
totalNumberofFeatures = 200; 

% ChannelPairNumber, DataName,startingNumberofFeatures,stepsize,totalNumberofFeatures

ChanenlPairNumbers = [1,2,3]; 
DataNames = {'GetReady','Holding','GetReadyAndHolding'};
numberFolds = [4];
for DN = 1:length(DataNames)
    for CPN = 1:length(ChanenlPairNumbers)
        disp(DN)
        disp(CPN)

        Exp_SVM_BD(ChanenlPairNumbers(CPN), DataNames{DN},startingNumberofFeatures,stepsize,totalNumberofFeatures,numberFolds)
        %ChannelPairNumber, DataName,startingNumberofFeatures,stepsize,totalNumberofFeatures
        Exp1_SVM_ANOVA(ChanenlPairNumbers(CPN), DataNames{DN},startingNumberofFeatures,stepsize,totalNumberofFeatures,numberFolds)
        %ChannelPairNumber, DataName,startingNumberofFeatures,stepsize,totalNumberofFeatures,countedTimeSlots
        Exp_LDA_Linux(ChanenlPairNumbers(CPN), DataNames{DN},numberFolds)
        %ChannelPairNumber, DataName, numberFolds
        Exp_LDA_BD(ChanenlPairNumbers(CPN), DataNames{DN},numberFolds)
    end 
end 

% numberFolds = [4];
% 
% for j = 1:length(DataNames)
% for i = 1:length(numberFolds)
%  Exp1_SVM_ANOVA(ChanenlPairNumbers(3), DataNames{j},startingNumberofFeatures,stepsize,totalNumberofFeatures,0,numberFolds(i))
% end 
% end 
 %ChannelPairNumber, DataName,startingNumberofFeatures,stepsize,totalNumberofFeatures,countedTimeSlots, numberFolds


% %timeslots
% data = load("D:\Github\BCIWristIdentification2\OwnResults\ExperimentsResults\Linear SVM Get Ready and Hold Movement Window\Exp1_LinearSVM_ANOVA_ChannelPair3_GetReadyAndHolding_SlidingWindow\SortedFeaturesRanked\PLVTable_RankedOccuringFeatures_20241003.mat").rankedFeaturesTable;
% 
% counts = data.Count
% 
% % counts = [29,31];
% 
% arr_no_duplicates = unique(counts, 'stable');
% 
% for arrnd = 2:length(arr_no_duplicates)
%     Exp1_SVM_ANOVA(ChanenlPairNumbers(3), DataNames{3},startingNumberofFeatures,stepsize,totalNumberofFeatures,arr_no_duplicates(arrnd))
% end 
