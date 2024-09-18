




%Mean Accuracy 
Accuracy = 0.83; 
Total_entires = 100; 

%Actual array 
actual = [zeros(1,Total_entires), ones(1,Total_entires)]';

%Predicted array
predicted = actual;       

% Generate a random permutation of indices
random_indices = randperm(length(actual));

actual_randomized = actual(random_indices);
predicted_randomized = predicted(random_indices);

% Generate random indices for flipping
random_flip_indices = randperm(length(actual_randomized), length(actual) - length(actual)*Accuracy);

% Flip the values in predicted array at the randomly selected indices
predicted_randomized(random_flip_indices) = 1 - actual_randomized(random_flip_indices);


accuracyOfModel = ((sum(actual_randomized == predicted_randomized)) / length(actual_randomized)) * 100;


% Define the folder path where you want to save the files
folder_path = 'D:\Github\BCIWristIdentification2\OwnResults\ExperimentsResults\OpenDay';  % Replace with your desired folder path

if ~exist(folder_path, 'dir')
    mkdir(folder_path);
end

% Save the 'actual' array to the specified folder
writematrix(actual_randomized, fullfile(folder_path, 'actual.csv'));

% Save the 'predicted' array to the specified folder
writematrix(predicted_randomized, fullfile(folder_path, 'predicted.csv'));
