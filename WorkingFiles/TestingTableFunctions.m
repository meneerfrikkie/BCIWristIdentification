ExperimentName = 'Exp1_SVM_ANOVA';
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = 'PLVTable';


PLVTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)

ExperimentName = 'Exp1_SVM_ANOVA';
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = 'IPDTable';


IPDTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)

ExperimentName = 'Exp1_SVM_ANOVA';
% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = 'IPD_PLVTable';


IPD_PLVTable_Exp1_SVM_ANOVA = CombineExperimentResults(ExperimentName,PatientIDs,ChosenTableStrings)


ExperimentName = 'Exp2_SVM_ANOVA_BayesianOptimization';
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
ChosenTableStrings = 'PLVTable';



PLVTable_Exp1_SVM_ANOVA_BayesianOptimization = CombineExperimentResultsHyperparameters(ExperimentName,PatientIDs,ChosenTableStrings)


