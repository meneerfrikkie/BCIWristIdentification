function PlotData()
    % Function to load and plot data from a .mat file.
    % The user is prompted to select a .mat file containing wrist extension (WE)
    % and wrist flexion (WF) data, choose the dataset, channel, trial, and time range
    % they want to plot.

    % Prompt the user to load a .mat file containing the data
    [file, path] = uigetfile('*.mat', 'Select the MATLAB data file');
    if isequal(file, 0)
        disp('User canceled the operation');
        return;
    end
    
    % Load the selected .mat file
    data = load(fullfile(path, file));
    
    % Display the data options available for analysis
    disp('The file contains the following data:');
    disp('1. WE (Wrist Extension)');
    disp('2. WF (Wrist Flexion)');
    
    % Ask the user to select which dataset to analyze: WE or WF
    data_choice = input('Select the data to analyse (1 for WE, 2 for WF): ');
    
    % Based on user input, select the appropriate dataset
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
    
    % Ask the user to select the channel number to analyze
    num_channels = size(selected_data, 3);
    fprintf('The dataset contains %d channels.\n', num_channels);
    channel = input(sprintf('Enter the channel number (1-%d): ', num_channels));
    
    % Validate the channel number
    if channel < 1 || channel > num_channels
        disp('Invalid channel number');
        return;
    end
    
    % Ask the user to select the trial number to analyze
    num_trials = size(selected_data, 1);
    fprintf('The dataset contains %d trials.\n', num_trials);
    trial = input(sprintf('Enter the trial number (1-%d): ', num_trials));
    
    % Validate the trial number
    if trial < 1 || trial > num_trials
        disp('Invalid trial number');
        return;
    end
    
    % Ask the user to select the time range for plotting
    time_array = data.times;
    fprintf('The time array ranges from %.2f to %.2f ms.\n', time_array(1), time_array(end));
    choice = input('Would you like to select the entire time range? (y/n): ', 's');
    
    % Determine the start and end indices based on the user's time range selection
    if strcmpi(choice, 'y')
        % Use the entire time range
        start_idx = 1;
        end_idx = length(time_array);
    else
        % Ask the user to specify the start and end times
        start_time = input('Enter the start time (ms): ');
        end_time = input('Enter the end time (ms): ');
        
        % Convert the specified times to indices in the time array
        [~, start_idx] = min(abs(time_array - start_time));
        [~, end_idx] = min(abs(time_array - end_time));
    end
    
    % Extract the data for the selected trial, time range, and channel
    plot_data = selected_data(trial, start_idx:end_idx, channel);
    plot_time = time_array(start_idx:end_idx);
    
    % Plot the selected data
    figure;
    plot(plot_time, plot_data);
    xlabel('Time (ms)');
    ylabel('Amplitude');
    title(sprintf('%s - Channel %d, Trial %d', data_label, channel, trial));
    grid on;
end