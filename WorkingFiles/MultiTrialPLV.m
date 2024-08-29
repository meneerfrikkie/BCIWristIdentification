function combinedPLVResults = MultiTrialPLV(data, CH_pairs, CH_selection, t1, t2, times, class, patientID)
    % MultiTrialPLV performs Phase Locking Value (PLV) analysis on multiple trials.
    % The function processes each trial individually, appends the results to a combined table,
    % and adds a class variable to each row in the final table.
    %
    % Parameters:
    %   data         - 3D matrix containing EEG data (trials x time x channels)
    %   CH_pairs     - Cell array of channel pairs for analysis
    %   CH_selection - Selected channel pairs for analysis
    %   t1           - Start time of the analysis window (in ms)
    %   t2           - End time of the analysis window (in ms)
    %   times        - Time array corresponding to the data
    %   class        - Class label to be added to each row in the results
    %   patientID    - String representing the patient ID for saving results
    %
    % Returns:
    %   combinedPLVResults - Table containing the combined PLV results for all trials

    % Initialize an empty table to store all PLV results
    combinedPLVResults = table(); 
    
    % Determine the number of trials in the data
    numTrials = size(data, 1);
    
    % Loop over each trial
    for trial = 1:numTrials
        % Process the current trial using the SingleTrialPLV function
        singleTrialPLV = SingleTrialPLV(data(trial, :, :), CH_selection, CH_pairs, t1, t2, times);
        
        % Add the class variable to the last column of the results
        singleTrialPLV.Class = repmat(class, height(singleTrialPLV), 1);
        
        % Concatenate the result vertically to the combinedPLVResults table
        combinedPLVResults = [combinedPLVResults; singleTrialPLV]; 
    end
    
    % Define the output directory dynamically using the patient ID
    outputDir = fullfile('..', 'OwnResults', [patientID 'RH'], 'MatlabGeneratedData');
    
    % Create the directory if it doesn't exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Define the filename based on the current date and time
    outputFilename = fullfile(outputDir, ['CombinedPLVResults_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat']);
    
    % Save the combined PLV results table to a .mat file
    save(outputFilename, 'combinedPLVResults');
    
    % Notify the user that the data has been saved
    fprintf('Combined PLV results table saved to %s\n', outputFilename);
end
