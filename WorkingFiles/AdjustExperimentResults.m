% Allow user to select the .mat file
[matFile, matPath] = uigetfile('*.mat', 'Select the MAT-file containing resultsTable');
if isequal(matFile,0)
    disp('User canceled file selection.');
    return;
end

% Load the selected MAT file
data = load(fullfile(matPath, matFile)).resultsTable;

% Define the parameters
models = ["LDA","SVM"]; 
feature_selection = {'ANOVA','BD'}; 
SlidingWindow = "SlidingWindow"; 
ChannelPairSubset = ["ChannePair2","ChannelPairs2","ChannelPair3","ChannelPairs3"]; 
tableName = ["PLVTable","IPDTable"];
reducedpairs = 'PairsGreaterthan';

% Initialize resultsTable
resultsTable = table('Size', [0 12], ...
                     'VariableTypes', {'string','string','string','double','logical', 'string','double','double','double','double','double','double'}, ...
                     'VariableNames', {'Model','Feature Selection', 'Feature extraction','Channel Pair','Sliding Window','Reduced Pairs Greater than', 'OverallMeanAccuracy', 'OverallMeanPrecision', 'OverallMeanRecall', 'OverallMeanF1Score', 'MaxAccuracy', 'MinAccuracy'});

% Populate the resultsTable based on the loaded data
for i = 1:size(data,1)
    entry = {};

    parts = split(data{i,1}, '_')';
    vitalparts = parts(1,2:end-2);

    % Store the model that is being utilized 
    entry{1,end+1} = vitalparts(1,1); 

    % Store the feature selection methodology
    entry{1,end+1} = vitalparts(1,2);

    % Store the table which was used either PLV or IPD 
    if vitalparts(1,end) == "PLVTable"
        entry{1,end+1} = "PLV"; 
    else 
        entry{1,end+1} = "IPD"; 
    end 

    number = [];

    % Determine which channel pair is being used
    pattern = "ChannelPairs(\d+)|ChannelPair(\d+)";
    for j = 1:length(vitalparts)
        tokens = regexp(vitalparts(j), pattern, 'tokens');
        if ~isempty(tokens)
            number = str2double(tokens{1}{1});
            break;
        else
            number = 1;
        end 
    end
    entry{1,end+1} = number; 

    % Check if there is a sliding window used or not 
    hasSlidingWindow = ismember("SlidingWindow", vitalparts);
    if hasSlidingWindow
        entry{1,end+1} = "Yes";
    else 
        entry{1,end+1} = "No"; 
    end 

    % Check if there was a reduction in the generated pairs 
    pattern = "PairsGreaterthan(\d+)|PairGreaterthan(\d+)";
    for j = 1:length(vitalparts)
        tokens = regexp(vitalparts(j), pattern, 'tokens');
        if ~isempty(tokens)
            number = str2double(tokens{1}{1});
            break;
        else
            number = "All pairs";  
        end 
    end
    entry{1,end+1} = number; 

    % Fill the rest of the values which will just be general table entries
    entry{1,end+1} = data.OverallMeanAccuracy(i); 
    entry{1,end+1} = data.OverallMeanPrecision(i); 
    entry{1,end+1} = data.OverallMeanRecall(i);
    entry{1,end+1} = data.OverallMeanF1Score(i);
    entry{1,end+1} = data.MaxAccuracy(i);
    entry{1,end+1} = data.MinAccuracy(i);

    resultsTable = [resultsTable;entry];
end

% Generate CSV filename based on the original MAT file name
csvFileName = strcat(extractBefore(matFile, '.mat'), '_results.csv');

% Save the resultsTable as a CSV in the same folder as the MAT file
writetable(resultsTable, fullfile(matPath, csvFileName));

disp(['Results saved to ', fullfile(matPath, csvFileName)]);