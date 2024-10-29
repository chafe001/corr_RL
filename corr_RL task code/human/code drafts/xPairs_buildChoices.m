function choices = xPairs_buildChoices(params, c, rewState)

% This function specifies choice stimulus image, location, and reward
% probility.  These values depend on both reward state and choice
% configuration.

% --- reward state
% if stimPair reward state is 1, then choice 1 is high reward probability,
% and choice 2 is low reward probability
% if stimPair reward state is 2, then choice 2 is high reward probability,
% and choice 1 is low reward probabiltiy

% --- choice configuration
% if c (choice configuration) is 1, then choice 1 is left, choice 2 is right
% if c (choice configuration) is 2, then choice 2 is left, choice 1 is right


% choicePos array holds choice x,y locations.  This function returns an
% index into choicePosArray to access choice location information,
% analogous to buildStimPairs so code is functionally consistent for stim
% and choice location

choices(1).fileName = 'greenChoice.png';
choices(2).fileName = 'redChoice.png';

switch c  % choice configuration
    case 1
        choices(1).posIndx = 1; % green choice gets indx 1 into choicePos array, LEFT
        choices(2).posIndx = 2; % red choice gets indx 2 into choicePos array, RIGHT

    case 2
        choices(1).posIndx = 2; % green choice gets indx 2 into choicePos array, RIGHT
        choices(2).posIndx = 1; % red choice gets indx 1 into choicePos array, LEFT

    otherwise
        error('unknown choice configuration in xPairs_buildStimPairs')
end


switch rewState
    case 1
        choices(1).rewProb = params.highProb; % choice1 gets high reward probability
        choices(2).rewProb = params.lowProb; % choice2 gets low reward probability
    case 2
        choices(1).rewProb = params.lowProb; % choice1 gets low reward probability
        choices(2).rewProb = params.highProb; % choice2 gets high reward probability
end



end

