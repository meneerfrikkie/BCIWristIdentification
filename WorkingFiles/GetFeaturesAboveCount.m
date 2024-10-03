function filteredFeatures = GetFeaturesAboveCount(data, minCount)
    % Extract feature names and counts
    featureNames = data.FeatureName;
    featureCounts = data.Count;
    
    % Initialize an empty cell array for storing filtered features
    filteredFeatures = {};
    
    % Loop through all features and add to filteredFeatures if count is greater than minCount
    for i = 1:length(featureCounts)
        if featureCounts(i) > minCount
            filteredFeatures{end + 1} = featureNames{i};
        end
    end
end