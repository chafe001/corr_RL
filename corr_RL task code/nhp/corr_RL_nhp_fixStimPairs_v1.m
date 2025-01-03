function [stateA_pairs, stateB_pairs] = corr_RL_nhp_fixStimPairs_v1(blockStim, params)
% This function takes blockStim (generated by sampleStimSpace) as input,
% and returns the stimuli organized into fixed pairs associated with stateA and
% stateB.

% --- constants
LEFT = 1;
RIGHT = 2;


% --- hard code pairs by fixing indices into blockStim for stateA and B

switch params.numCueStim

    case 2
        % stateA
        % 1 1
        % 2 2

        % stateB
        % 1 2
        % 2 1

        stateA_pairVect = [1 1; 2 2];
        stateB_pairVect = [1 2; 2 1];

    case 3
        % stateA
        % 1 3
        % 2 1
        % 3 2

        % stateB
        % 1 2
        % 2 3
        % 3 1

        stateA_pairVect = [1 3; 2 1; 3 2];
        stateB_pairVect = [1 2; 2 3; 3 1];

    case 4
        % stateA
        % 1 3
        % 2 1
        % 3 4
        % 4 2

        % stateB
        % 1 4
        % 2 3
        % 3 2
        % 4 1

        stateA_pairVect = [1 3; 2 1; 3 4; 4 2];
        stateB_pairVect = [1 4; 2 3; 3 2; 4 1];

    otherwise

        error('unknown numCueStim in fixStimPairs')


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
for p = 1 : length(stateB_pairVect)  % same number of cue pairs as number of cue stimuli
    stateB_pairs(p).leftStim = blockStim.cue(stateB_pairVect(p, 1));
    stateB_pairs(p).leftStim.Position = params.leftPos;
    stateB_pairs(p).rightStim = blockStim.cue(stateB_pairVect(p, 2));
    stateB_pairs(p).rightStim.Position = params.rightPos;
    stateB_pairs(p).pairID = [stateB_pairVect(p, 1) stateB_pairVect(p, 2)]; % left cue and right cue array indices
    stateB_pairs(p).pairRespSide = RIGHT;
    % accumulate ids for pair checking below
    stateB_ids = [stateB_ids; stateB_pairs(p).pairID ];
end


end