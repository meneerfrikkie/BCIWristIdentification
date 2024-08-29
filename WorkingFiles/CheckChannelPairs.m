function requiredChannels = CheckChannelPairs(CH_pairs)
    % CheckChannelPairs - Function to return required channels to include all pairs

    % Initialize an empty cell array to hold unique channels
    uniqueChannels = {};

    % Loop through each channel pair
    for i = 1:length(CH_pairs)
        % Split the pair into individual channels
        pair = strsplit(CH_pairs{i}, '-');
        channel1 = pair{1};
        channel2 = pair{2};
        
        % Add channels to the uniqueChannels list if they are not already included
        if ~ismember(channel1, uniqueChannels)
            uniqueChannels{end+1} = channel1;
        end
        if ~ismember(channel2, uniqueChannels)
            uniqueChannels{end+1} = channel2;
        end
    end
    
    % Output the unique channels
    requiredChannels = uniqueChannels;
    
    % Display the result
    disp('Required Channels:');
    disp(requiredChannels);
end
