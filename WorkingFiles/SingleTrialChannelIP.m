function instantaneousPhase = SingleTrialChannelIP(trial, t1, t2, times)
    % Find the indices corresponding to the times t1 and t2
    index_t1 = find(times == t1); 
    index_t2 = find(times == t2);
    disp(size(times))
    % Extract the signal between the two times and compute the instantaneous phase
    trialSegment = trial(index_t1:index_t2); % Extract the segment of the trial
    analyticSignal = hilbert(trialSegment); % Compute the analytic signal using the Hilbert transform
    instantaneousPhase = unwrap(angle(analyticSignal)); % Compute and unwrap the phase to reduce effect of discontinuties
end
