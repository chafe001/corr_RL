function [cuePairs] = corr_RL_pairStimuli_v2(blockStim)
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

% --- BLOCKSTIM CUE STIM PAIRING SCHEME
% PAIR ID       LEFT STIM        RIGHT STIM       RESP DIR
% LEFT 1        CUE 1            CUE 1            LEFT
% LEFT 2        CUE 1            CUE 2            RIGHT
% RIGHT 1       CUE 2            CUE 1            RIGHT  
% RIGHT 2       CUE 2            CUE 2            LEFT

% Indexing for blockStim, is blockStim(screenSide,cueNum)

% CUE PAIR 1: cue 1 left, cue 1 right, LEFT response
cuePairs(1).leftStim = blockStim.cue(1,1);
cuePairs(1).rightStim = blockStim.cue(2,1);
cuePairs(1).leftStimStr = 'left cue 1';
cuePairs(1).rightStimStr = 'right cue 1';
cuePairs(1).pairID = [1 1]; % left cue and right cue array indices
cuePairs(1).pairState = 1;

% CUE PAIR 2: cue 1 left, cue 2 right, RIGHT response
cuePairs(2).leftStim = blockStim.cue(1,1);
cuePairs(2).rightStim = blockStim.cue(2,2);
cuePairs(2).leftStimStr = 'left cue 1';
cuePairs(2).rightStimStr = 'right cue 2';
cuePairs(2).pairID = [1 2]; % left cue and right cue array indices
cuePairs(2).pairState = 2;

% CUE PAIR 3: cue 2 left, cue 1 right, LEFT response
cuePairs(3).leftStim = blockStim.cue(1,2);
cuePairs(3).rightStim = blockStim.cue(2,1);
cuePairs(3).leftStimStr = 'left cue 2';
cuePairs(3).rightStimStr = 'right cue 1';
cuePairs(3).pairID = [2 1]; % left cue and right cue array indices
cuePairs(3).pairState = 2;

% CUE PAIR 4: cue 2 left, cue 2 right, RIGHT response
cuePairs(4).leftStim = blockStim.cue(1,2);
cuePairs(4).rightStim = blockStim.cue(2,2);
cuePairs(4).leftStimStr = 'left cue 2';
cuePairs(4).rightStimStr = 'left cue 2';
cuePairs(4).pairID = [2 2]; % left cue and right cue array indices
cuePairs(4).pairState = 1;

% DELETING NOISE PAIR FUNCTIONALITY FROM V1
% will either omit one of the two stimuli or replace it with a mask in
% generateStimMovie


end