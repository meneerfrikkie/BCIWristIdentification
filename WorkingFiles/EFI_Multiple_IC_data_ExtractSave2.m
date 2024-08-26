function [] = EFI_Multiple_IC_data_ExtractSave2(subjectname, hand, IC_selection, Dataset_suffix, dir, endchar)
% ========================================================================
% Author:               A K Mohamed 
% Date:                 26 Dec 2020
% ------------------------------------------------------------------------
%
% Function to extract selected ICs from dataset with RH movements or LH movements only 
% for a given test subject
% Right hand only data must be combined and saved into one dataset
% Any amount of ICss can be selected 
%
% 1)    load EEGlab dataset for specific test subject ('subjectname') and
%       'hand' with all ICs and RH or LH movements only.
% 2)    Extract data for WE movements only based on order of trials
%       This is passed to function via vector 'events'.
%       Extract and reshape data only for pre-selected ICs
%       ('IC_selection').
% 4)    Extract data for WF movements only based on order of trials
%       Extract and reshape data only for pre-selected ICs
%       ('IC_selection').
% 3)    Save WE and WF datasets along with time array.
%
% 'dir' used to open and save files
%
% ========================================================================


% load EEGLAB
% ----------------------------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Setup variables for loading appropriate dataset and extracting relevent
% CHs
% ----------------------------------------------------------------------

% load dataset into EEGlab with RH or LH data only
% ------------------------------------------------------------------------
subjecthand = strcat(subjectname, hand);
filename = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix ,'.set');
filepath = dir;
EEG = pop_loadset( 'filename', filename , 'filepath', filepath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );


% Next, Separate data into WE and WF hand data
% Extract reduced ICs from WE and WF data (ICs are consistent for WE
% and WF datasets
% ----------------------------------------------------------------------

% Extract WE movements
% -------------------------------------------------------------------------
EEG = pop_select( EEG,'trial',[1:20 41 42:60 81 82:100 121 122:140 161 162:180] );
datasetname = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix , '_', 'WE');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'gui','off');
EEG = eeg_checkset( EEG );
data_WE = GetICDataEEGLAB(EEG, IC_selection);

% go back to dataset with both WE and WF movements
% -------------------------------------------------------------------------
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );

% Extract WF movements
% -------------------------------------------------------------------------
EEG = pop_select( EEG,'trial',[21:40 61 62:80 101 102:120 141 142:160 181 182:200] );
datasetname = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix , '_', 'WF');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'gui','off');
EEG = eeg_checkset( EEG );
data_WF = GetICDataEEGLAB(EEG, IC_selection);

 
% Time Array
% ----------------------------------------------------------------------
times = EEG.times;


% Saving
% ----------------------------------------------------------------------
filename = strcat(dir, 'MatlabGeneratedData', endchar, subjectname, hand,'_Data_MultipleIC_',Dataset_suffix, '.mat');
save(filename, 'data_WE', 'data_WF','times');

return
