function IDP = SingleTrialIDPDiffFormat(data, CH_selection, CH_pairs, t1, t2, times)
    % SingleTrialIDP - Function to calculate mean, std, and variance for each channel pair
    % Input:
    %   data - Matrix with each column corresponding to a channel
    %   CH_selection - Cell array of channel names corresponding to the columns in data
    %   CH_pairs - Cell array of channel pairs for which to calculate statistics
    %   t1 - Start time index
    %   t2 - End time index
    %   times - Vector with time points corresponding to the data
    
    % Initialize variables
    numPairs = length(CH_pairs);
    varNames = cell(1, numPairs * 3); % To store variable names for the table
    modified_CH_pairs = cell(size(CH_pairs));

    % Loop through each element in CH_pairs
    for i = 1:length(CH_pairs)
        % Get the current pair
        pair = CH_pairs{i};
        
        % Format the modified pair
        modified_pair = sprintf('%s-%d-%d', pair, t1, t2);
        
        % Store the modified pair in the new cell array
        modified_CH_pairs{i} = modified_pair;
    end


    % Create variable names for each channel pair with '-mean', '-std', '-variance'
    for i = 1:numPairs
        varNames{3*i-2} = [modified_CH_pairs{i} '-mean'];
        varNames{3*i-1} = [modified_CH_pairs{i} '-std'];
        varNames{3*i}   = [modified_CH_pairs{i} '-variance'];
    end

    % Initialize the table with a single row for all the channel pair statistics
    IDP = table('Size', [1, numPairs * 3], ...
                'VariableTypes', repmat({'double'}, 1, numPairs * 3), ...
                'VariableNames', varNames);

    % Process each channel pair
    for i = 1:numPairs
        % Get the channel pair and corresponding indices
        channels = CheckChannelPairs(CH_pairs(i));
        ch1 = channels(1);
        ch2 = channels(2);

        % Find column indices in the data matrix
        col1 = find(strcmp(CH_selection, ch1));
        col2 = find(strcmp(CH_selection, ch2));

        if isempty(col1) || isempty(col2)
            error('Channel names %s or %s not found in CH_selection.', ch1, ch2);
        end

        % Extract data for the specific channel and calculate the instantaneous phase
        data1 = SingleTrialChannelIP(data(1,:,col1),t1,t2,times);
        data2 = SingleTrialChannelIP(data(1,:,col2),t1,t2,times);

        % Compute statistics
        %IPD = mod((data1-data2 + pi),2*pi) - pi;
        IPD = abs(data1-data2); 

        meanValue = mean(IPD);
        stdValue = std(abs(IPD));
        varianceValue = var(abs(IPD));

        % Store results in the table
        IDP{1, 3*i-2} = meanValue;
        IDP{1, 3*i-1} = stdValue;
        IDP{1, 3*i}   = varianceValue;
    end
end
