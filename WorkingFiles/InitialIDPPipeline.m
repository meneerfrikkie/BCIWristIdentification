
%CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','Cz-FC3','Cz-C3','Cz-CP3','CPz-FC3','CPz-C3','CPz-CP3'}; 

CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','CPz-FC3','CPz-C3','CPz-CP3'};

CH_selection = checkChannelPairs(CH_pairs); 

process_eeg_data({'P1'},CH_selection);

%Go for multi trial in multi trial the function for single trial
%calculation will be done 
%% 
% Prompt the user to load a .mat file containing the data
    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
data_WE = data.data_WE;
SingleTrialIDPTable = SingleTrialIDP(data_WE(1,:,:),CH_selection,CH_pairs,5000,8000,data.times);

