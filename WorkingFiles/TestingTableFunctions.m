% ExperimentName = 'Exp1_SVM_ANOVA';
% % PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% ChosenTableStrings = 'PLVTable';
% 
% 
% PLVTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)
% 
% ExperimentName = 'Exp1_SVM_ANOVA';
% % PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% ChosenTableStrings = 'IPDTable';
% 
% 
% IPDTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)
% 
% ExperimentName = 'Exp1_SVM_ANOVA';
% % PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% ChosenTableStrings = 'IPD_PLVTable';
% 
% 
% IPD_PLVTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)
% 
% 
ExperimentName = 'Exp1_LDA_ANOVA_SlidingWindow_ReducedPairsGreaterThan32';
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = {'IPDTable'};


for i = 1:length(ChosenTableStrings)
PLVTable_Exp1_SVM_ANOVA_BayesianOptimization = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings{i})
end 

% ExperimentName = 'Exp1_SVM_ANOVA_BayesianOptimization';
% % PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% ChosenTableStrings = {'PLVTable','IPDTable','IPD_PLVTable'};
% 
% for i = 1:length(ChosenTableStrings)
% PLVTable_Exp1_SVM_ANOVA = CombineExperimentResultsHyperparameters(ExperimentName,PatientIDs,ChosenTableStrings{i});
% end 
% ExperimentName = 'Exp2_SVM_ANOVA_ChannelPairs3';
% % PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% ChosenTableStrings = 'IPDTable';
% 
% 
% IPDTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)