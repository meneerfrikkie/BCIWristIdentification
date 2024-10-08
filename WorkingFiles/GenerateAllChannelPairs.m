function channel_pairs = GenerateAllChannelPairs(channel)
% Define the channel names
% channels = {'Fp1', 'Fz', 'F3', 'F7', 'FT9', 'FC5', 'FC1', 'C3', 'T7', ...
%             'TP9', 'CP5', 'CP1', 'Pz', 'P3', 'P7', 'O1', 'Oz', 'O2', ...
%             'P4', 'P8', 'TP10', 'CP6', 'CP2', 'C4', 'T8', 'FT10', ...
%             'FC6', 'FC2', 'F4', 'F8', 'Fp2', 'AF7', 'AF3', 'AFz', ...
%             'F1', 'F5', 'FT7', 'FC3', 'FCz', 'C1', 'C5', 'TP7', 'CP3', ...
%             'P1', 'P5', 'PO7', 'PO3', 'POz', 'PO4', 'PO8', 'P6', 'P2', ...
%             'CPz', 'CP4', 'TP8', 'C6', 'C2', 'FC4', 'FT8', 'F6', 'F2', ...
%             'AF4', 'AF8', 'F9', 'AFF1h', 'FFC1h', 'FFC5h', 'FTT7h', ...
%             'FCC3h', 'CCP1h', 'CCP5h', 'TPP7h', 'P9', 'PPO9h', 'PO9', ...
%             'O9', 'OI1h', 'PPO1h', 'CPP3h', 'CPP4h', 'PPO2h', 'OI2h', ...
%             'O10', 'PO10', 'PPO10h', 'P10', 'TPP8h', 'CCP6h', 'CCP2h', ...
%             'FCC4h', 'FTT8h', 'FFC6h', 'FFC2h', 'AFF2h', 'F10', 'AFp1', ...
%             'AFF5h', 'FFT9h', 'FFT7h', 'FFC3h', 'FCC1h', 'FCC5h', 'FTT9h', ...
%             'TTP7h', 'CCP3h', 'CPP1h', 'CPP5h', 'TPP9h', 'PPO5h', 'POO1', ...
%             'POO9h', 'POO10h', 'POO2', 'PPO6h', 'TPP10h', 'CPP6h', ...
%             'CPP2h', 'CCP4h', 'TTP8h', 'FTT10h', 'FCC6h', 'FCC2h', ...
%             'FFC4h', 'FFT8h', 'FFT10h', 'AFF6h', 'AFp2'};
% 
% channels = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
%  channels = {'C3','C4','F3','Fz','F4','P3','Pz','P4','T7','T8','C1', 'C2','FCC1h','FCC2h','CCP1h','CCP2h'};
        switch channel
            case 1
                disp("Channel Subset 1"); 
                %file:///C:/Users/imia1/Downloads/hamner_embc2011.pdf
                channels = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
            case 2
                %file:///C:/Users/imia1/Downloads/s12938-018-0534-0%20(2).pdf
                disp("Channel Subset 2"); 
                channels = {'C3','C4','F3','Fz','F4','P3','Pz','P4','T7','T8','C1', 'C2','FCC1h','FCC2h','CCP1h','CCP2h'}; 
            case 3
                disp("Channel Subset 3")
                % Combined channel pairs 1 and 2 to check combination
                % First cell array
                channels1 = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
                
                % Second cell array
                channels2 = {'C3', 'C4', 'F3', 'Fz', 'F4', 'P3', 'Pz', 'P4', 'T7', 'T8', 'C1', 'C2', 'FCC1h', 'FCC2h', 'CCP1h', 'CCP2h'};
                
                % Combine without duplicates using union
                channels = union(channels1, channels2);
                
                disp(channels); 
            otherwise
                error('Channel Pair not recognized.');
        end
% 
% Initialize an empty cell array to store the pairs
channel_pairs = {};

% Generate all possible pairs and store them as strings
for i = 1:length(channels)
    for j = i+1:length(channels)
            % Create a string in the format 'channel{i}-channel{j}'
            pair = sprintf('%s-%s', channels{i}, channels{j});
            channel_pairs{end+1} = pair;
    end
end

% Display the result
disp(channel_pairs);
end 