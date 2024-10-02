% Calculate Mean Accuracy per Experiment

function [overallMeanAccuracy,overallStd,overallMeanPrecision,overallMeanRecall,overallMeanF1Score, maxAccuracy, minAccuracy] = CalculateMeanAccuracy(filePath)
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
    precisionValues = dataTable{:,"Mean Precision"};
    recallValues = dataTable{:,"Mean Recall"}; 
    f1ScoreValues = dataTable{:,"Mean F1-Score"}; 


    % Initialize a variable to hold the sum of mean accuracies
    totalMeanAccuracy = sum(accuracyValues);

    % Calculate the overall mean accuracy
    overallMeanAccuracy = (totalMeanAccuracy / length(accuracyValues)) * 100;
    overallStd = std(accuracyValues); 

    % Calculate the maximum and minimum accuracies
    maxAccuracy = max(accuracyValues) * 100;
    minAccuracy = min(accuracyValues) * 100;

    %Mean Preciison, Recall and F1-Score
    overallMeanPrecision = (sum(precisionValues)/length(precisionValues))*100; 
    overallMeanRecall = (sum(recallValues)/length(recallValues))*100; 
    overallMeanF1Score = (sum(f1ScoreValues)/length(f1ScoreValues))*100; 
end