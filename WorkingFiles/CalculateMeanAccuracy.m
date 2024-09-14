% Calculate Mean Accuracy per Experiment

function [overallMeanAccuracy, maxAccuracy, minAccuracy] = CalculateMeanAccuracy(filePath)
    % Load the .mat file containing the data
    dataTable = load(filePath).dataTable;

    sizeTable = size(dataTable,1);
    i = 1; 
    %Loop and remove repeat patientIDs 
    while i < sizeTable 
        disp(i)
        if (strcmp(dataTable{i,1}, dataTable{i+1,1}))
           dataTable(i+1,:) = []; 
           sizeTable = sizeTable -1; 
           if i == 1
               i = 1; 
           else
                i = i-1;
           end 
           disp('deleted')
        else 
            i = i+1;
        end 
    end 


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