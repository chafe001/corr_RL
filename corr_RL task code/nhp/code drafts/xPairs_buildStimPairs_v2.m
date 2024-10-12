function [stimPairs, noisePairs] = xPairs_buildStimPairs_v2(params)

% This function selects 4 indices randomly from stim array and combines
% them into 4 crossed pairs (xPairs)

% this code assumes array size = 8
if params.stimArraySize ~= 8
    error('buildStimPairs assumes array size 8, modify array or code');
end
% --- select 4 integers within range of stimulus size to select 4 stimulus
% positions from stimArray at random
ind.rndIndx = randperm(params.stimArraySize);
% --- divide the randomized index vector into subsets of indices to use for stim pairs
% (first 4 elements of randomized vector), and remainder of indices to use for noise pairs
ind.stimIndx = ind.rndIndx(1:4);
ind.noiseIndx = ind.rndIndx(5:end);

% --- use 4 randomly selected stim indices to create 4 crossed pairs
stimPairs(1).stim1_indx = ind.stimIndx(1);
stimPairs(1).stim1_fileName = 'filledCircle.png';
stimPairs(1).stim2_indx = ind.stimIndx(2);
stimPairs(1).stim2_fileName = 'filledCircle.png';
stimPairs(1).pairID = [1, 2];
stimPairs(1).rewState = 1;

stimPairs(2).stim1_indx = ind.stimIndx(3);
stimPairs(2).stim1_fileName = 'filledCircle.png';
stimPairs(2).stim2_indx = ind.stimIndx(4);
stimPairs(2).stim2_fileName = 'filledCircle.png';
stimPairs(2).pairID = [3, 4];
stimPairs(2).rewState = 1;

stimPairs(3).stim1_indx = ind.stimIndx(1);
stimPairs(3).stim1_fileName = 'filledCircle.png';
stimPairs(3).stim2_indx = ind.stimIndx(3);
stimPairs(3).stim2_fileName = 'filledCircle.png';
stimPairs(3).pairID = [1, 3];
stimPairs(3).rewState = 2;

stimPairs(4).stim1_indx = ind.stimIndx(2);
stimPairs(4).stim1_fileName = 'filledCircle.png';
stimPairs(4).stim2_indx = ind.stimIndx(4);
stimPairs(4).stim2_fileName = 'filledCircle.png';
stimPairs(4).pairID = [2, 4];
stimPairs(4).rewState = 2;

% --- generate noise pairs 
noisePairs(1).noise1_indx = ind.noiseIndx(1);
noisePairs(1).noise1_fileName = 'filledCircle.png';
noisePairs(1).noise2_indx = ind.noiseIndx(2);
noisePairs(1).noise2_fileName = 'filledCircle.png';
noisePairs(1).pairID = [1, 2];
noisePairs(1).rewState = -1;

noisePairs(2).noise1_indx = ind.noiseIndx(3);
noisePairs(2).noise1_fileName = 'filledCircle.png';
noisePairs(2).noise2_indx = ind.noiseIndx(4);
noisePairs(2).noise2_fileName = 'filledCircle.png';
noisePairs(2).pairID = [3, 4];
noisePairs(2).rewState = -1;

noisePairs(3).noise1_indx = ind.noiseIndx(1);
noisePairs(3).noise1_fileName = 'filledCircle.png';
noisePairs(3).noise2_indx = ind.noiseIndx(3);
noisePairs(3).noise2_fileName = 'filledCircle.png';
noisePairs(3).pairID = [1, 3];
noisePairs(3).rewState = -1;

noisePairs(4).noise1_indx = ind.noiseIndx(2);
noisePairs(4).noise1_fileName = 'filledCircle.png';
noisePairs(4).noise2_indx = ind.noiseIndx(4);
noisePairs(4).noise2_fileName = 'filledCircle.png';
noisePairs(4).pairID = [2, 4];
noisePairs(4).rewState = -1;

end