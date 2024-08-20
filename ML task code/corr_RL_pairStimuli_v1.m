function [cuePairs_leftResp, cuePairs_rightResp, noisePairs] = corr_RL_pairStimuli_v1(blockStim, params)
% corr_RL_pairStimuli builds 2 sets of orthogonal pairs from 4 cue stimuli
% randomly selected within feature space

% --- constants
LEFT = 1;
RIGHT = 2;

% --- BLOCKSTIM CUE STIM PAIRING SCHEME
% PAIR ID       LEFT STIM        RIGHT STIM       RESP DIR
% LEFT 1        CUE 1            CUE 1            LEFT
% LEFT 2        CUE 2            CUE 1            LEFT
% RIGHT 1       CUE 1            CUE 2            RIGHT  
% RIGHT 2       CUE 2            CUE 2            RIGHT

% Indexing for blockStim, is blockStim(screenSide,cueNum)

% CUE PAIR 1: cue 1 left, cue 1 right, LEFT response
cuePairs_leftResp(1).leftStim = blockStim.cue(1,1);
cuePairs_leftResp(1).rightStim = blockStim.cue(2,1);

% CUE PAIR 2: cue 1 left, cue 2 right, RIGHT response
cuePairs_leftResp(2).leftStim = blockStim.cue(1,1);
cuePairs_leftResp(2).rightStim = blockStim.cue(2,2);

% CUE PAIR 3: cue 2 left, cue 1 right, LEFT response
cuePairs_rightResp(1).leftStim = blockStim.cue(1,2);
cuePairs_rightResp(1).rightStim = blockStim.cue(2,1);

% CUE PAIR 4: cue 2 left, cue 2 right, RIGHT response
cuePairs_rightResp(2).leftStim = blockStim.cue(1,2);
cuePairs_rightResp(2).rightStim = blockStim.cue(2,2);

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

% NOISE PAIR 1: cue 1 left, noise 1 right
noisePairs(1).leftStim = blockStim.cue(1,1);
noisePairs(1).rightStim = blockStim.noise(2,1);

% NOISE PAIR 2: cue 1 left, noise 2 right
noisePairs(2).leftStim = blockStim.cue(1,1);
noisePairs(2).rightStim = blockStim.noise(2,2);

% NOISE PAIR 3: cue 2 left, noise 1 right
noisePairs(3).leftStim = blockStim.cue(1,2);
noisePairs(3).rightStim = blockStim.noise(2,1);

% NOISE PAIR 4: cue 2 left, noise 2 right
noisePairs(4).leftStim = blockStim.cue(1,2);
noisePairs(4).rightStim = blockStim.noise(2,2);

% NOISE PAIR 5: cue 1 left, noise 1 right
noisePairs(5).leftStim = blockStim.noise(1,1);
noisePairs(5).rightStim = blockStim.cue(2,1);

% NOISE PAIR 6: cue 1 left, noise 2 right
noisePairs(6).leftStim = blockStim.noise(1,1);
noisePairs(6).rightStim = blockStim.cue(2,2);

% NOISE PAIR 7: cue 2 left, noise 1 right
noisePairs(7).leftStim = blockStim.noise(1,2);
noisePairs(7).rightStim = blockStim.cue(2,1);

% NOISE PAIR 8: cue 2 left, noise 2 right
noisePairs(8).leftStim = blockStim.noise(1,2);
noisePairs(8).rightStim = blockStim.cue(2,2);

end