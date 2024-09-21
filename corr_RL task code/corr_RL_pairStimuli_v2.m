function [stateA_pairs, stateB_pairs, noisePairs] = corr_RL_pairStimuli_v2(blockStim, params)
% This function organizes blockStim into pairs

% VERSION HISTORY

% v1: original version implementing xPairs design. Blockstim input is 4
% stimuli, 2 at left and 2 at right screen positions.  pairStimuli
% organized these four stimuli into 4 orthogonal pairs.  Each stimulus
% belongs to 2 pairs instructing the two different states. This dissociates
% stimulus features from state

% v2: new pairing scheme.  Blockstim input is no longer allocated to screen
% positions left and right. The same vector of stimuli will be shown at
% screen left and right every trial.  Only the order of presentation will
% be controlled to alter pairing.  This seems a cleaner approach, a better
% way to dissociate stimulus features from state.

% --- constants
LEFT = 1;
RIGHT = 2;

% --- RANDOMLY PAIR LEFT and RIGHT CUE STIMULI
% this produces a unique pairing of the same stimuli shown at left and
% right positions for states A and B, while ensuring that the same set of
% stimuli appear at both locations for all movies, trials, and states.

stateA_leftVect = 1:params.numCueStim;
stateA_rightVect = stateA_leftVect(randperm(length(stateA_leftVect)));

stateB_leftVect = stateA_leftVect;
stateB_rightVect = stateA_rightVect(randperm(length(stateA_rightVect)));

noise_leftVect = 1 : size(blockStim.noise, 2);
noise_rightVect = noise_leftVect(randperm(length(noise_leftVect)));

% --- STATE A PAIRS
for p = 1 : length(stateA_leftVect)  % same number of cue pairs as number of cue stimuli
    stateA_pairs(p).leftStim = blockStim.cue(stateA_leftVect(p));
    stateA_pairs(p).rightStim = blockStim.cue(stateA_rightVect(p));
    stateA_pairs(p).pairID = [stateA_leftVect(p) stateA_rightVect(p)]; % left cue and right cue array indices
    stateA_pairs(p).pairRespSide = LEFT;
end

% --- STATE B PAIRS
for p = 1 : length(stateB_leftVect)  % same number of cue pairs as number of cue stimuli
    stateB_pairs(p).leftStim = blockStim.cue(stateB_leftVect(p));
    stateB_pairs(p).rightStim = blockStim.cue(stateB_rightVect(p));
    stateB_pairs(p).pairID = [stateB_leftVect(p) stateB_rightVect(p)]; % left cue and right cue array indices
    stateB_pairs(p).pairRespSide = RIGHT;
end

% --- NOISE PAIRS
for n = 1 : length(noise_leftVect)
    noisePairs(n).leftStim = blockStim.noise(noise_leftVect(n));
    noisePairs(n).rightStim = blockStim.noise(noise_rightVect(n));
    noisePairs(n).pairID = [stateB_leftVect(p) stateB_rightVect(n)]; % left cue and right cue array indices
    noisePairs(n).pairRespSide = NaN;
end



end