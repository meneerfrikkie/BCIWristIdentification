% Import necessary libraries
import java.util.Random;

% Load data
X = 1;
y = 1; 

% Create SVM classifier
classifier = fitcsvm(X, y);

% Initialize RFE object
numFeaturesToSelect = 10; % Adjust as needed
rfe = RFE(classifier, 'NumFeatures', numFeaturesToSelect);

% Train RFE model
[features, ranking] = rfe.fit(X, y);

% Extract selected features
selectedFeatures = X(:, features);