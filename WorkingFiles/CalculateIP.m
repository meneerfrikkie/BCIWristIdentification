data = load("OwnData\P1RH\MatlabGeneratedData\P1RH_Data_MultipleCH_ERDS.mat");

data_WF = data.data_WF; 
data_WE = data.data_WE; 

%lets assume that there will be one trial and one channel being passed to
%this function

%Single trial with a single channel cause you calculate the IP for it 
trial = data_WF(1,:,1);

channelName = 'Temporary';

t1 = 5000; 
t2 = 8000; 

index_t1 = find(data.times == t1);
index_t2 = find(data.times == t2); 

fprintf('IDP calculated between %d to %d for channel %s\n', t1, t2, channelName);


