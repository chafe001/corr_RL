
function [conditions, trials, params] = buildExp()

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


%% -------- Set Conditions --------------

% --- Stimulus position array in degrees
% near positions
stimPos(1).posXY = [6 0];
stimPos(1).posLabel = 'R_near';
stimPos(2).posXY = [4 4];
stimPos(2).posLabel = 'UR_near';
stimPos(3).posXY = [-4 4];
stimPos(3).posLabel = 'UL_near';
stimPos(4).posXY = [-6 0];
stimPos(4).posLabel = 'L_near';
stimPos(5).posXY = [-4 -4];
stimPos(5).posLabel = 'LL_near';
stimPos(6).posXY = [4 -4];
stimPos(6).posLabel = 'LR_near';
% far positions
stimPos(7).posXY = [12 0];
stimPos(7).posLabel = 'R_far';
stimPos(8).posXY = [8 8];
stimPos(8).posLabel = 'UR_far';
stimPos(9).posXY = [-4 4];
stimPos(9).posLabel = 'UL_far';
stimPos(10).posXY = [-6 0];
stimPos(10).posLabel = 'L_far';
stimPos(11).posXY = [-4 -4];
stimPos(11).posLabel = 'LL_far';
stimPos(12).posXY = [4 -4];
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
params.maxPairReps = 10;

% Each block is a set of 4 conditions crossing 4 stimuli into 4 pairs to
% dissociate state and individual stimuli, defining state in relation to
% the pair only
for b = 1 : params.numBlocks

    % 1. select random number of pair reps for this block
    reps = randi(params.maxPairReps);

    % 2. select fixed (1) or random (2) stimulus order in each pair
    order = randi(2);

    % 3. select stimulus onset asynchrony (soa, 5 increments, in ms)
    soa = randi(5) * 10;
    
    % 2. Select 4 random indices into image and position arrays
    % Use randperm to ensure 4 unique locations are chosen, guaranteeing 4
    % unique stimuli
    posIndx = randperm(size(stimPos, 2), 4);
    imgIndx = randi(size(stimImage, 2), [1 4]);

    % 3. Use indices to define stimulus images and positions for blockStim
    for i = 1 : 4
        blockStim(i).img = stimImage(imgIndx(i));
        blockStim(i).pos = stimPos(posIndx(i));
    end

    % 4. Cross individual stimuli into pairs associated with states A and
    % B. Individual stimuli must be associated with A-state and B-state
    % with equal probability. State must be defined only by how stimuli are
    % paired, requiring association.

    % A-state, stimulus pair 1-2
    conditions(b, 1).state = 1; % A-state
    conditions(b, 1).pair.id = '1_2'; % A1 state pair
    conditions(b, 1).pair.stim1 = blockStim(1); 
    conditions(b, 1).pair.stim2 = blockStim(2);
    conditions(b, 1).pair.reps = reps;
    conditions(b, 1).pair.order = order;
    conditions(b, 1).pair.soa = soa;

    % A-state, stimulus pair 3-4
    conditions(b, 2).state = 1; % A-state
    conditions(b, 2).pair.id = '3_4'; % A2 state pair
    conditions(b, 2).pair.stim1 = blockStim(3); 
    conditions(b, 2).pair.stim2 = blockStim(4);
    conditions(b, 2).pair.reps = reps;
    conditions(b, 2).pair.order = order;
    conditions(b, 2).pair.soa = soa;

    % B-state, stimulus pair 1-3
    conditions(b, 3).state = 2; % B-state
    conditions(b, 3).pair.id = '1_3'; % B1 state pair
    conditions(b, 3).pair.stim1 = blockStim(1);
    conditions(b, 3).pair.stim2 = blockStim(3);
    conditions(b, 3).pair.reps = reps;
    conditions(b, 3).pair.order = order;
    conditions(b, 3).pair.soa = soa;

    % B-state, stimulus pair 2-4
    conditions(b, 4).state = 2; % B-state
    conditions(b, 4).pair.id = '2_4'; % B2 state pair
    conditions(b, 4).pair.stim1 = blockStim(2);
    conditions(b, 4).pair.stim2 = blockStim(4);
    conditions(b, 4).pair.reps = reps;
    conditions(b, 4).pair.order = order;
    conditions(b, 4).pair.soa = soa;

end

% reshape conditions so it is a one dimensional array and
% index = condition number
conditions = reshape(conditions,prod(size(conditions)), 1);


%% -------- Set trials --------

trials =[];

% trials is a vector of integers corresponding to the condition numbers we
% want to present for the number of trials we wish to present. 
params.trialsPerCond = 50;
for c = 1 : size(conditions, 1)
    theseTrials = zeros(params.trialsPerCond, 1) + c;
    trials = [trials; theseTrials];
end

bob = 1;

end

