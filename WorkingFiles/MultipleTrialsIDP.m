function combinedResults = MultipleTrialsIDP(data, CH_pairs, CH_selection, t1, t2, times)
    % Process EEG data and return the combined results table
    
    % Initialize an empty table to store all results
    combinedResults = table();  % Empty table to hold all results
    
    % Select the relevant channel pairs
    CH_selection = checkChannelPairs(CH_pairs);
    
    % Get the dimensions of the input data
    [numTrials, ~, ~] = size(data);
    
    % Loop over each trial
    for trial = 1:numTrials
        % Process a single trial using the specified function
        SingTrial = SingleTrialIDPDiffFormat(data(trial, :, :), CH_selection, CH_pairs, t1, t2, times);
        
        % Concatenate the result vertically to the combinedResults table
        combinedResults = [combinedResults; SingTrial]; % Vertically concatenate
    end
    
    % Display the final table with all results
    disp(combinedResults);
end
