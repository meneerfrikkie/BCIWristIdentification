

function filteredTable = filterTimeSlotsTable(dataTable,count)

%     dataTable = load("../OwnResults/P1RH/MatlabGeneratedData/GetReady/IPDTable2.mat").IPDTable;
% 
%     count = 21; 

    
    % Load the selected .mat file
    timeSlotTable = load("../OwnResults/ExperimentsResults/Getting Read and Hold Movement Window/Exp1_LDA_ANOVA_ChannelPair3_SlidingWindow/SortedFeaturesRanked/PLVTable_RankedOccuringFeaturesTimestamps.mat").rankedFeaturesTable;

    timeSlots = {};

    for i = 1:size(timeSlotTable,1)
        if timeSlotTable(i,2).Count > count
            timeSlots{1,end+1} = timeSlotTable(i,1).FeatureName;
        end 
    end 

%     timeSlots = {'0-300'}; 
    
    %Need to get the column names of the actual dataTable 
    columnNames = dataTable.Properties.VariableNames;

    % Initialize a logical array to store whether each column matches a time slot
    selectedColumns = false(1, numel(columnNames));
    
    % Loop through each time slot and check if it's part of any column name
    for i = 1:length(timeSlots)
        selectedColumns = selectedColumns | contains(columnNames, timeSlots{i});
    end
    
    % Filter the table based on the selected columns
    filteredTable = [dataTable(:, selectedColumns),dataTable(:,end)];
    
    % Display the filtered table
    %disp(filteredTable);
end 

