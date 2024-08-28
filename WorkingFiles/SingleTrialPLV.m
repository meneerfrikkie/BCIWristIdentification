function PLV = SingleTrialPLV(data, CH_selection, CH_pairs, t1, t2, times)
  numPairs = length(CH_pairs);


   all_plv_values = zeros(1,length(CH_pairs));

  for i = 1:length(CH_pairs)
      % Get the channel pair and corresponding indices
        channels = checkChannelPairs(CH_pairs(i));
        ch1 = channels(1);
        ch2 = channels(2);

        % Find column indices in the data matrix
        col1 = find(strcmp(CH_selection, ch1));
        col2 = find(strcmp(CH_selection, ch2));

        if isempty(col1) || isempty(col2)
            error('Channel names %s or %s not found in CH_selection.', ch1, ch2);
        end

        disp(size(data))
        % Extract data for the specific channel and pass the required time
        % that the instantaneous phase will be calculated for
        data1 = SingleTrialChannelIPNoUnwrap(data(1,:,col1),t1,t2,times);
        data2 = SingleTrialChannelIPNoUnwrap(data(1,:,col2),t1,t2,times);

        all_plv_values(i) = abs(mean(  exp( 1i.*abs(  data1   -   data2)   )   ));

  end 

    % Create the table
  PLV = array2table(all_plv_values, 'VariableNames', CH_pairs);

end 