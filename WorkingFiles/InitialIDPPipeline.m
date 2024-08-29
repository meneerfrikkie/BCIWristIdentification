
%CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','Cz-FC3','Cz-C3','Cz-CP3','CPz-FC3','CPz-C3','CPz-CP3'}; 

CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','CPz-FC3','CPz-C3','CPz-CP3'};

CH_selection = CheckChannelPairs(CH_pairs); 

ProcessEEGData({'P1'},CH_selection);

%Go for multi trial in multi trial the function for single trial
%calculation will be done 
%% Signle trials but multiple pairs 
data = load('OwnData\P1RH\MatlabGeneratedData\P1RH_Data_MultipleCH_ERDS.mat');
data_WE = data.data_WE;
SingleTrialIDP(data_WE(1,:,:),CH_selection,CH_pairs,5000,8000,data.times);
% Prompt the user to load a .mat file containing the data
    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
data_WE = data.data_WE;
SingleTrialIDPTable = SingleTrialIDP(data_WE(1,:,:),CH_selection,CH_pairs,5000,8000,data.times);
%% Multiple trials 

data = load('OwnData\P1RH\MatlabGeneratedData\P1RH_Data_MultipleCH_ERDS.mat')
data_WE = data.data_WE; 
MultipleTrialsIDP(data_WE,CH_pairs,CH_selection,5000,8000,data.times)

