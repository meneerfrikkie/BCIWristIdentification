
%% obtaining corresponding eeglab key for a channel

channel_names = {'Fp1', 'Fz', 'F3', 'O2','c3'};

% Get the keys for these channels
keys = getChannelKeys(channel_names);

% Display the keys
disp(keys);

%% Generating the matlab files for the required patients and channels

%testing process_eeg_data 
subjectnames = {'P1','P5'}; 
CH_selection = {'C3','c3','Fp1','fp1','c4','C4'};

process_eeg_data(subjectnames,CH_selection); 
disp(getChannelKeys(CH_selection))

%% Checking that the IP function works for a single trial and single channel 

data = load('OwnData\P1RH\MatlabGeneratedData\P1RH_Data_MultipleCH_ERDS.mat'); 

data_WF = data.data_WF; 

t1 = 5000; 
t2 = 8000;

IP = singleTrialChannelIP(data_WF(1,:,1),t1,t2,data.times);
disp(max(IP));
disp(min(IP));


plot(data.times(data.times >= t1 & data.times <= t2), IP, '-r')
title('Computed Instantaneous Phase');
xlabel('Time (s)');
ylabel('Phase (radians)');

%% testing to ensure that the IP function works correctly 

Fs = 128; % Sampling frequency (in Hz)
t = 0:1/Fs:2; % Time vector from 0 to 2 seconds
frequency = 10; % Frequency of the sine wave (5 Hz)
testSignal = sin(2 * pi * frequency * t); % Generate a 5 Hz sine wave

% Step 2: Define Time Points for Analysis
t1 = 0; % Start time in seconds
t2 = 2; % End time in seconds

% Ensure the times vector is the same as the time vector for indexing
times = t;

% Step 3: Call the Function
computedPhase = singleTrialIP(testSignal, t1, t2, times);
disp(max(computedPhase));
disp(min(computedPhase));


plot(t(times >= t1 & times <= t2), computedPhase, '-r')
title('Computed Instantaneous Phase');
xlabel('Time (s)');
ylabel('Phase (radians)');
