function [stateA_pairs, stateB_pairs] = corr_RL_nhp_pairStimuli_v2(blockStim, params)
% This function takes blockStim (generated by sampleStimSpace) as input,
% and returns the stimuli organized into unique pairs associated with stateA and
% stateB. 

% The algorithm generates a n x 2 matrix of integers indicating which 
% stimuli to show at left (first col) and right (second col) locations in
% the display.  The numbers are used as indices into the blockStim array
% containing the stimulus info (filename) used to generate movies later.

% Rows in the matrix is equal to number of pairs specified.
% Two matrices are generated, one for stateA, one for stateB that have
% unique pairs (no pairs in common), but that have equal numbers of pairs
% and equal numbers of stimulus repetitions on each side.  The intention is
% that movies generated using these pairs will not vary in low level visual
% features between states.

% example: stateA_pairs = 
% 1  3
% 2  2
% 3  4
% 4  1

% stateB_pairs
% 1  2
% 2  4
% 3  1
% 4  3

% --- Desired functionality, achieved by interaction between buildTrials,
% sampleStimSpace, and pairStimuli:

% 1. randomized pairs at the start of each block (final design)

% 2. randomized pairs at start of run but held constant over blocks, 
% varying (randomly initialized) over runs of the program (training stage)

% 3. fixed pairs at start of run held constant over blocks, and over runs
% of the program (training stage).  To implement must modify 
% sampleStimSpace so that it is not random, as pairStimuli only
% produces indices into the blockStim structure produced by 
% sampleStimSpace, and if stimuli in blockStim vary, using a fixed set of 
% indices into blockStim will yield  different stimuli and produce 
% different movies

% 4. one pair per state, and one pair per trial (training stage)

% To generate stateA pairs, the algorithm

% 1. generates a sequential list indicating the cues to show on the left 
% side of the display, from 1:n where n is the params.numCueStim, defined 
% as the number of combinations of angles and colors specified,

% 2. then randomly permutes this list to determine the stimuli to show on
% the right side of the display for each pair.  This yields the output
% variable stateA_pairs

% To generate stateB pairs the algorithm

% 1. generates a sequential list indicating the cues to show on the left 
% side of the display, from 1:n where n is the params.numCueStim, defined 
% as the number of combinations of angles and colors specified (as above),

% 2. continues to randomly permute this list to determine the stimuli to
% show on the right side of the display for each pair, until the newly
% generated matrix has no pairs in common with stateA_pairs.  This
% determines the output variable stateB_pairs.

% VERSION HISTORY

% v1: first implementation for nhp of the algorithm defining stateA and
% stateB as different pairings of the same set of stimuli

% v2: adding onePair functionality, where only a single pair is shown each
% trial (and generalization happens over trials)

% --- constants
LEFT = 1;
RIGHT = 2;

if params.constantPairs
    % generate fixed seqeunce of numbers without randomization to create a
    % constant sequence of stimulus pairs for stateA and stateB
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