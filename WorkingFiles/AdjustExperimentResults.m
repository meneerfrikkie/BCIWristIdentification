




data = load("..\OwnResults\ExperimentsResults\ExperimentResultsSummary.mat").resultsTable;


models = ["LDA","SVM"]; 
feature_selection = {'ANOVA','BD'}; 
SlidingWindow = "SlidingWindow"; 
ChannelPairSubset = ["ChannePair2","ChannelPairs2","ChannelPair3","ChannelPairs3"]; 
tableName = ["PLVTable","IPDTable"];
reducedpairs = 'PairsGreaterthan';

resultsTable = table('Size', [0 12], ...
                     'VariableTypes', {'string','string','string','double','logical', 'string','double','double','double','double','double','double'}, ...
                     'VariableNames', {'Model','Feature Selection', 'Feature extraction','Channel Pair','Sliding Window','Reduced Pairs Greater than', 'OverallMeanAccuracy', 'OverallMeanPrecision', 'OverallMeanRecall', 'OverallMeanF1Score', 'MaxAccuracy', 'MinAccuracy'});


for i = 1:size(data,1)

    entry = {};

    parts = split(data{i,1}, '_')';
    vitalparts = parts(1,2:end-2);
    
    %Store the model that is being utilized 
    entry{1,end+1} = vitalparts(1,1); 

    %Store the feature selection methodology
    entry{1,end+1}  = vitalparts(1,2);

    %Store the table which was used either PLV or IPD 
    if vitalparts(1,end) == "PLVTable"
        entry{1,end+1}  = "PLV"; 
    else 
        entry{1,end+1}  = "IPD"; 
    end 

    number = [];

    %Detemine which channel pair is being used
    % Search for "ChannelPairs" or "ChannelPair" followed by digits
    pattern = "ChannelPairs(\d+)|ChannelPair(\d+)";
    % Loop through each element in the string array
    for j = 1:length(vitalparts)
        % Check for matches using regular expressions
        tokens = regexp(vitalparts(j), pattern, 'tokens');
        if ~isempty(tokens)
            % Extract the number from the first matched token
            number = str2double(tokens{1}{1});
            break;
        else
            number = 1;
        end 
    end

    entry{1,end+1}  = number; 

    %Check if there is a sliding window used or not 
    hasSlidingWindow = ismember("SlidingWindow", vitalparts);
    if hasSlidingWindow
        entry{1,end+1}  = 1;
    else 
        entry{1,end+1} = 0; 
    end 

    %Check if there was a reduction in the generated pairs 
    pattern = "PairsGreaterthan(\d+)|PairGreaterthan(\d+)";
    % Loop through each element in the string array
    for j = 1:length(vitalparts)
        % Check for matches using regular expressions
        tokens = regexp(vitalparts(j), pattern, 'tokens');
        if ~isempty(tokens)
            % Extract the number from the first matched token
            number = str2double(tokens{1}{1});
            break;
        else
            number = "All pairs";  
        end 
    end
    entry{1,end+1}  = number; 

    %Fill the rest of the values which will just be a general table entries
    %and no preprocessing is required. 
    entry{1,end+1}  = data.OverallMeanAccuracy(i); 
    entry{1,end+1}  = data.OverallMeanPrecision(i); 
    entry{1,end+1} = data.OverallMeanRecall(i);
    entry{1,end+1}  = data.OverallMeanF1Score(i);
    entry{1,end+1}  = data.MaxAccuracy(i);
    entry{1,end+1}  = data.MinAccuracy(i);

resultsTable = [resultsTable;entry];

end 