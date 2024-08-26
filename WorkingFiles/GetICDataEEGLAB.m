function [selectedData] = GetICDataEEGLAB(EEG, IC_Selection)

% ========================================================================
% Author:               A K Mohamed
% Original Date:        18/08/2010
% Update Date:          28 Nov 2020
% ------------------------------------------------------------------------
%
% Function to select ICs from an EEGLAB dataset, then transform the
% shape of the EEG Dataset
%
% 
% The 3D epoched EEG dataset is changed to a 2D dataset by
% placing all epochs in series. The data is reshaped into a
% 3D matrix with the order of dimensions changed
%
% Input = EEG Structure from EEGLAB = EEG
%         an array of IC numbers to be selected - IC_Selection
% 
% Output = 3D matrix with of selected ICs with changed dimensions
%
% ========================================================================

[nchannels, ntimepnts, ntrials] = size(EEG.data);
ICnum = length(IC_Selection);

% change shape of data by making it effectively continuous and not epoched
Alldata = reshape(EEG.data, nchannels, ntrials*ntimepnts);
ICdata = EEG.icaweights * EEG.icasphere * Alldata;

% Get selected channels
SelectIC_data = ICdata(IC_Selection,:);

% reshape data [trials, time, Ch]
selectedData = reshapeEEG(SelectIC_data, ICnum, ntimepnts, ntrials);

return
