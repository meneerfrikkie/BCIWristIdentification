 

highestAccuraciesNumberFeatures = [6,27,47,48,51,73];
temp = {'temp','temp'};
 HighestincludedPredictorNames = {temp;temp;temp;temp;temp;temp};




for f = 1:length(highestAccuraciesNumberFeatures)
                    storedPredictorNames = HighestincludedPredictorNames(f,:);                  
end

disp(data_WE(1,1,1))
disp(data_WE(1,1,2))