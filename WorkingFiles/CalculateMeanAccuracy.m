% Calculate Mean Accuracy per Experiment

function [overallMeanAccuracy, maxAccuracy, minAccuracy] = CalculateMeanAccuracy(filePath)
    % Load the .mat file containing the data
    dataTable = load(filePath).dataTable;

    % Extract the "Mean Accuracy" column
    accuracyValues = dataTable{:,"Mean Accuracy"};

    % Initialize a variable to hold the sum of mean accuracies
    totalMeanAccuracy = sum(accuracyValues);

    % Calculate the overall mean accuracy
    overallMeanAccuracy = (totalMeanAccuracy / length(accuracyValues)) * 100;

    % Calculate the maximum and minimum accuracies
    maxAccuracy = max(accuracyValues) * 100;
    minAccuracy = min(accuracyValues) * 100;
end