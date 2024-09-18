

function filteredTable = filterChannelTable(dataTable,count)
    %dataTable = load("../OwnResults/P1RH/MatlabGeneratedData/GetReady/SlidingWindow_ChannelPair2/IPDTable.mat").IPDTable;

    %count = 21; 

    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file for the Channel Pairs');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
    
    % Load the selected .mat file
    channelPairTable = load(fullfile(path, file)).rankedFeaturesTable;

    channePairs = {};

    for i = 1:size(channelPairTable,1)
        if channelPairTable(i,2).Count > count
            channePairs{end+1,1} = channelPairTable(i,1).FeatureName;
        end 
    end 
    
    %Need to get the column names of the actual dataTable 
    columnNames = dataTable.Properties.VariableNames;

    % Initialize a logical array to store whether each column matches a time slot
    selectedColumns = false(1, numel(columnNames));
    
    % Loop through each time slot and check if it's part of any column name
    for i = 1:length(channePairs)
        selectedColumns = selectedColumns | contains(columnNames, channePairs{i});
    end
    
    % Filter the table based on the selected columns
    filteredTable = dataTable(:, selectedColumns);
    
    % Display the filtered table
    disp(filteredTable);
end 