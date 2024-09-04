function [precision, recall, f1Score, accuracy] = ConfusionMetrics(actual, predicted)
    % Compute confusion matrix
    % This matrix compares the actual and predicted classes to determine TP, FP, FN, and TN.
    cm = confusionmat(actual, predicted);
    
    % Number of classes
    % Determine how many classes are in the data based on the confusion matrix size.
    numClasses = size(cm, 1);
    
    % Initialize metrics
    % These arrays will store the precision, recall, F1 score, and accuracy for each class.
    precision = zeros(numClasses, 1);
    recall = zeros(numClasses, 1);
    f1Score = zeros(numClasses, 1);
    accuracy = zeros(numClasses, 1);
    
    % Calculate precision, recall, F1 score, and accuracy for each class
    for i = 1:numClasses
        % True Positives (TP): Correctly predicted instances of class i
        TP = cm(i, i);
        
        % False Positives (FP): Incorrectly predicted as class i
        FP = sum(cm(:, i)) - TP;
        
        % False Negatives (FN): Instances of class i incorrectly predicted as another class
        FN = sum(cm(i, :)) - TP;
        
        % True Negatives (TN): All other instances correctly predicted as not class i
        TN = sum(cm(:)) - (TP + FP + FN);
        
        % Calculate accuracy for class i
        accuracy(i) = (TP + TN) / (TP + TN + FP + FN);
        
        % Calculate precision for class i
        % Handle division by zero by setting NaN to 0.
        precision(i) = TP / (TP + FP);
        if isnan(precision(i))
            precision(i) = 0;
        end
        
        % Calculate recall for class i
        % Handle division by zero by setting NaN to 0.
        recall(i) = TP / (TP + FN);
        if isnan(recall(i))
            recall(i) = 0;
        end
        
        % Calculate F1 score for class i
        % Handle division by zero by setting NaN to 0.
        f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
        if isnan(f1Score(i))
            f1Score(i) = 0;
        end
    end
end