

function filteredTable = filterTimeSlotsTable(dataTable,count)
% 
%     dataTable = load("../OwnResults/P1RH/MatlabGeneratedData/GetReady/SlidingWindow_ChannelPair2/IPDTable.mat").IPDTable;
% 
%     count = 21; 

    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file for the TimeSlots');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
    
    % Load the selected .mat file
    timeSlotTable = load(fullfile(path, file)).rankedFeaturesTable;

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
    filteredTable = dataTable(:, selectedColumns);
    
    % Display the filtered table
    disp(filteredTable);
end 