# EEG Data Classification for Wrist Movements 
### Description This project classifies wrist extension and wrist flexion using phase information from EEG data. The custom functions provided help preprocess EEG signals, select relevant channel pairs, and compute features necessary for classification. 
--- 

## Custom Functions

| Function Name | Inputs | Outputs | Description/Results | 
|-----------------------------|---------------------------------------------------------|---------------------------------------------------|-------------------------------------------------------------------------------------|
|CheckChannelPairs|`CH_pairs` (cell array containing string elements of the form`'<channel1>-<channel2>'`) | `requiredChannels` (cell array) | Returns a list of unique channels needed to cover all specified channel pairs. |
|GetChannelKeys|`channel_names` (cell array) | `keys` (numeric array) | Converts a list of EEG channel names to their corresponding numeric keys based on a predefined channel map. |
|MultiTrialIDP|`data` (3D matrix of EEG data with the format of `trials x time x channels`), `CH_pairs` (cell array), `CH_selection` (cell array), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (Time array corresponding to data), `class` (Class label. 1->WE, 0->WF), `patientID` (String representing patient ID) | `combinedResults` (Table containing results for all trials) | Performs Instantaneous Phase Difference (IPD) analysis on multiple trials for all channel pairs, combines results into a table, and adds a class label.|
|MultiTrialPLV|`data` (3D matrix of EEG data being `trials x time x channels`), `CH_pairs` (cell array), `CH_selection` (cell array), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (Time array corresponding to data), `class` (Class label. 1->WE, 0->WF), `patientID` (String representing patient ID) | `combinedResults` (Table containing results for all trials) | Performs Phase Locking Value (PLV) analysis on multiple trials for all channel pairs, combines results into a table, and adds a class label.|
|ProcessEEGData|`subjectnames` (cell array), `CH_selection_string` (cell array) | None | Processes EEG data for multiple subjects based on channel selections and saves the results. |
|SingleTrialChannelIP|`trial` (column vector containing magnitude of eeg signal with respect to the times vector), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (column vector for timestamps of each entry in the trial vector) | `instantaneousPhase` (vector) | Computes the instantaneous phase of a single trial channel within a specified time range using Hilbert transform. Unwraps the phase to make it continuous.|
|SingleTrialChannelIPNoUnwrap|`trial` (column vector containing magnitude of eeg signal with respect to the times vector), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (column vector for timestamps of each entry in the trial vector) | `instantaneousPhase` (vector) | Computes the instantaneous phase of a single trial channel within a specified time range using Hilbert transform.|
|SingleTrialIDP|`data` (matrix), `CH_selection` (cell array), `CH_pairs` (cell array), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (column vector for timestamps of each entry in the trial vector) | `IDP` (table) | Calculates mean, standard deviation, and variance of the difference between instantaneous phases for each channel pair.|
|SingleTrialIDPDiffFormat|`data` (matrix), `CH_selection` (cell array), `CH_pairs` (cell array), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (vector) | `IDP` (table) | Calculates mean, standard deviation, and variance of the difference between instantaneous phases for each channel pair. |
|SingleTrialPLV|`data` (matrix), `CH_selection` (cell array), `CH_pairs` (cell array), `t1` (start time of analysis window), `t2` (end time of analysis window), `times` (column vector for timestamps of each entry in the trial vector) | `PLV` (table) | Computes the Phase-Locking Value (PLV) for each channel pair based on the instantaneous phase difference. |
|GenerateAllChannelPairs|None|`channel_pairs` (cell array)|This function generates all possible pairs of EEG channels, excluding self-pairs, and returns them as strings in the format `'<channel1>-<channel2>'`. The function starts by defining a list of EEG channel names from a predefined subset of interest (e.g., channels relevant for a specific analysis like motor control). It then iterates over all possible combinations of these channels, forming pairs where the first channel is not equal to the second (i.e., no self-pairs). Each pair is stored as a string in the output cell array `channel_pairs`.|


### Example Usage

## Function: `CheckChannelPairs` 
**Description**:  Returns a list of unique channels needed to cover all specified channel pairs. Below is an example of how the function is utilised to determine the required channels to cover all specified channel pairs.

CH_pairs = {'FCz-FC3', 'FCz-C3', 'FCz-CP3', 'CPz-FC3', 'CPz-C3', 'CPz-CP3'};
CH_selection = CheckChannelPairs(CH_pairs); //Returns: {'FCz', 'FC3', 'C3', 'CP3', 'CPz'}

## Function: `GetChannelKeys` 
**Description**:  Converts a list of EEG channel names to their corresponding numeric keys based on a predefined channel map. Below is an example of how the function is utilised to obtain the required numerical value for each channel. The function determines the channels associated key based on a predefined map and is not sensitive.

CH_selection_string = {'C3', 'C4', 'fp1'};
CH_selection = GetChannelKeys(CH_selection_string); \\Returns: [8, 24, 1]

## Function: `MultiTrialIDP` 
**Description**: Performs Instantaneous Phase Difference (IPD) analysis on multiple trials for all channel pairs, combines results into a table, and adds a class label. Below is an example of the function is utilised to obtain the required mean, std and variance of each trial for a singular patient and for all channels. 

data = rand(2, 100, 4); 
CH_pairs = {'FCz-FC3', 'FCz-C3', 'CPz-FC3', 'CPz-C3'};
CH_selection = CheckChannelPairs(CH_pairs);
t1 = 0; 
t2 = 500; 
times = linspace(0, 999, 100); 
class = 1; 
patientID = 'P1';
Table = MultiTrialIDP(data, CH_pairs, CH_selection, t1, t2, times, patientID) //Return table containing each channel pairs mean, std and variance for each trial. 

## Function: `MultiTrialPLV` 
**Description**: Performs Phase Locking Value (PLV) analysis on multiple trials for all channel pairs, combines results into a table, and adds a class label. Below is an example of the function is utilised to obtain the required PLV of each trial for a singular patient and for all channels. 

data = rand(2, 100, 4); 
CH_pairs = {'FCz-FC3', 'FCz-C3', 'CPz-FC3', 'CPz-C3'};
CH_selection = CheckChannelPairs(CH_pairs);
t1 = 0; 
t2 = 500; 
times = linspace(0, 999, 100); 
class = 1; 
patientID = 'P1';
Table = MultiTrialPLV(data, CH_pairs, CH_selection, t1, t2, times, patientID) //Return table containing each channel pairs PLV for each trial. 

## Function: `ProcessEEGData` 
**Description**: Processes EEG data for multiple subjects based on channel selections and saves the results. Below is an example of the function is utilised to obtain the required .mat files containing the EEG data of the patients. 

CH_pairs = GenerateAllChannelPairs();
CH_selection = checkChannelPairs(CH_pairs);
ProcessEEGData({'P1'},CH_selection);

## Function: `SingleTrialChannelIP` 
**Description**: Computes the instantaneous phase of a single trial channel within a specified time range using Hilbert transform. Unwraps the phase to make it continuous. Below is an example of how to use the function to obtain the instantaneous phase for a single channel and trial of a patient. 

data1 = SingleTrialChannelIP(data, t1, t2, times); //Returns: Array of instantaneous phase for each point within the allocated time slot. 

## Function: `SingleTrialChannelIPNoUnwrap` 
**Description**: Computes the instantaneous phase of a single trial channel within a specified time range using Hilbert transform. Does not unwrap the phase. Below is an example of how to use the function to obtain the instantaneous phase for a single channel and trial of a patient. 

data1 = SingleTrialChannelIPNoUnwrap(data, t1, t2, times); //Returns: Array of instantaneous phase for each point within the allocated time slot. 

## Function: `SingleTrialIDP` 
**Description**: Calculates mean, standard deviation, and variance of the difference between instantaneous phases for each channel pair. Below is an example of how to use the function to obtain the instantaneous phase for a all channels but a single trial. 

data1 = SingleTrialChannelIPNoUnwrap(data, t1, t2, times); //Returns: Table of mean, std and variance for IDP for each trial and channel. 

SingleTrialIDPTable = SingleTrialIDP(data, CH_selection, CH_pairs, 5000, 8000, times); 

## Function: `SingleTrialIDPDiffFormat` 
**Description**: Calculates mean, standard deviation, and variance of the difference between instantaneous phases for each channel pair. Below is an example of how to use the function to obtain the instantaneous phase for a all channels but a single trial. 

data1 = SingleTrialChannelIPNoUnwrap(data, t1, t2, times); //Returns: Table of mean, std and variance for IDP for each trial and channel. Stored differently as each row is a trial rather than mean, std and variance being stored on the rows. 

SingleTrialIDPTable = SingleTrialIDP(data, CH_selection, CH_pairs, 5000, 8000, times); 

## Function: `SingleTrialPLV` 
**Description**: Computes the Phase-Locking Value (PLV) for each channel pair based on the instantaneous phase difference. Below is an example of how to use the function to obtain the PLV for a all channels but a single trial. 

data1 = SingleTrialChannelIPNoUnwrap(data, t1, t2, times); //Returns: Table of mean, std and variance for IDP for each trial and channel. Stored differently as each row is a trial rather than mean, std and variance being stored on the rows. 


MultiTrialPLV(data,CH_pairs,CH_selection,5000,8000,times); //Returns: Array of each PLV for each channel pair. 


