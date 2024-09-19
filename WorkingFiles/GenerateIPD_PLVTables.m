function GenerateIPD_PLVTables(PatientIDs,channel)




% PatientIDs = {'P1','P2','P3','P4','P5','P6','P7','P8','P9','P10','P11','P12','P13','P14'};
% channel = 3; 
% Define the channel pairs to be analyzed
% CH_pairs = {'FCz-FC3','FCz-C3','FCz-CP3','CPz-FC3','CPz-C3','CPz-CP3','FCC1h-C3','FCC2h-C3','CCP1h-C3','CCP2h-C3'};
CH_pairs = GenerateAllChannelPairs(channel);


%CH_pairs = GeneratePairs(0)

% Select the channel pairs that are available in the dataset
CH_selection = CheckChannelPairs(CH_pairs);

% Process EEG data for a specific participant
ProcessEEGData(PatientIDs, CH_selection);

for i = 1:length(PatientIDs)

    PatientID = PatientIDs{i};

    if ispc
        % For Windows
        % Construct the file path using sprintf
        data = load(sprintf('..\\OwnData\\%sRH\\MatlabGeneratedData\\%sRH_Data_MultipleCH_ERDS.mat', PatientID, PatientID));
        
    elseif ismac || isunix
        % For MacOs
        % Construct the file path using sprintf
        data = load(sprintf('../OwnData/%sRH/MatlabGeneratedData/%sRH_Data_MultipleCH_ERDS.mat', PatientID, PatientID));
        
    else
        % For other operating systems (e.g., Linux)
        disp('ERROR: Unsupported operating system. This script is designed for Windows or macOS only.');
    end

    % Multi-Trial Analysis for Wrist Extension (WE)
    class_WE = 1;
    data_WE = data.data_WE; 
    
    % Multi-Trial Analysis for Wrist Flexion (WF)
    class_WF = 0;
    data_WF = data.data_WF; 

    %No sliding window
    
%     %Generate IPD features for Writst Extension
%     IPDTable_WE = MultiTrialIDP(data_WE, CH_pairs, CH_selection, 5000, 8000, data.times, class_WE, PatientID);
% 
%     %Generate IPD Features for Wrist Flexion
%     IPDTable_WF = MultiTrialIDP(data_WF, CH_pairs, CH_selection, 5000, 8000, data.times, class_WF, PatientID);
%     
%     %Generate PLV features for Wrist Extension (WE)
%     PLVTable_WE = MultiTrialPLV(data_WE, CH_pairs, CH_selection, 5000, 8000, data.times, class_WE, PatientID);
%     
%     %Generate PLV features for Wrist Flexion (WF)
%     PLVTable_WF = MultiTrialPLV(data_WF, CH_pairs, CH_selection, 5000, 8000, data.times, class_WF, PatientID);

t1 = 0; 
t2 = 1700; 

    % Multi-Trial Analysis for Wrist Extension (WE)
% 
%     % Sliding Window 
    for t = t1:100:t2
        disp(t)
        disp(t==t1)
        if t == t1
     %   Generate IPD features for Writst Extension
       IPDTable_WE = MultiTrialIDP(data_WE, CH_pairs, CH_selection, t, t+300, data.times, class_WE, PatientID);
    
     %   Generate IPD Features for Wrist Flexion
       IPDTable_WF = MultiTrialIDP(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);
        
%       %  Generate PLV features for Wrist Extension (WE)
% %
        PLVTable_WE = MultiTrialPLV(data_WE, CH_pairs, CH_selection,  t, t+300, data.times, class_WE, PatientID);
%         
%       %  Generate PLV features for Wrist Flexion (WF)
        PLVTable_WF = MultiTrialPLV(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);
        else
      %  Generate IPD features for Writst Extension
       tempIPDTable_WE = MultiTrialIDP(data_WE, CH_pairs, CH_selection, t, t+300, data.times, class_WE, PatientID);
    
      %  Generate IPD Features for Wrist Flexion
       tempIPDTable_WF = MultiTrialIDP(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);
        
% %       % Generate PLV features for Wrist Extension (WE)
         tempPLVTable_WE = MultiTrialPLV(data_WE, CH_pairs, CH_selection,  t, t+300, data.times, class_WE, PatientID);
%         
%        % Generate PLV features for Wrist Flexion (WF)
         tempPLVTable_WF = MultiTrialPLV(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);

        IPDTable_WE = [IPDTable_WE(:,1:end-1),tempIPDTable_WE]; 
        IPDTable_WF = [IPDTable_WF(:,1:end-1),tempIPDTable_WF];
% 
        PLVTable_WE = [PLVTable_WE(:,1:end-1),tempPLVTable_WE]; 
        PLVTable_WF = [PLVTable_WF(:,1:end-1),tempPLVTable_WF];
        end 
    end 
    
%  t3 = 5000; 
%  t4 = 7700; 
% 
%  %     % Sliding Window 
%     for t = t3:100:t4
%         disp(t)
% 
%       %  Generate IPD features for Writst Extension
%        tempIPDTable_WE = MultiTrialIDP(data_WE, CH_pairs, CH_selection, t, t+300, data.times, class_WE, PatientID);
%     
%       %  Generate IPD Features for Wrist Flexion
%        tempIPDTable_WF = MultiTrialIDP(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);
%         
% % %       % Generate PLV features for Wrist Extension (WE)
%          tempPLVTable_WE = MultiTrialPLV(data_WE, CH_pairs, CH_selection,  t, t+300, data.times, class_WE, PatientID);
% %         
% %        % Generate PLV features for Wrist Flexion (WF)
%          tempPLVTable_WF = MultiTrialPLV(data_WF, CH_pairs, CH_selection,  t, t+300, data.times, class_WF, PatientID);
% 
%         IPDTable_WE = [IPDTable_WE(:,1:end-1),tempIPDTable_WE]; 
%         IPDTable_WF = [IPDTable_WF(:,1:end-1),tempIPDTable_WF];
% % 
%         PLVTable_WE = [PLVTable_WE(:,1:end-1),tempPLVTable_WE]; 
%         PLVTable_WF = [PLVTable_WF(:,1:end-1),tempPLVTable_WF];
%     end 


    
    % Combine IDP tables for WE and WF
     IPDTable = [IPDTable_WE;IPDTable_WF];

%   %Combine PLV tables for WE and WF
     PLVTable = [PLVTable_WE;PLVTable_WF];
%     
%     % Combine IDP and PLV for a combine tabe
%     IPD_PLVTable = [IPDTable(:,1:end-1), PLVTable];

    folderPath = fullfile('..','OwnResults', [PatientID 'RH'], 'MatlabGeneratedData');
    
    % Check if the folder exists; if not, create it
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
    
    % Define filenames for the .mat files
    IPDFile = fullfile(folderPath, ['IPDTable' num2str(channel) '.mat']);
    PLVFile = fullfile(folderPath, ['PLVTable' num2str(channel) '.mat']);
    IPD_PLVFile = fullfile(folderPath, ['IPD_PLVTable' num2str(channel) '.mat']);
    
    % Save the tables into .mat files
    save(IPDFile,'IPDTable');
     save(PLVFile,'PLVTable');
%     save(IPD_PLVFile,'IPD_PLVTable');

    % Define filenames for the CSV files
   IPDFile = fullfile(folderPath, sprintf('IDPTable%d.csv',channel));
    PLVFile = fullfile(folderPath, sprintf('PLVTable%d.csv',channel));
%     IPD_PLVFile = fullfile(folderPath, 'IDP_PLVTable.csv');
    
    % Save the tables into CSV files
   writetable(IPDTable, IPDFile);
    writetable(PLVTable, PLVFile);
%     writetable(IPD_PLVTable, IPD_PLVFile);

end
end
