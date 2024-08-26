function reshapedData = reshapeEEG (inputData, num_IC_or_CH, ntimepnts, ntrials) 

% ========================================================================
% Author:           A K Mohamed
% Oringnal Date:    24/07/2010
% Update Date:      25 Nov 2020
% ------------------------------------------------------------------------
%
% Function to reshape the EEG matrix
% 1) firstly it takes the row of epochs in series and puts them in parallel
% 2) it then changes the order of the dimensions to IC/channelno, time,
%    trials
% 
% Input =   2D data [IC or channel by contiuous epochs] - 'inputData'
%           number of ICs or channels  - 'num_IC_or_CH'
%           number of frames/ time samples - 'ntimepnts'
%           number of trials - ntrials
%
% Output = 3D matrix of reshaped EEG data [trials, time, ICs]
%
% ========================================================================

for i = 1:num_IC_or_CH
    
    disp([ 'channel or IC number: ' num2str(i)])
    timetrial = inputData(i, :);
    epochedData = reshape(timetrial, ntimepnts, ntrials);
    reshapedData(:,:,i) = epochedData';
    
end

return