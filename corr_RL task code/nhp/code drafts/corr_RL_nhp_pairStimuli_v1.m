function [stateA_pairs, stateB_pairs] = corr_RL_nhp_pairStimuli_v1(blockStim, params)
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
% be controlled to alter pairing.  

% --- constants
LEFT = 1;
RIGHT = 2;

% --- RANDOMLY PAIR LEFT and RIGHT CUE STIMULI
% this produces a unique pairing of the same stimuli shown at left and
% right positions for states A and B, while ensuring that the same set of
% stimuli appear at both locations for all movies, trials, and states.

% --- generate pairs of left and right stimuli for stateA.  
% Note: randperm generates a random integer vector from 1:n.  A sequential
% vector can occur as output. If that occurs stateA_leftVect ==
% stateA_rightVect.  That is fine so allow. This occurred accidently in v3
% but only for state 2, so better for that to occur equally for states A 
% B.

if params.constantPairs
    forwardVect = (1:params.numCueStim)';
    backwardVect = (params.numCueStim:-1:1)';

    stateA_leftVect = forwardVect;
    stateA_rightVect = forwardVect;
    stateA_pairVect = [stateA_leftVect stateA_rightVect];

    stateB_leftVect = forwardVect;
    stateB_rightVect = backwardVect;
    stateB_pairVect = [stateB_leftVect stateB_rightVect];

    bob = 1;

else

    stateA_leftVect = (1:params.numCueStim)';  % start with vector 1:n for left
    % randomly permute this vector for right stim
    stateA_rightVect = stateA_leftVect(randperm(params.numCueStim));
    % combine left and right to make pair for stateA
    stateA_pairVect = [stateA_leftVect stateA_rightVect];

    % --- generates pairs of left and right stimuli for stateB.  Make sure
    % stateB pairs ~= stateA pairs
    stateB_leftVect = (1:params.numCueStim)';  % start with vector 1:n for left
    % search for stateB_rightVect that is different from stateA_rightvect to
    % keep pairs distinct between states

    bFound = false;
    while ~bFound
        % generate test stateB_rightVect
        stateB_rightVect = stateB_leftVect(randperm(params.numCueStim));
        % pair with stateB_leftVect
        stateB_pairVect = [stateB_leftVect stateB_rightVect];
        % ensure stateB_pairVect ~= stateA_pairVect (states have distinct
        % pairs). Check for rows common to both stateA_pairVect and
        % stateB_pairVect, if there are none, good to go.
        samePairs = ismember(stateA_pairVect, stateB_pairVect, 'rows');
        if sum(samePairs) == 0  % no rows in common bwt stateA and stateB
            bFound = true;
        end
    end


end


% --- USE SEQUENCE OF L/R STIM NUMS TO BUILD PAIR STRUCT

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