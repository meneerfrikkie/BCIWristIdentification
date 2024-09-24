

function filteredTable = filterChannelTable(dataTable,count)
    %dataTable = load("../OwnResults/P1RH/MatlabGeneratedData/GetReady/SlidingWindow_ChannelPair2/IPDTable.mat").IPDTable;

    %dataTable = PLVTable; 
    %count = 10; 

       % Load the selected .mat file
    channelPairTable = load("../OwnResults/ExperimentsResults/Getting Read and Hold Movement Window/Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow/SortedFeaturesRanked/PLVTable_RankedOccuringFeatures_20240921.mat").rankedFeaturesTable;


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
        disp(channePairs{i})
        for j = 1:length(columnNames)-1
            dashIndices = strfind(columnNames{j}, '-');
            %disp(dashIndices)
            if strcmp(columnNames{j}(1:dashIndices(2)-1), channePairs{i})
                selectedColumns(j) = strcmp(columnNames{j}(1:dashIndices(2)-1), channePairs{i});
            end 
        end 
    end
    
    % Filter the table based on the selected columns
    filteredTable = [dataTable(:, selectedColumns),dataTable(:,end)];
    
    % Display the filtered table
    %disp(filteredTable);
end 