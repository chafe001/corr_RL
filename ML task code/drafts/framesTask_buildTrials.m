
function [conditions, trials, params, stimPos, stimImage] = HebbRL_buildTrials()

% This utility function builds the condition and trial arrays.  These are
% used to control the stimuli presented each trial. The condition and trial
% arrays supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions.

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
params.numBlocks = 4;
params.maxPairReps = 12;
params.noisePairs = true;
params.fixedOrder = false;
params.soa = 0; % in screen refresh units, time depends on frame rate
params.dur = 1; % in screen refresh units
params.interPair = 20; % in screen refresh units, time depends on frame rate

% Each block is a set of 4 stimulus combinations, A1, A2, B1, B2 crossing 
% 4 stimuli into 4 pairs to dissociate state and individual stimuli, 
% defining state in relation to the pair only
for b = 1 : params.numBlocks

    % 1. select random number of pair reps for this block, in range from
    % 1/4 to 3/4 of pairs presented
    if ~params.noisePairs
        reps = params.maxPairReps;
    else % introduce noise pairs
        minReps = floor(params.maxPairReps * 0.80);
        plusReps = floor(params.maxPairReps * 0.10);
        reps = minReps + randi(plusReps);
    end

    % 2. select order, stim 1 first (1), or stim 2 first (2)
    if params.fixedOrder
        order = 1;
    else
        order = randi(2);
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
    conditions(b, 1).condNum = ((b-1) * 8) + 1;
    conditions(b, 1).state = 1; % A-state
    conditions(b, 1).choice.config = 1;
    conditions(b, 1).pair.id = '1_2'; % A1 state pair
    conditions(b, 1).pair.stim1 = blockStim(1); 
    conditions(b, 1).pair.stim2 = blockStim(2);
    conditions(b, 1).pair.reps = reps;
    conditions(b, 1).pair.order = order;
    conditions(b, 1).pair.soa = params.soa;
    conditions(b, 1).pair.interPair = params.interPair;
    
    % A-state, stimulus pair 1-2, choice configuration 2
    conditions(b, 2).blockNum = b;
    conditions(b, 2).condNum = ((b-1) * 8) + 2;
    conditions(b, 2).state = 1; % A-state
    conditions(b, 2).choice.config = 2;
    conditions(b, 2).pair.id = '1_2'; % A1 state pair
    conditions(b, 2).pair.stim1 = blockStim(1); 
    conditions(b, 2).pair.stim2 = blockStim(2);
    conditions(b, 2).pair.reps = reps;
    conditions(b, 2).pair.order = order;
    conditions(b, 2).pair.soa = params.soa;
    conditions(b, 2).pair.interPair = params.interPair;
    
    % A-state, stimulus pair 3-4, choice configuration 1
    conditions(b, 3).blockNum = b;
    conditions(b, 3).condNum = ((b-1) * 8) + 3;
    conditions(b, 3).state = 1; % A-state
    conditions(b, 3).choice.config = 1;
    conditions(b, 3).pair.id = '3_4'; % A2 state pair
    conditions(b, 3).pair.stim1 = blockStim(3);
    conditions(b, 3).pair.stim2 = blockStim(4);
    conditions(b, 3).pair.reps = reps;
    conditions(b, 3).pair.order = order;
    conditions(b, 3).pair.soa = params.soa;
    conditions(b, 3).pair.interPair = params.interPair;
    
    % A-state, stimulus pair 3-4, choice configuration 2
    conditions(b, 4).blockNum = b;
    conditions(b, 4).condNum = ((b-1) * 8) + 4;
    conditions(b, 4).state = 1; % A-state
    conditions(b, 4).choice.config = 2;
    conditions(b, 4).pair.id = '3_4'; % A2 state pair
    conditions(b, 4).pair.stim1 = blockStim(3);
    conditions(b, 4).pair.stim2 = blockStim(4);
    conditions(b, 4).pair.reps = reps;
    conditions(b, 4).pair.order = order;
    conditions(b, 4).pair.soa = params.soa;
    conditions(b, 4).pair.interPair = params.interPair;
    
    % B-state, stimulus pair 1-3, choice configuration 1
    conditions(b, 5).blockNum = b;
    conditions(b, 5).condNum = ((b-1) * 8) + 5;
    conditions(b, 5).state = 2; % B-state
    conditions(b, 5).choice.config = 1;
    conditions(b, 5).pair.id = '1_3'; % B1 state pair
    conditions(b, 5).pair.stim1 = blockStim(1);
    conditions(b, 5).pair.stim2 = blockStim(3);
    conditions(b, 5).pair.reps = reps;
    conditions(b, 5).pair.order = order;
    conditions(b, 5).pair.soa = params.soa;
    conditions(b, 5).pair.interPair = params.interPair;
    
    % B-state, stimulus pair 1-3, choice configuration 2
    conditions(b, 6).blockNum = b;
    conditions(b, 6).condNum = ((b-1) * 8) + 6;
    conditions(b, 6).state = 2; % B-state
    conditions(b, 6).choice.config = 2;
    conditions(b, 6).pair.id = '1_3'; % B1 state pair
    conditions(b, 6).pair.stim1 = blockStim(1);
    conditions(b, 6).pair.stim2 = blockStim(3);
    conditions(b, 6).pair.reps = reps;
    conditions(b, 6).pair.order = order;
    conditions(b, 6).pair.soa = params.soa;
    conditions(b, 6).pair.interPair = params.interPair;
    
    % B-state, stimulus pair 2-4, choice configuration 1
    conditions(b, 7).blockNum = b;
    conditions(b, 7).condNum = ((b-1) * 8) + 7;
    conditions(b, 7).state = 2; % B-state
    conditions(b, 7).choice.config = 1;
    conditions(b, 7).pair.id = '2_4'; % B2 state pair
    conditions(b, 7).pair.stim1 = blockStim(2);
    conditions(b, 7).pair.stim2 = blockStim(4);
    conditions(b, 7).pair.reps = reps;
    conditions(b, 7).pair.order = order;
    conditions(b, 7).pair.soa = params.soa;
    conditions(b, 7).pair.interPair = params.interPair;
    
    % B-state, stimulus pair 2-4, choice configuration 2
    conditions(b, 8).blockNum = b;
    conditions(b, 8).condNum = ((b-1) * 8) + 8;
    conditions(b, 8).state = 2; % B-state
    conditions(b, 8).choice.config = 2;
    conditions(b, 8).pair.id = '2_4'; % B2 state pair
    conditions(b, 8).pair.stim1 = blockStim(2);
    conditions(b, 8).pair.stim2 = blockStim(4);
    conditions(b, 8).pair.reps = reps;
    conditions(b, 8).pair.order = order;
    conditions(b, 8).pair.soa = params.soa;
    conditions(b, 8).pair.interPair = params.interPair;
    
end

% Convert contitions matrix into a one dimensional array
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

params.repsPerCond = 50;

for c = 1 : size(conditions, 1)
    trials(c).condReps = params.repsPerCond;
end

bob = 1;


end

