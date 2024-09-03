function [precision, recall, f1Score, accuracy] = ConfusionMetrics(actual, predicted)
    % Compute confusion matrix
    cm = confusionmat(actual, predicted);
    
    % Number of classes
    numClasses = size(cm, 1);
    
    % Initialize metrics
    precision = zeros(numClasses, 1);
    recall = zeros(numClasses, 1);
    f1Score = zeros(numClasses, 1);
    
    % Calculate precision, recall, and F1 score for each class
    for i = 1:numClasses
        TP = cm(i, i); % True Positives for class i
        FP = sum(cm(:, i)) - TP; % False Positives for class i
        FN = sum(cm(i, :)) - TP; % False Negatives for class i
        TN = sum(cm(:)) - (TP + FP + FN); % True Negatives for class i
        
        accuracy(i) = (TP + TN) / (TP + TN + FP + FN);
        precision(i) = TP / (TP + FP);
        recall(i) = TP / (TP + FN);
        f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
    end
end