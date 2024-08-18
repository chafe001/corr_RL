function [cuePairs, noisePairs] = corr_RL_pairStimuli_v1(blockStim, params)
% corr_RL_pairStimuli builds 2 sets of orthogonal pairs from 4 cue stimuli
% randomly selected within feature space

% --- constants
LEFT = 1;
RIGHT = 2;

% --- BLOCKSTIM CUE STIM PAIRING SCHEME
% PAIR ID       LEFT STIM        RIGHT STIM       RESP DIR
% 1             CUE 1            CUE 1            LEFT
% 2             CUE 1            CUE 2            RIGHT  
% 3             CUE 2            CUE 1            LEFT
% 4             CUE 2            CUE 2            RIGHT

% Indexing for blockStim, is blockStim(screenSide,cueNum)

% CUE PAIR 1: cue 1 left, cue 1 right, LEFT response
cuePairs(1).left = blockStim.cue(1,1);
cuePairs(1).right = blockStim.cue(2,1);
cuePairs(1).respSide = LEFT;

% CUE PAIR 2: cue 1 left, cue 2 right, RIGHT response
cuePairs(2).left = blockStim.cue(1,1);
cuePairs(2).right = blockStim.cue(2,2);
cuePairs(2).respSide = RIGHT;

% CUE PAIR 3: cue 2 left, cue 1 right, LEFT response
cuePairs(3).left = blockStim.cue(1,2);
cuePairs(3).right = blockStim.cue(2,1);
cuePairs(3).respSide = LEFT;

% CUE PAIR 4: cue 2 left, cue 2 right, RIGHT response
cuePairs(4).left = blockStim.cue(1,2);
cuePairs(4).right = blockStim.cue(2,2);
cuePairs(4).respSide = RIGHT;

% --- BLOCKSTIM NOISE STIM PAIRING SCHEME
% PAIR ID       LEFT STIM        RIGHT STIM       RESP DIR
% 1             CUE 1            NOISE 1          N/A
% 2             CUE 1            NOISE 2          N/A  
% 3             CUE 2            NOISE 1          N/A
% 4             CUE 2            NOISE 2          N/A
% 5             NOISE 1          CUE 1            N/A
% 6             NOISE 1          CUE 2            N/A
% 7             NOISE 2          CUE 1            N/A
% 8             NOISE 2          CUE 2            N/A

% NOISE PAIR 1: cue 1 left, noise 1 right
noisePairs(1).left = blockStim.cue(1,1);
noisePairs(1).right = blockStim.noise(2,1);
noisePairs(1).respSide = NaN;

% NOISE PAIR 2: cue 1 left, noise 2 right
noisePairs(2).left = blockStim.cue(1,1);
noisePairs(2).right = blockStim.noise(2,2);
noisePairs(2).respSide = NaN;

% NOISE PAIR 3: cue 2 left, noise 1 right
noisePairs(3).left = blockStim.cue(1,2);
noisePairs(3).right = blockStim.noise(2,1);
noisePairs(3).respSide = NaN;

% NOISE PAIR 4: cue 2 left, noise 2 right
noisePairs(4).left = blockStim.cue(1,2);
noisePairs(4).right = blockStim.noise(2,2);
noisePairs(4).respSide = NaN;

% NOISE PAIR 5: cue 1 left, noise 1 right
noisePairs(5).left = blockStim.noise(1,1);
noisePairs(5).right = blockStim.cue(2,1);
noisePairs(5).respSide = NaN;

% NOISE PAIR 6: cue 1 left, noise 2 right
noisePairs(6).left = blockStim.noise(1,1);
noisePairs(6).right = blockStim.cue(2,2);
noisePairs(6).respSide = NaN;

% NOISE PAIR 7: cue 2 left, noise 1 right
noisePairs(7).left = blockStim.noise(1,2);
noisePairs(7).right = blockStim.cue(2,1);
noisePairs(7).respSide = NaN;

% NOISE PAIR 8: cue 2 left, noise 2 right
noisePairs(8).left = blockStim.noise(1,2);
noisePairs(8).right = blockStim.cue(2,2);
noisePairs(8).respSide = NaN;





end