StartBCI % explain to them what to do

subjectname = 'P1';
hand = 'RH';
Dataset_suffix = 'ERDS';
IC_OR_CH = 'CH'; % use to switch between choosing a set of ICs or CHs

IC_selection = [1, 2];
CH_selection = [1, 2, 3];

switch (IC_OR_CH)
    case 'CH'

        % STEP
        % Extract RH and LH data for selected CHs and save to HDD
        % -----------------------------------------------------------------------
        dir = strcat(BaseDir, 'OwnData', endchar, subjectname, hand, endchar);
        events = ['S 21'; 'S 22']; % these are the same for LH and RH and for all test subjects , except for P13 and P14
        if strcmp(subjectname, 'P13') 
            EFI_Multiple_CH_data_ExtractSave2(subjectname, hand, CH_selection, Dataset_suffix, dir, endchar);
        elseif strcmp(subjectname, 'P14') 
            EFI_Multiple_CH_data_ExtractSave2(subjectname, hand, CH_selection, Dataset_suffix, dir, endchar);
        else
            EFI_Multiple_CH_data_ExtractSave(subjectname, hand, CH_selection, events, Dataset_suffix, dir, endchar);
        end
        
    case 'IC'
        
        % STEP
        % Extract RH and LH data for selected ICs and save to HDD
        % -----------------------------------------------------------------------
        dir = strcat(BaseDir, 'OwnData', endchar, subjectname, hand, endchar);
        events = ['S 21'; 'S 22']; % these are the same for LH and RH and for all test subjects , except for P13 and P14
        if strcmp(subjectname, 'P13') 
            EFI_Multiple_IC_data_ExtractSave2(subjectname, hand, IC_selection, Dataset_suffix, dir, endchar);
        elseif strcmp(subjectname, 'P14') 
            EFI_Multiple_IC_data_ExtractSave2(subjectname, hand, IC_selection, Dataset_suffix, dir, endchar);
        else
            EFI_Multiple_IC_data_ExtractSave(subjectname, hand, IC_selection, events, Dataset_suffix, dir, endchar);
        end
        
    otherwise
        disp('choose IC or CH option')
    
end