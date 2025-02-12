function [stateA_pairs, stateB_pairs] = corr_RL_nhp_onePairCond_v1(blockStim, params)
% This function organizes blockStim into pairs

% VERSION HISTORY

% v1: The same vector of stimuli will be shown at
% screen left and right every trial.  Only the order of presentation will
% be controlled to alter pairing.  

% --- constants
LEFT = 1;
RIGHT = 2;

% possible pairs for 2 cueStim defined
% 1 1
% 1 2
% 2 1
% 2 2

% --- Select stim pairs at random, from cue stim available, for stateA 
% and stateB, making sure they are different
stateA_leftStim = randi(params.numCueStim);
stateA_rightStim = randi(params.numCueStim);
stateA_pairVect = [stateA_leftStim stateA_rightStim];

bFound = false;

while ~bFound

    stateB_leftStim = randi(params.numCueStim);
    stateB_rightStim = randi(params.numCueStim);
    stateB_pairVect = [stateB_leftStim stateB_rightStim];
    if ~isequal(stateA_pairVect, stateB_pairVect)
        bFound = true;
    end

end


% --- USE SEQUENCE OF L/R STIM NUMS TO BUILD PAIR STRUCT

% --- STATE A PAIRS
stateA_ids = [];
for p = 1 : size(stateA_pairVect, 1)  % same number of cue pairs as number of cue stimuli
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
for p = 1 : size(stateB_pairVect, 1)  % same number of cue pairs as number of cue stimuli
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