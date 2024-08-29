function instantaneousPhase = SingleTrialChannelIP(trial, t1, t2, times)
    % Function to compute the instantaneous phase of a single trial channel
    % within a specified time range using the Hilbert transform.

    % Find the index corresponding to the start time t1
    index_t1 = find(times == t1);
    
    % Find the index corresponding to the end time t2
    index_t2 = find(times == t2);
    
    % Debugging aid: display the size of the times array
    % disp(size(times))
    
    % Extract the segment of the trial corresponding to the time range [t1, t2]
    trialSegment = trial(index_t1:index_t2); 
    
    % Compute the analytic signal of the trial segment using the Hilbert transform
    analyticSignal = hilbert(trialSegment); 
    
    % Compute the instantaneous phase of the analytic signal
    % Unwrap the phase to avoid discontinuities caused by phase jumps
    instantaneousPhase = unwrap(angle(analyticSignal)); 
end
