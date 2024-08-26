function [] = EFI_Multiple_CH_data_ExtractSave(subjectname, hand, Channel_selection, events, Dataset_suffix, dir, endchar)
% ========================================================================
% Author:               A K Mohamed 
% Date:                 26 Dec 2020
% ------------------------------------------------------------------------
%
% Function to extract selected CHs from dataset with R&L movements combined 
% for a given test subject
% Right hand only data must be combined and saved into one dataset
% Any amount of CHs can be selected 
%
% 1)    load EEGlab dataset for specific test subject ('subjectname') and
%       'hand' with all ICs and RH or LH movements only.
% 2)    Extract data for WE movements only based on event 'S21' (WE).
%       This is passed to function via vector 'events'
%       Extract and reshape data only for pre-selected channels
%       ('Channel_selection').
% 4)    Extract data for WF movements only based on event 'S22' (WF). 
%       Extract and reshape data only for pre-selected channels
%       ('Channel_selection').
% 3)    Save WE and WF datasets along with time array
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
foldername = strcat(subjectname, hand);
subjecthand = strcat(foldername);
filename = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix ,'.set');
filepath = dir;
EEG = pop_loadset( 'filename', filename , 'filepath', filepath);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );


% Next, Separate data into WE and WF hand data
% Extract reduced CHs from WE and WF data (CHs are consistent for WE
% and WF datasets (order and number)
% ----------------------------------------------------------------------
WE_event = events(1,:); 
WF_event = events(2,:); 
  
% Extract WE movements
% -------------------------------------------------------------------------
EEG = pop_selectevent( EEG, 'type',{WE_event},'deleteevents','off','deleteepochs','on','invertepochs','off');
datasetname = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix , '_', 'WE');
%filename = strcat(dir, datasetname, '.set');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'savenew', filename ,'gui','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'gui','off');
EEG = eeg_checkset( EEG );
data_WE = GetChannelDataEEGLAB(EEG, Channel_selection);

% go back to dataset with both WE and WF movements
% -------------------------------------------------------------------------
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
EEG = eeg_checkset( EEG );

% Extract WF movements
% -------------------------------------------------------------------------
EEG = pop_selectevent( EEG, 'type',{WF_event},'deleteevents','off','deleteepochs','on','invertepochs','off');
datasetname = strcat(subjecthand, '_epochs_filt2_ICAEOG_', Dataset_suffix , '_', 'WF');
%filename = strcat(dir, datasetname, '.set');
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'savenew', filename ,'gui','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', datasetname,'gui','off');
EEG = eeg_checkset( EEG );
data_WF = GetChannelDataEEGLAB(EEG, Channel_selection);

 
% Time Array
% ----------------------------------------------------------------------
times = EEG.times;


% Saving
% ----------------------------------------------------------------------
filename = strcat(dir, 'MatlabGeneratedData', endchar, subjectname, hand,'_Data_MultipleCH_',Dataset_suffix, '.mat');
save(filename, 'data_WE', 'data_WF','times');

return
