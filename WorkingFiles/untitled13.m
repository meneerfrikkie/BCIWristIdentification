% Define the data for each column
% Feature1 = [10; 5; 20; 8; 12];
% Feature2 = [20; 15; 30; 18; 22];
% Feature3 = [30; 25; 40; 28; 32];
% Label = [0; 1; 0; 1; 0];
% 
% Create the table with the data
% dataTable = table(Feature1, Feature2, Feature3);
% 
% 
%  Compute mean and standard deviation from training data
%                 meanTrain = mean(table2array(dataTable),1);
%                 stdTrain = std(table2array(dataTable),1);
% 
%                 Standardize the training data
%                 standardizedPredictors = (table2array(dataTable) - meanTrain) ./ stdTrain;
%               
%                 
%                 Standardize the test data using training data statistics
%                 standardizedTestData = (table2array(XtestFold) - meanTrain) ./ stdTrain;

% CH_pairs = {'Fz-C2', 'C4-C2','Fp1-C2'};
% 
% CH_selection = CheckChannelPairs(CH_pairs);
% 
% disp(CH_selection)
% 
% for i = 1:length(CH_pairs)
%       % Get the channel pair and corresponding indices
%         channels = CheckChannelPairs(CH_pairs(i));
%         ch1 = channels(1);
%         ch2 = channels(2);
% 
%         disp(ch1)
%         disp(ch2)
% 
%         % Find column indices in the data matrix
%         col1 = find(strcmp(CH_selection, ch1));
%         col2 = find(strcmp(CH_selection, ch2));
% 
%         disp(col1)
%         disp(col2)
% 
%         if isempty(col1) || isempty(col2)
%             error('Channel names %s or %s not found in CH_selection.', ch1, ch2);
%         end
% 
%   end 
