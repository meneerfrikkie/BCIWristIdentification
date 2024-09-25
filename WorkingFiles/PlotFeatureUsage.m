function PlotFeatureUsage(matFile, minCount)
    % Load data from the .mat file
    data = load(matFile).rankedFeaturesTable;
    
    % Assuming the .mat file contains two variables: 'FeatureName' and 'Count'
    FeatureName = data.FeatureName;  % Cell array with time slots as strings, e.g. '1100-1400'
    Count = data.Count;  % Array with counts corresponding to the time slots
    
    % Initialize arrays for start_time and end_time
    start_time = zeros(length(FeatureName), 1);
    end_time = zeros(length(FeatureName), 1);
    
    % Extract start and end times from FeatureName strings
    for i = 1:length(FeatureName)
        timeRange = split(FeatureName{i}, '-');
        start_time(i) = str2double(timeRange{1});
        end_time(i) = str2double(timeRange{2});
    end
    
    % Sort by start_time
    [start_time, sorted_indices] = sort(start_time);
    end_time = end_time(sorted_indices);
    Count = Count(sorted_indices);
    
    % Filter based on the minimum count
    valid_indices = Count > minCount;
    start_time = start_time(valid_indices);
    end_time = end_time(valid_indices);
    Count = Count(valid_indices);
    
    % Shift all times so the minimum time is 1 (instead of 0)
    min_start_time = min(start_time);
    time_shift = 1 - min_start_time;  % Shift amount to make the minimum start time 1
    start_time = start_time + time_shift;
    end_time = end_time + time_shift;
    
    % Determine the full time range after shifting
    max_time = max(end_time);
    time_range = 1:max_time;  % Time from 1 to the maximum end time
    
    % Initialize a counts array for all time points
    total_counts = zeros(1, length(time_range));
    
    % Accumulate counts over time intervals without overlapping
    for i = 1:length(start_time)
        % Add the counts only within the specific time range, without overlap
        total_counts(start_time(i):end_time(i)-1) = total_counts(start_time(i):end_time(i)-1) + Count(i);
    end
    
    % Now, adjust the x-axis back to the original time scale
    original_time_range = time_range - time_shift; % Revert the shift for correct plotting
    
    % Plot the results
    figure;
    plot(original_time_range, total_counts, 'b', 'LineWidth', 2);
    hold on;
    
    % Create a closed polygon for the fill
    x_fill = [original_time_range, fliplr(original_time_range)]; % x-coordinates (line and back to start)
    y_fill = [total_counts, zeros(size(total_counts))]; % y-coordinates (total_counts and 0 for the x-axis)
    
    % Fill the area under the curve
    fill(x_fill, y_fill, 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % No edge color
    
    xlabel('Time (ms)');
    ylabel('Count');
    title(['Feature Usage Over Time (Filtered by Count > ' num2str(minCount) ')']);
    grid on;
    
    % Adjust figure for better appearance
    xlim([min(original_time_range) max(original_time_range)]);
    ylim([0 max(total_counts) + 10]);
    hold off;

end
