function featureList = GeneratePairs(countLimit)


[file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
if isequal(file, 0)
    disp('User canceled the operation');
    return;
end

% Load the selected .mat file
dataTable = load(fullfile(path, file)).rankedFeaturesTable;
Features = {} ; 

for i = 1:size(dataTable,1)
    if dataTable(i,2).Count > countLimit
        Features(1,end+1) = dataTable(i,1).FeatureName; 
    end 
end 


featureList = Features; 


end 