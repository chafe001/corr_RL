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
cuePairs(1).pairRespSide = 1;

% CUE PAIR 2: cue 1 left, cue 2 right, RIGHT response
cuePairs(2).leftStim = blockStim.cue(1,1);
cuePairs(2).rightStim = blockStim.cue(2,2);
cuePairs(2).leftStimStr = 'left cue 1';
cuePairs(2).rightStimStr = 'right cue 2';
cuePairs(2).pairID = [1 2]; % left cue and right cue array indices
cuePairs(2).pairRespSide = 2;

% CUE PAIR 3: cue 2 left, cue 1 right, LEFT response
cuePairs(3).leftStim = blockStim.cue(1,2);
cuePairs(3).rightStim = blockStim.cue(2,1);
cuePairs(3).leftStimStr = 'left cue 2';
cuePairs(3).rightStimStr = 'right cue 1';
cuePairs(3).pairID = [2 1]; % left cue and right cue array indices
cuePairs(3).pairRespSide = 2;

% CUE PAIR 4: cue 2 left, cue 2 right, RIGHT response
cuePairs(4).leftStim = blockStim.cue(1,2);
cuePairs(4).rightStim = blockStim.cue(2,2);
cuePairs(4).leftStimStr = 'left cue 2';
cuePairs(4).rightStimStr = 'left cue 2';
cuePairs(4).pairID = [2 2]; % left cue and right cue array indices
cuePairs(4).pairRespSide = 1;

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

% --- NEW NOISE METHOD
% noise pairs contain 1 cue stimulus, and 1 noise stimulus, this breaks
% correlation specifically between cue stimuli, by presenting one without
% its pair 

% --- CUE LEFT, NOISE RIGHT PAIRS
% NOISE PAIR 1: cue 1 left, noise 1 right
noisePairs(1).leftStim = blockStim.cue(1,1);
noisePairs(1).rightStim = blockStim.noise(2,1);
noisePairs(1).leftStimStr = 'left cue 1';
noisePairs(1).rightStimStr = 'right noise 1';
noisePairs(1).pairID = [1 11]; % left cue and right noise array indices
noisePairs(1).pairRespSide = NaN;

% NOISE PAIR 2: cue 1 left, noise 2 right
noisePairs(2).leftStim = blockStim.cue(1,1);
noisePairs(2).rightStim = blockStim.noise(2,2);
noisePairs(2).leftStimStr = 'left cue 1';
noisePairs(2).rightStimStr = 'right noise 2';
noisePairs(2).pairID = [1 12]; % left cue and right noise array indices
noisePairs(2).pairRespSide = NaN;

% NOISE PAIR 3: cue 2 left, noise 1 right
noisePairs(3).leftStim = blockStim.cue(1,2);
noisePairs(3).rightStim = blockStim.noise(2,1);
noisePairs(3).leftStimStr = 'left cue 2';
noisePairs(3).rightStimStr = 'right noise 1';
noisePairs(3).pairID = [2 11]; % left cue and right noise array indices
noisePairs(3).pairRespSide = NaN;

% NOISE PAIR 4: cue 2 left, noise 2 right
noisePairs(4).leftStim = blockStim.cue(1,2);
noisePairs(4).rightStim = blockStim.noise(2,2);
noisePairs(4).leftStimStr = 'left cue 2';
noisePairs(4).rightStimStr = 'right noise 2';
noisePairs(4).pairID = [2 12]; % left cue and right noise array indices
noisePairs(4).pairRespSide = NaN;


% --- NOISE LEFT, CUE RIGHT PAIRS
% NOISE PAIR 5: noise 1 left, cue 1 right
noisePairs(5).leftStim = blockStim.noise(1,1);
noisePairs(5).rightStim = blockStim.cue(2,1);
noisePairs(5).leftStimStr = 'left noise 1';
noisePairs(5).rightStimStr = 'right cue 1';
noisePairs(5).pairID = [11 1]; % left noise and right cue array indices
noisePairs(5).pairRespSide = NaN;

% NOISE PAIR 6: noise 1 left, cue 2 right
noisePairs(6).leftStim = blockStim.noise(1,1);
noisePairs(6).rightStim = blockStim.cue(2,2);
noisePairs(6).leftStimStr = 'left noise 1';
noisePairs(6).rightStimStr = 'right cue 2';
noisePairs(6).pairID = [11 2]; % left noise and right cue array indices
noisePairs(6).pairRespSide = NaN;

% NOISE PAIR 7: noise 2 left, cue 1 right
noisePairs(7).leftStim = blockStim.noise(1,2);
noisePairs(7).rightStim = blockStim.cue(2,1);
noisePairs(7).leftStimStr = 'left noise 2';
noisePairs(7).rightStimStr = 'right cue 1';
noisePairs(7).pairID = [12 1]; % left noise and right cue array indices
noisePairs(7).pairRespSide = NaN;

% NOISE PAIR 8: noise 2 left, cue 2 right
noisePairs(8).leftStim = blockStim.noise(1,2);
noisePairs(8).rightStim = blockStim.cue(2,2);
noisePairs(8).leftStimStr = 'left noise 2';
noisePairs(8).rightStimStr = 'right cue 2';
noisePairs(8).pairID = [12 2]; % left noise and right cue array indices
noisePairs(8).pairRespSide = NaN;

end