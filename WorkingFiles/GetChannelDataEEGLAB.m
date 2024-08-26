function [selectedData] = GetChannelDataEEGLAB(EEG, CH_Selection)

% ========================================================================
% Author:               A K Mohamed
% Original Date:        18/08/2010
% Update Date:          25 Nov 2020
% ------------------------------------------------------------------------
%
% Function to select Channels from an EEGLAB dataset, then transform the
% shape of the EEG Dataset
%
% 
% The 3D epoched EEG dataset is changed to a 2D dataset by
% placing all epochs in series. The data is reshaped into a
% 3D matrix with the order of dimensions changed
%
% Input = EEG Structure from EEGLAB = EEG;
%         CH_Selection - an array of Channel numbers to be selected
% 
% Output = 3D matrix with selected channels with changed dimensions
%
% ========================================================================

[nchannels, ntimepnts, ntrials] = size(EEG.data);
CHnum = length(CH_Selection);

% change shape of data by making it effectively continuous and not epoched
Alldata = reshape(EEG.data, nchannels, ntrials*ntimepnts);

% Get selected channels
channel_data = Alldata(CH_Selection,:);

% reshape data [trials, time, Ch]
selectedData = reshapeEEG(channel_data, CHnum, ntimepnts, ntrials);

return
