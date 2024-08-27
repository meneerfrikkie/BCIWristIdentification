channel_names = {'Fp1', 'Fz', 'F3', 'O2','c3'};

% Get the keys for these channels
keys = getChannelKeys(channel_names);

% Display the keys
disp(keys);


%testing process_eeg_data 
subjectnames = {'P1','P5'}; 
CH_selection = {'C3','c3','Fp1','fp1','c4','C4'};

process_eeg_data(subjectnames,CH_selection); 
disp(getChannelKeys(CH_selection))