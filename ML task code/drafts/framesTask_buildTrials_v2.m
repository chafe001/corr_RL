
function [conditions, condReps, params, stimPos, stimImage] = framesTask_buildTrials_v2()

% This utility function builds the condition and trial arrays.  These are
% used to control the stimuli presented each trial. The condition and trial
% arrays supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions.

% VERSION NOTES:
% v2: no choice targets, for human subjects keyboard response version.
% Fixed, alternating high and low associative strength blocks.
%
% EXPERIMENTAL GOAL 1: find learning rate differences between high
% and low associative strength blocks.

% --- CONDITION ARRAY ---
% The condition array defines the set of experimental conditions that will be used.
% Each condition defines a state (A or B), a stimulus pair associated with the
% state, an associative strength for the pair, a choice array and reward
% probabilites on the choices

% - Stimulus pairs:
% Each individual stimulus must be associated with A and B states with
% equal probability, so that state is not tipped off by any single
% stimulus.  The state is indicated only by the association learned between
% pairs of stimuli, not the stimuli themselves.

% Given 4 stimuli (1, 2, 3, 4), the following pairing scheme balances
% stimuli across states:
% State A sequence 1 = 1-2
% State A sequence 2 = 3-4
% State B sequence 1 = 1-3
% State B sequence 2 = 2-4

% - Associative strength:
% Each trial, a sequence of rapidly displayed stimulus pairs will be shown.
% The associative strength of the pair in the movie will be controlled by
% varying the order in which the two stimuli are shown, the interval between
% stimuli (within the STDP window), and the number of times the pair is shown.
% We will add noise pairs to low associative strength movies with few pair repetitions
% to keep total numbers of pairs in the movies constant.

% - Each condition number must contain enough information to determine a
% trial and contain
% - stimulus 1 image and location
% - stimulus 2 image and location
% - the order of presentation (stimulus 1 and 2)
% - the stimulus onset asynchrony between stimuli in the pair
% - the number of times the pair is shown each trial

% --- TRIAL ARRAY ---
% The trial array is a one dimensional vector of condition numbers
% comprising a trial stack from which conditions are drawn at random to
% control stimulus generation for each trial.


%% -------- GENERATE STIMULUS SEQUENCES AND ASSIGN TO CONDITIONS --------------
% Assign random stimulus sequences to condition numbers within blocks
params.stimRadius = 7;
r = params.stimRadius;
x_45 = r/sqrt(2);
y_45 = r/sqrt(2);

% NOTE: visual angles for a 24" Dell 2414 monitor viewed at 24" (~60 cm)
% +/- 23 degrees horizontal (edge to edge)
% +/- 14 degreees vertical
% params.stimRadius = 7 works on standard 24" display

% --- Stimulus position array in degrees
% near positions
stimPos(1).posXY = [r 0];
stimPos(1).posLabel = 'R_near';
stimPos(2).posXY = [x_45, y_45];
stimPos(2).posLabel = 'UR_near';
stimPos(3).posXY = [-x_45 y_45];
stimPos(3).posLabel = 'UL_near';
stimPos(4).posXY = [-r 0];
stimPos(4).posLabel = 'L_near';
stimPos(5).posXY = [-x_45 -y_45];
stimPos(5).posLabel = 'LL_near';
stimPos(6).posXY = [x_45 -y_45];
stimPos(6).posLabel = 'LR_near';
% far positions
stimPos(7).posXY = [(r * 2) 0];
stimPos(7).posLabel = 'R_far';
stimPos(8).posXY = [(x_45 * 2) (y_45 * 2)];
stimPos(8).posLabel = 'UR_far';
stimPos(9).posXY = [-(x_45 * 2) (y_45 * 2)];
stimPos(9).posLabel = 'UL_far';
stimPos(10).posXY = [-(r * 2) 0];
stimPos(10).posLabel = 'L_far';
stimPos(11).posXY = [-(x_45 * 2) -(y_45 * 2)];
stimPos(11).posLabel = 'LL_far';
stimPos(12).posXY = [(x_45 * 2) -(y_45 * 2)];
stimPos(12).posLabel = 'LR_far';

% --- Stimulus image array
stimImage(1).fileName = 'p1.png';
stimImage(1).stimID = 1;
stimImage(1).str = 'p1_image';
stimImage(2).fileName = 'p2.png';
stimImage(2).stimID = 2;
stimImage(2).str = 'p2_image';

% --- params
params.numBlocks = 4;  %NOTE: THIS SHOULD MATCH NUM BLOCKS IN CONDITIONS FILE
params.maxPairReps = 16;
params.noisePairs = true;
params.dur = 1; % in screen refresh units
params.interPair = 6; % in screen refresh units, time depends on frame rate
% these variables control associative strength of block. Stimulus order and
% SOA are randomized at time of movie generation.
params.strongHebb.pairProb = 0.9;
params.strongHebb.pairOrder = 'fixed';
params.strongHebb.pairSoaRange = [1 1];  % min and max multiples of screen refresh
params.weakHebb.pairProb = 0.6;
params.weakHebb.pairOrder = 'random';
params.weakHebb.pairSoaRange = [1 1];  % min and max multiples of screen refresh

% Each block is a set of 4 stimulus combinations, A1, A2, B1, B2 crossing
% 4 stimuli into 4 pairs to dissociate state and individual stimuli,
% defining state in relation to the pair only

% --- set alternating strong/weak block associative strenth parameters

% flip coin to decide whether to start with strong or weak block
strongFirst = randi(2);

% Loop through blocks, set params
for b = 1 : params.numBlocks
    if strongFirst == 1
        % set block associative strength to strong or weak
        if mod(b, 2) == 1  % ODD block number
            blockPairReps = floor(params.strongHebb.pairProb * params.maxPairReps);
            order = params.strongHebb.pairOrder;
            soaRange = params.strongHebb.pairSoaRange;
            assocStrength = 'strong';
        else  % EVEN block number
            blockPairReps = floor(params.weakHebb.pairProb * params.maxPairReps);
            order = params.weakHebb.pairOrder;
            soaRange = params.weakHebb.pairSoaRange;
            assocStrength = 'weak';
        end
    else
        % set block associative strength to strong or weak
        if mod(b, 2) == 0  % EVEN block number
            blockPairReps = floor(params.strongHebb.pairProb * params.maxPairReps);
            order = params.strongHebb.pairOrder;
            soaRange = params.strongHebb.pairSoaRange;
            assocStrength = 'strong';
        else  % ODD block number
            blockPairReps = floor(params.weakHebb.pairProb * params.maxPairReps);
            order = params.weakHebb.pairOrder;
            soaRange = params.weakHebb.pairSoaRange;
            assocStrength = 'weak';
        end
    end


    % 3. select 4 random gabor stimuli and positions to use for this block.
    % Do this by selecting random indices to reference into the image and
    % position arrays.  When selecting position, use randperm to select 4
    % random and unique integers from 1-n where n is the number of stimulus
    % positions in the array (size(stimPos)). This ensures 4 unique
    % locations are selected, hence 4 unique stimuli. When selecting an
    % index to reference into the stimImage array, select 4 random integers
    % in the range of the number of different stimuli.  This allows the
    % same stimulus  gabor to be used more than once.
    posIndx = randperm(size(stimPos, 2), 4);
    imgIndx = randi(size(stimImage, 2), [1 4]);

    % 4. Use indices to define stimulus images and positions for blockStim
    % blockStim specifies the image files and position for each of the 4
    % randomly selected stimuli for this block
    for i = 1 : 4
        blockStim(i).img = stimImage(imgIndx(i));
        blockStim(i).pos = stimPos(posIndx(i));
    end

    % 4. Cross individual stimuli into pairs associated with states A and B
    % such that each stimulus is equally associated with states A and B
    % considered individually.  Rather, the state is indicated only by how
    % individual stimuli are paired (requiring association).

    % A-state, stimulus pair 1-2, choice configuration 1
    conditions(b, 1).blockNum = b;
    conditions(b, 1).condNum = ((b-1) * 4) + 1;
    conditions(b, 1).state = 1; % A-state
    conditions(b, 1).strength = assocStrength;
    conditions(b, 1).interPair = params.interPair;
    conditions(b, 1).pair.id = '1_2'; % A1 state pair
    conditions(b, 1).pair.stim1 = blockStim(1);
    conditions(b, 1).pair.stim2 = blockStim(2);
    conditions(b, 1).pair.reps = blockPairReps;
    conditions(b, 1).pair.order = order;
    conditions(b, 1).pair.soaRange = soaRange;
    
    % A-state, stimulus pair 3-4, choice configuration 1
    conditions(b, 2).blockNum = b;
    conditions(b, 2).condNum = ((b-1) * 4) + 2;
    conditions(b, 2).state = 1; % A-state
    conditions(b, 2).strength = assocStrength;
    conditions(b, 2).interPair = params.interPair;
    conditions(b, 2).pair.id = '3_4'; % A2 state pair
    conditions(b, 2).pair.stim1 = blockStim(3);
    conditions(b, 2).pair.stim2 = blockStim(4);
    conditions(b, 2).pair.reps = blockPairReps;
    conditions(b, 2).pair.order = order;
    conditions(b, 2).pair.soaRange = soaRange;
    
    % B-state, stimulus pair 1-3, choice configuration 1
    conditions(b, 3).blockNum = b;
    conditions(b, 3).condNum = ((b-1) * 4) + 3;
    conditions(b, 3).state = 2; % B-state
    conditions(b, 3).strength = assocStrength;
    conditions(b, 3).interPair = params.interPair;
    conditions(b, 3).pair.id = '1_3'; % B1 state pair
    conditions(b, 3).pair.stim1 = blockStim(1);
    conditions(b, 3).pair.stim2 = blockStim(3);
    conditions(b, 3).pair.reps = blockPairReps;
    conditions(b, 3).pair.order = order;
    conditions(b, 3).pair.soaRange = soaRange;
    
    % B-state, stimulus pair 2-4, choice configuration 1
    conditions(b, 4).blockNum = b;
    conditions(b, 4).condNum = ((b-1) * 4) + 4;
    conditions(b, 4).state = 2; % B-state
    conditions(b, 4).strength = assocStrength;
    conditions(b, 4).interPair = params.interPair;
    conditions(b, 4).pair.id = '2_4'; % B2 state pair
    conditions(b, 4).pair.stim1 = blockStim(2);
    conditions(b, 4).pair.stim2 = blockStim(4);
    conditions(b, 4).pair.reps = blockPairReps;
    conditions(b, 4).pair.order = order;
    conditions(b, 4).pair.soaRange = soaRange;
    
end

% Convert contitions matrix into a one dimensional struct array
condArray = [];
for b = 1 : params.numBlocks
    thisCond = conditions(b, :)';
    condArray = [condArray; thisCond];
end
conditions = condArray;


%% -------- BUILD TRIAL STACK --------
% Create a one-dimensional array of rep counters, one for each condition.
% This will work because each block has a unique set of conditions, so the
% block can be indexed by the condition number

params.repsPerCond = 5;

for c = 1 : size(conditions, 1)
    condReps(c) = params.repsPerCond;
end

bob = 1;


end

