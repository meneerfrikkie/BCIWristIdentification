% Data
channel_pairs = [1, 2, 3, 7, 11, 20, 36, 54, 90, 156, 229, 292];
accuracy = [60.906, 63.699, 65.112, 69.605, 72.58, 75.936, 77.376, 77.975, 78.67, 79.868, 80.07, 79.801];
loss = [18.61, 15.817, 14.404, 9.911, 6.936, 3.58, 2.14, 1.541, 0.846, -0.352, -0.554, -0.285];

% Create the figure
figure;

% Plot Accuracy
yyaxis left;
plot(channel_pairs, accuracy, '-o', 'LineWidth', 2);
ylabel('Accuracy (%)');
xlabel('Number of Channel Pairs');
ylim([60, 85]);
grid on;

% % Add data points for Accuracy
% for i = 1:length(channel_pairs)
%     text(channel_pairs(i), accuracy(i), sprintf('%.1f', accuracy(i)), ...
%         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
%         'FontSize', 12, 'FontName', 'Times New Roman');
% end

% Customize the plot appearance
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

% Plot Loss on the secondary y-axis
yyaxis right;
plot(channel_pairs, loss, '-s', 'LineWidth', 2, 'Color', 'b');
ylabel('Loss (%) [Baseline - Accuracy]');

% % Add data points for Loss
% for i = 1:length(channel_pairs)
%     text(channel_pairs(i), loss(i), sprintf('%.1f', loss(i)), ...
%         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
%         'FontSize', 12, 'FontName', 'Times New Roman', 'Color', 'b');
% end

% Title and legend
title('Accuracy and Loss vs Number of Channel Pairs', 'FontName', 'Times New Roman', 'FontSize', 16);
legend('Accuracy', 'Loss', 'Location', 'best');

% Set font for all axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

%%
% Data
timestamps_used = [1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 21, 22, 25, 28, 30, 32, 36, 39, 42, 44, 45, 46];
mean_accuracy = [65.8868, 67.6963, 69.3102, 71.5044, 73.1945, 73.9799, 74.6667, 74.7047, 75.3452, 77.5353, 77.2038, 77.3072, 78.0213, 78.2655, 78.5311, 78.7375, 79.0763, 78.4816, 78.2989, 78.3831, 78.8313, 79.0728, 80.0583, 79.6873, 79.5802, 79.5161];

% Define the baseline as the first entry in the mean_accuracy vector
baseline = 79.516;

% Calculate the loss vector (baseline - mean_accuracy)
loss = baseline - mean_accuracy;

% Create the figure
figure;

% Plot Overall Mean Accuracy
yyaxis left;
plot(timestamps_used, mean_accuracy, '-o', 'LineWidth', 2);
ylabel('Accuracy (%)');
xlabel('Number of Timestamps Used');
grid on;

% % Add data points for Mean Accuracy
% for i = 1:length(timestamps_used)
%     text(timestamps_used(i), mean_accuracy(i), sprintf('%.1f', mean_accuracy(i)), ...
%         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
%         'FontSize', 12, 'FontName', 'Times New Roman');
% end

% Customize the plot appearance
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);

% Plot Loss on the secondary y-axis
yyaxis right;
plot(timestamps_used, loss, '-s', 'LineWidth', 2, 'Color', 'b');
ylabel('Loss (%) [Baseline - Accuracy]');

% % Add data points for Loss
% for i = 1:length(timestamps_used)
%     text(timestamps_used(i), loss(i), sprintf('%.2f', loss(i)), ...
%         'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
%         'FontSize', 12, 'FontName', 'Times New Roman', 'Color', 'b');
% end

% Title and legend
title('Accuracy and Loss vs Number of Timestamps Used', 'FontName', 'Times New Roman', 'FontSize', 16);
legend('Accuracy', 'Loss', 'Location', 'best');

% Set font for all axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 16);