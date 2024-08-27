function process_eeg_data(subjectnames, CH_selection_string)
    % process_eeg_data - Process EEG data based on subject names and channel selections.
    %
    % Syntax: process_eeg_data(subjectnames, CH_selection)
    %
    % Inputs:
    %   subjectnames  - Cell array of subject names (e.g., {'P5', 'P1'})
    %   CH_selection  - Array of selected channels (e.g., {'C3','C4','fp1'})
    %
    % Example:
    %   process_eeg_data({'P5', 'P1'}, [1, 2, 3])

    StartBCI

    % Default values from AK
    IC_selection = [1, 2];             
    IC_OR_CH = 'CH';                   
    hand = 'RH';                       
    Dataset_suffix = 'ERDS';  

    %Convert passed in channels names to the channel key 
    CH_selection = getChannelKeys(CH_selection_string);

    for i =1:length(CH_selection)
        fprintf('Selected channel: %s -> %d\n', CH_selection_string{i}, CH_selection(i))
    end

    % Loop through each subject name
    for i = 1:length(subjectnames)
        subjectname = subjectnames{i};  % Use curly braces to access cell array contents
        
        % Determine the directory for the current subject
        dir = strcat(BaseDir, 'OwnData', endchar, subjectname, hand, endchar);
        
        % Define events (adjust if these are different for certain subjects)
        events = ['S 21'; 'S 22'];  % These are the same for LH and RH and for all test subjects, except for P13 and P14
        
        % Switch between processing channels or independent components
        switch IC_OR_CH
            case 'CH'
                % Process channels (CH)
                if strcmp(subjectname, 'P13') || strcmp(subjectname, 'P14')
                    EFI_Multiple_CH_data_ExtractSave2(subjectname, hand, CH_selection, Dataset_suffix, dir, endchar);
                else
                    EFI_Multiple_CH_data_ExtractSave(subjectname, hand, CH_selection, events, Dataset_suffix, dir, endchar);
                end
                
            case 'IC'
                % Process independent components (IC)
                if strcmp(subjectname, 'P13') || strcmp(subjectname, 'P14')
                    EFI_Multiple_IC_data_ExtractSave2(subjectname, hand, IC_selection, Dataset_suffix, dir, endchar);
                else
                    EFI_Multiple_IC_data_ExtractSave(subjectname, hand, IC_selection, events, Dataset_suffix, dir, endchar);
                end
                
            otherwise
                error('Invalid option for IC_OR_CH. Please choose "IC" or "CH".')
        end
    end
end
