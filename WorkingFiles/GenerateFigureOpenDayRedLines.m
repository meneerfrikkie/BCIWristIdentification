




numTrials = 1; 
PatientID = 'P1';

channelpairs = GenerateAllChannelPairs(3); 
channels = CheckChannelPairs(channelpairs); 

temp = sprintf("../OwnData/%sRH/MatlabGeneratedData/%sRH_Data_MultipleCH_ERDS.mat",PatientID,PatientID); 
data = load(temp); 
data_WF = data.data_WE; 
data_WE = data.data_WF; 
time = data.times; 

data_label = 'WE'; 

% Define the folder where the plots will be saved
saveFolder = sprintf('../OwnResults/RedLinedFigureEEGData/%s',PatientID); % Change this to your desired folder path

% Make sure the folder exists, create it if it doesn't
if ~exist(saveFolder, 'dir')
   mkdir(saveFolder);
end

% Define the folder where the plots will be saved
saveFolderWE = sprintf('../OwnResults/RedLinedFigureEEGData/%s/WE',PatientID); % Change this to your desired folder path

% Make sure the folder exists, create it if it doesn't
if ~exist(saveFolderWE, 'dir')
   mkdir(saveFolderWE);
end

for i = 1:length(numTrials)
    for j = 1:length(channels)
        figure; 
        plot(time,data_WE(i,:,j))
        xlabel('Time (ms)');
        ylabel('Amplitude (μV)');
        xlim([-3000,9000]);

        xline(0, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(2000, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(5000, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(8000, 'r', 'LineWidth', 1.5);  % Add a red vertical line

        title(sprintf('%s - Channel %s, Trial %d', data_label, channels{j}, i));
        grid on;

        % Save the figure
        % Construct a file name for each plot
        fileName = sprintf('Trial%d_Channel%d.png', i, j);
        fullFileName = fullfile(saveFolderWE, fileName); % Full file path
        
        % Save the figure as a PNG file
        saveas(gcf, fullFileName);
    end 
end 

data_label = 'WF';

% Define the folder where the plots will be saved
saveFolderWF = sprintf('../OwnResults/RedLinedFigureEEGData/%s/WF',PatientID); % Change this to your desired folder path

% Make sure the folder exists, create it if it doesn't
if ~exist(saveFolderWF, 'dir')
   mkdir(saveFolderWF);
end

for i = 1:length(numTrials)
    for j = 1:length(channels)
        figure; 
        plot(time,data_WF(i,:,j))
        xlabel('Time (ms)');
        ylabel('Amplitude (μV)');
        xlim([-3000,9000]);


        xline(0, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(2000, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(5000, 'r', 'LineWidth', 1.5);  % Add a red vertical line
        xline(8000, 'r', 'LineWidth', 1.5);  % Add a red vertical line

        title(sprintf('%s - Channel %s, Trial %d', data_label, channels{j}, i));
        grid on; 

         % Save the figure
        % Construct a file name for each plot
        fileName = sprintf('Trial%d_Channel%d.png', i, j);
        fullFileName = fullfile(saveFolderWF, fileName); % Full file path
        
        % Save the figure as a PNG file
        saveas(gcf, fullFileName);
    end 
end 