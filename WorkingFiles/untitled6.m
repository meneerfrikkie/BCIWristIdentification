
PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};

GenerateIPD_PLVTables(PatientIDs)

%% 
Exp1_SVM_ANOVA
Exp_LDA_Linux
Exp_SVM_BD 
Exp_LDA_BD

%% 

PatientID = 'P4'; 
Data = 'GetReady'; 
ChannelPair = 1; 

filepath = sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\%s\\IPDTable%d.mat', PatientID,Data,ChannelPair)

IPDTable = load(filepath).IPDTable;

filepath = sprintf('..\\OwnResults\\%sRH\\MatlabGeneratedData\\%s\\PLVTable%d.mat', PatientID,Data,ChannelPair)
PLVTable = load(filepath).PLVTable;

