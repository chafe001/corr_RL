function [cuePairs, noisePairs] = corr_RL_pairStimuli_v2(blockStim)
% corr_RL_pairStimuli builds 2 sets of orthogonal pairs from 4 cue stimuli
% randomly selected within feature space

% --- constants
LEFT = 1;
RIGHT = 2;

% Stimulus crossing scheme below should ensure that each stimulus on each
% side of the display is associated with RIGHT response on half of trials
% and LEFT response on the remaining half (so no single stimulus is
% correlated with response side, need to decode the pair to select
% direction)


% --- CUE PAIRS
% CUE PAIR 1: Stim 1L-2R: LEFT response
cuePairs(1).leftStim = blockStim.cue(1);
cuePairs(1).rightStim = blockStim.cue(2);
cuePairs(1).pairID = [1 2]; % left cue and right cue array indices
cuePairs(1).pairState = 1;

% CUE PAIR 2: Stim 3L-4R: LEFT response
cuePairs(2).leftStim = blockStim.cue(3);
cuePairs(2).rightStim = blockStim.cue(4);
cuePairs(2).pairID = [3 4]; % left cue and right cue array indices
cuePairs(2).pairState = 1;

% CUE PAIR 3: Stim 1-3: RIGHT response
cuePairs(3).leftStim = blockStim.cue(1);
cuePairs(3).rightStim = blockStim.cue(4);
cuePairs(3).pairID = [1 3]; % left cue and right cue array indices
cuePairs(3).pairState = 2;

% CUE PAIR 4: Stim 2-4: RIGHT response
cuePairs(4).leftStim = blockStim.cue(3);
cuePairs(4).rightStim = blockStim.cue(2);
cuePairs(4).pairID = [2 4]; % left cue and right cue array indices
cuePairs(4).pairState = 2;

% --- NOISE PAIRS
% Same feature combinations as cues but screen position (left/right)
% inverted

% NOISE PAIR 1: Stim 1L-2R: LEFT response
noisePairs(1).leftStim = blockStim.cue(2);
noisePairs(1).rightStim = blockStim.cue(1);
noisePairs(1).pairID = [2 1]; % left cue and right cue array indices
noisePairs(1).pairState = NaN;

% NOISE PAIR 2: Stim 3L-4R: LEFT response
noisePairs(2).leftStim = blockStim.cue(4);
noisePairs(2).rightStim = blockStim.cue(3);
noisePairs(2).pairID = [4 3]; % left cue and right cue array indices
noisePairs(2).pairState = NaN;

% NOISE PAIR 3: Stim 1-3: RIGHT response
noisePairs(3).leftStim = blockStim.cue(4);
noisePairs(3).rightStim = blockStim.cue(1);
noisePairs(3).pairID = [4 1]; % left cue and right cue array indices
noisePairs(3).pairState = NaN;

% NOISE PAIR 4: Stim 2-4: RIGHT response
noisePairs(4).leftStim = blockStim.cue(2);
noisePairs(4).rightStim = blockStim.cue(3);
noisePairs(4).pairID = [2 3]; % left cue and right cue array indices
noisePairs(4).pairState = NaN;






end