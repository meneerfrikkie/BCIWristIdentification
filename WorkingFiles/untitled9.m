% Initialize the cell array
% temp = {}; 
% 
% Define some cell arrays to add
% test1 = {'tes', 'tes', 'tes'};
% test2 = {'ss', 'ss', 'ss', 'sss'};
% test3 = {'ss', 'ssss', 'sss'};
% 
% Add each cell array to the main cell array dynamically
% temp{end+1} = test1  % Add the first cell array


PLVTable = load('..\OwnResults\P1RH\MatlabGeneratedData\PLVTable.mat').PLVTable;

X = table2array(PLVTable(:,1:end-1)); 
y = logical(PLVTable.Class); 

Z = bhattacharyyaDistance(X,y)

numFeaturesToSelect = 10; 

[~, sortedIndices] = sort(Z, 'descend');
selectedFeatures = PLVTable(:, sortedIndices(1:numFeaturesToSelect)); % Select top features


