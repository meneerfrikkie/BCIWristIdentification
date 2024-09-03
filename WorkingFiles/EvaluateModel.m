function [precision, recall,f1_score] = EvaluateModel(yPred, yTrue)
    % Compute for Class 1
    tp_1 = sum(yTrue == 1 & yPred == 1); % True Positives for class 1
    fp_1 = sum(yTrue == 0 & yPred == 1); % False Positives for class 1
    fn_1 = sum(yTrue == 1 & yPred == 0); % False Negatives for class 1

    precision_1 = tp_1 / (tp_1 + fp_1);
    recall_1 = tp_1 / (tp_1 + fn_1);
    f1_score_1 = (2*precision_1*recall_1)/(precision_1 + recall_1); 

    % Compute for Class 0
    tp_0 = sum(yTrue == 0 & yPred == 0); % True Positives for class 0
    fp_0 = sum(yTrue == 1 & yPred == 0); % False Positives for class 0
    fn_0 = sum(yTrue == 0 & yPred == 1); % False Negatives for class 0

    precision_0 = tp_0 / (tp_0 + fp_0);
    recall_0 = tp_0 / (tp_0 + fn_0);
    f1_score_0 = (2*precision_0*recall_0)/(precision_0 + recall_0) ;

    % Macro-averaging for precision and recall
    precision = (precision_1 + precision_0) / 2;
    recall = (recall_1 + recall_0) / 2;
    f1_score = (f1_score_0 + f1_score_1)/2; 
end
