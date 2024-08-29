function MultiTrialIDPTable = AnalyseMultiTrialIDP(data_WE, CH_selection, CH_pairs, startTime, endTime, times, patientID)
    % Function to perform Instantaneous Dynamic Phase (IDP) analysis on multiple trials.
    % The function processes 100 trials at a time and stores the results in a table.
    %
    % Parameters:
    % - data_WE: 3D matrix containing the Wrist Extension data (trials x time x channels)
    % - CH_selection: Selected channel pairs for analysis
    % - CH_pairs: Original channel pairs array for reference
    % - startTime: Start time of the analysis window (in ms)
    % - endTime: End time of the analysis window (in ms)
    % - times: Time array from the dataset
    % - patientID: String representing the patient ID to be used in the directory path

    % Number of trials in the dataset
    numTrials = size(data_WE, 1);
    
    % Initialize an empty cell array to store the results for all trials
    MultiTrialIDPTable = cell(numTrials, 1);
    
    % Loop through the trials in batches of 100
    for trialStart = 1:100:numTrials
        % Determine the end index for the current batch (should not exceed the number of trials)
        trialEnd = min(trialStart + 99, numTrials);
        
        % Loop through each trial in the current batch
        for trialIdx = trialStart:trialEnd
            % Perform IDP analysis for the current trial
            SingleTrialIDPTable = SingleTrialIDP(data_WE(trialIdx,:,:), CH_selection, CH_pairs, startTime, endTime, times);
            
            % Store the result in the MultiTrialIDPTable
            MultiTrialIDPTable{trialIdx} = SingleTrialIDPTable;
        end
        
        % Display progress
        fprintf('Processed trials %d to %d out of %d\n', trialStart, trialEnd, numTrials);
    end
    
    % Define the output directory dynamically using the patient ID
    outputDir = fullfile('..', 'OwnResults', [patientID 'RH'], 'MatlabGeneratedData');
    
    % Create the directory if it doesn't exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Define the filename based on the current date and time
    outputFilename = fullfile(outputDir, ['MultiTrialIDPTable_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
    
    % Save the MultiTrialIDPTable to a .mat file
    save(outputFilename, 'MultiTrialIDPTable');
    
    % Notify the user that the data has been saved
    fprintf('MultiTrialIDPTable saved to %s\n', outputFilename);
end