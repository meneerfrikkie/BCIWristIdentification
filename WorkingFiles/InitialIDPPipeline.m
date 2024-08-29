%%
clc

% Define the channel pairs to be analyzed
% Original set: {'FCz-FC3','FCz-C3','FCz-CP3','Cz-FC3','Cz-C3','Cz-CP3','CPz-FC3','CPz-C3','CPz-CP3'}
% Updated set: Removed 'Cz-*' pairs for analysis
CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','CPz-FC3','CPz-C3','CPz-CP3'};

% Select the channel pairs that are available in the dataset
% This step ensures that only valid and existing channel pairs are considered for further analysis
CH_selection = CheckChannelPairs(CH_pairs);

% Process EEG data for a specific participant
% The function 'ProcessEEGData' takes a cell array of participant IDs and the selected channel pairs as input
% Here, we process data for participant 'P1'
ProcessEEGData({'P1'}, CH_selection);

% Comment: 
% The next step involves performing calculations across multiple trials.
% For multi-trial analysis, the single-trial calculation function will be invoked within the loop.

%% Prompt a user to load a .mat file containing EEG data
clc

[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
data = load(fullfile(path, file));
disp('.mat Data File Loaded');

%% Single-Trial Analysis 
clc

% Extract the Wrist Extension (WE) data from the loaded dataset
data_WE = data.data_WE;

% Perform Instantaneous Dynamic Phase (IDP) analysis for a single trial
% SingleTrialIDP function calculates the phase differences for the selected trial, channel pairs, and time range
% Parameters:
% - data_WE(1,:,:) -> First trial data
% - CH_selection -> Selected channel pairs for analysis
% - CH_pairs -> Original channel pairs array for reference
% - 5000 -> Start time of the analysis window (in ms)
% - 8000 -> End time of the analysis window (in ms)
% - data.times -> Time array from the dataset
SingleTrialIDPTable = SingleTrialIDP(data_WE(1,:,:), CH_selection, CH_pairs, 5000, 8000, data.times);

%% Multi-Trial Analysis 
clc

% Extract the Wrist Extension (WE) data from the loaded dataset
data_WE = data.data_WE;

% Perform Instantaneous Dynamic Phase (IDP) analysis for multiple trials
% The AnalyseMultiTrialIDP function calculates phase differences for selected trials,
% channel pairs, and a specified time range.
%
% Parameters:
% - data_WE: 3D matrix containing the Wrist Extension data (trials x time x channels)
% - CH_selection: Selected channel pairs for analysis
% - CH_pairs: Original channel pairs array for reference
% - 5000: Start time of the analysis window (in milliseconds)
% - 8000: End time of the analysis window (in milliseconds)
% - data.times: Time array from the dataset
%
% Example usage:
% Perform IDP analysis on the first trial using the SingleTrialIDP function:
% SingleTrialIDPTable = SingleTrialIDP(data_WE(1,:,:), CH_selection, CH_pairs, 5000, 8000, data.times);
%
% Perform IDP analysis on all trials using the AnalyseMultiTrialIDP function:

MultiTrialIDPTable = AnalyseMultiTrialIDP(data_WE, CH_selection, CH_pairs, 5000, 8000, data.times, 'P1');

%% Example: Viewing a selected trials IDP
clc
trialNumber = 2;

% Access the data for the specified trial from MultiTrialIDPTable
disp(MultiTrialIDPTable{trialNumber}{1,2});

selectedTrialData = MultiTrialIDPTable{trialNumber};
% Display the size of the selected trial data
disp('Size of selected trial data:');
disp(size(selectedTrialData));

% Display the values of the selected trial data
disp('Values of the selected trial:');
disp(selectedTrialData);

%% Multi-Trial Analysis - Alternate Verison by Irfaan
clc

data_WE = data.data_WE; 
MultipleTrialsIDP(data_WE,CH_pairs,CH_selection,5000,8000,data.times)

