





[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
dataTable_IPD = load(fullfile(path, file)).rankedFeaturesTable;

[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
dataTable_PLV = load(fullfile(path, file)).rankedFeaturesTable;

%% Analyze teh features 
IPDTablePairs = dataTable_IPD.FeatureName; 
PLVTablePairs = dataTable_PLV.FeatureName; 

index = []; 

for i = 1:length(IPDTablePairs)
    %Reverse the channel pairs    
    disp(i)
    channels = CheckChannelPairs(IPDTablePairs(i))
    ch1 = channels{1};
    ch2 = channels{2};
    pair = sprintf('%s-%s', ch2, ch1);
    if ismember(IPDTablePairs(i),PLVTablePairs) || ismember(pair,PLVTablePairs)
        index(end+1,1) = i; 
%     else 
%             disp(channels)
    end 
end 


size(index)



