function stimPairs = xPairs_buildStimPairs(params)

% This function selects 4 indices randomly from stim array and combines
% them into 4 crossed pairs (xPairs)

% --- select 4 integers within range of stimulus size to select 4 stimulus
% positions from stimArray at random
rndIndx = randperm(params.stimArraySize);
% --- divide the randomized index vector into subsets of indices to use for stim pairs
% (first 4 elements of randomized vector), and remainder of indices to use for noise pairs
stimIndx = rndIndx(1-4);
noiseIndx = rndIndx(5:end);

% --- use 4 randomly selected stim indices to create 4 crossed pairs
stimPairs(1).stim1_indx = stimIndx(1);
stimPairs(1).stim1_fileName = 'filledCircle.png';
stimPairs(1).stim2_indx = stimIndx(2);
stimPairs(1).stim2_fileName = 'filledCircle.png';
stimPairs(1).pairID = [1, 2];
stimPairs(1).rewState = 1;

stimPairs(2).stim1_indx = stimIndx(3);
stimPairs(2).stim1_fileName = 'filledCircle.png';
stimPairs(2).stim2_indx = stimIndx(4);
stimPairs(2).stim2_fileName = 'filledCircle.png';
stimPairs(2).pairID = [3, 4];
stimPairs(2).rewState = 1;

stimPairs(3).stim1_indx = stimIndx(1);
stimPairs(3).stim1_fileName = 'filledCircle.png';
stimPairs(3).stim2_indx = stimIndx(3);
stimPairs(3).stim2_fileName = 'filledCircle.png';
stimPairs(3).pairID = [1, 3];
stimPairs(3).rewState = 2;

stimPairs(4).stim1_indx = stimIndx(2);
stimPairs(4).stim1_fileName = 'filledCircle.png';
stimPairs(4).stim2_indx = stimIndx(4);
stimPairs(4).stim2_fileName = 'filledCircle.png';
stimPairs(4).pairID = [2, 4];
stimPairs(4).rewState = 2;

% --- use

end