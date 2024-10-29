function [stateA_pairs, stateB_pairs] = corr_RL_pairStimuli_v3(blockStim, params)
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

stateA_leftVect = (1:params.numCueStim)';
aRightFound = false;
% ensure that randperm does not return the original vector 1:4, which it is
% able to do, to prevent left stim from being same as right stim
while ~aRightFound
    stateA_rightVect = stateA_leftVect(randperm(length(stateA_leftVect)));
    if ~isequal(stateA_leftVect, stateA_rightVect)
        aRightFound = true;
    end
end


stateA_pairVect = [stateA_leftVect stateA_rightVect];

bFound = false;
while ~bFound

    stateB_leftVect = stateA_leftVect;
    stateB_rightVect = randperm(length(stateA_rightVect))';

    stateB_pairVect = [stateB_leftVect stateB_rightVect];

    % check for rows common to both stateA_pairVect and stateB_pairVect
    samePairs = ismember(stateA_pairVect, stateB_pairVect, 'rows');

    if sum(samePairs) == 0  % no rows in common bwt stateA and stateB
        bFound = true;
    end

end

% --- STATE A PAIRS
stateA_ids = [];
for p = 1 : length(stateA_pairVect)  % same number of cue pairs as number of cue stimuli
    stateA_pairs(p).leftStim = blockStim.cue(stateA_pairVect(p, 1));
    stateA_pairs(p).leftStim.Position = params.leftPos;
    stateA_pairs(p).rightStim = blockStim.cue(stateA_pairVect(p, 2));
    stateA_pairs(p).rightStim.Position = params.rightPos;
    stateA_pairs(p).pairID = [stateA_pairVect(p, 1) stateA_pairVect(p, 2)]; 
    stateA_pairs(p).pairRespSide = LEFT;
    % accumulate ids for pair checking below
    stateA_ids = [stateA_ids; stateA_pairs(p).pairID ];
end

% --- STATE B PAIRS
stateB_ids = [];
for p = 1 : length(stateB_leftVect)  % same number of cue pairs as number of cue stimuli
    stateB_pairs(p).leftStim = blockStim.cue(stateB_pairVect(p, 1));
    stateB_pairs(p).leftStim.Position = params.leftPos;
    stateB_pairs(p).rightStim = blockStim.cue(stateB_pairVect(p, 2));
    stateB_pairs(p).rightStim.Position = params.rightPos;
    stateB_pairs(p).pairID = [stateB_pairVect(p, 1) stateB_pairVect(p, 2)]; % left cue and right cue array indices
    stateB_pairs(p).pairRespSide = RIGHT;
    % accumulate ids for pair checking below
    stateB_ids = [stateB_ids; stateB_pairs(p).pairID ];
end



% --- CHECK PAIRS to make sure so pairs in common across state

bob = 1;

end