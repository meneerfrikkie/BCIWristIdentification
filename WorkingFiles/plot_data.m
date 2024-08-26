function plot_data()
    % Prompt the user to load the .mat file
    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
    
    % Load the selected .mat file
    data = load(fullfile(path, file));
    
    % Display the available options (WE, WF, times)
    disp('The file contains the following data:');
    disp('1. WE (Wrist Extension)');
    disp('2. WF (Wrist Flexion)');
    
    % Ask the user to select the type of data they want to analyze
    data_choice = input('Select the data to analyze (1 for WE, 2 for WF): ');
    
    % Select the appropriate dataset based on user input
    switch data_choice
        case 1
            selected_data = data.data_WE;
            data_label = 'WE (Wrist Extension)';
        case 2
            selected_data = data.data_WF;
            data_label = 'WF (Wrist Flexion)';
        otherwise
            disp('Invalid choice');
            return;
    end
    
    % Ask the user to select the channel number
    num_channels = size(selected_data, 3);
    fprintf('The dataset contains %d channels.\n', num_channels);
    channel = input(sprintf('Enter the channel number (1-%d): ', num_channels));
    if channel < 1 || channel > num_channels
        disp('Invalid channel number');
        return;
    end
    
    % Ask the user to select the trial number
    num_trials = size(selected_data, 1);
    fprintf('The dataset contains %d trials.\n', num_trials);
    trial = input(sprintf('Enter the trial number (1-%d): ', num_trials));
    if trial < 1 || trial > num_trials
        disp('Invalid trial number');
        return;
    end
    
    % Ask the user to select the time range
    time_array = data.times;
    fprintf('The time array ranges from %.2f to %.2f ms.\n', time_array(1), time_array(end));
    choice = input('Would you like to select the entire time range? (y/n): ', 's');
    
    if strcmpi(choice, 'y')
        start_idx = 1;
        end_idx = length(time_array);
    else
        start_time = input('Enter the start time (ms): ');
        end_time = input('Enter the end time (ms): ');
        
        % Convert times to indices
        [~, start_idx] = min(abs(time_array - start_time));
        [~, end_idx] = min(abs(time_array - end_time));
    end
    
    % Extract the data for the selected trial, time range, and channel
    plot_data = selected_data(trial, start_idx:end_idx, channel);
    plot_time = time_array(start_idx:end_idx);
    
    % Plot the data
    figure;
    plot(plot_time, plot_data);
    xlabel('Time (ms)');
    ylabel('Amplitude');
    title(sprintf('%s - Channel %d, Trial %d', data_label, channel, trial));
    grid on;
end