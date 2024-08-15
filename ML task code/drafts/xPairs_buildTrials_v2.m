
function [condArray, condReps, params] = xPairs_buildTrials_v2()

% This utility function builds the condition and condition rep arrays.
% These supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions to specify stimulus, choice, and reward
% information necessary to generate and run one trial of the task.

% --- VERSION HISTORY

% V1 first effort. Establishes a stimulus array, selects four indices at
% random to pick 4 stimuli, establishes cross-pairs using these 4 stimuli.

% V2 adding noise pairs.  These are pairs constructed from noise stimuli,
% which are the remaining stimuli not used in xPairs.  Intent is to
% introduce variable number of noise pairs in movies, but without any
% correlation to rew state. This degrades visual information instructing
% rew state.

% --- XPAIRS TASK DESIGN

% In xPairs, each trial a pair of stimuli is shown that instructs which of
% two choice targets will yield reward with high probability (80%) and
% which with low probability (20%).  Monkeys learn the pair-to-reward
% mapping over trials by trial and error.  The key of the xPairs design is
% that 4 stimuli are crossed such that each individual stimulus is
% associated with the two reward conditions with equal probability.

% Given 4 randomly selected stimuli (at the start of each block), stimuli
% are crossed as follows:

% Pair 1: Reward state A, stim1-stim2
% Pair 2: Reward state A, stim3-stim4
% Pair 3: Reward state B, stim1-stim3
% Pair 4: Reward state B, stim2-stim4

% In this design, each stimulus (1-4) is equally associated with reward
% state A and B.  Therefore information about reward state is conveyed only
% by the learned associations between stimuli, and not by individual
% stimuli themselves (although have to guard against suboptimal strategies
% and biases based on individual stimuli).

% Subjects will learn new sets of xPairs in blocks.  Each block, trials are
% selected among 4 condition numbers corresponding to the 4 stimulus
% pairings randomly selected for that block.  Additional condition numbers
% in each block may be added later if noise pairs (not included in the
% xPairs for the block) are desired.

% INFORMATION NEEDED AT EACH ELEMENT IN THE CONDITIONS ARRAY
% - Stimuli 1-4, images and locations, randomly selected from fixed array
% - Crossed pairs that correspond to reward states A and B
% - Locations of choice targets (red and green, left and right)
% - Order of presentation in each pair
% - Time between stimulus onset in each pair (SOA)

% -------- SET PARAMS
% Assign random stimulus sequences to condition numbers within blocks
params.arrayRadius = 7;
params.stimArraySize = 8;
params.pairsPerBlock = 4;
params.numBlocks = 4;
params.lowProb = 0.2;
params.highProb = 0.8;
params.choice1_x = -4;
params.choice1_y = 0;
params.choice2_x = 4;
params.choice2_y = 0;
params.numChoices = 2;
params.numRewStates = 2;
% stimulus timing
params.preMovieDur = 60;  % 60 frames is 0.5 seconds at 120 Hz
params.postMovieDur = 6000;
params.stimDur = 1;
params.soa = 12;
params.stimOrder = 1; % 1 = stim1-stim2, 2 = stim2-stim1
% movieModes
% params.movieMode = 'simultaneous';
% params.movieMode = 'simultaneous_repeat';
% params.movieMode = 'simultaneous_noise';
% params.movieMode = 'stdp';
% params.movieMode = 'stdp_repeat';
params.movieMode = 'stdp_noise';
params.movieNoisePairs = false;
params.moviePairReps = 50;  % number of pairs per movie if enabled 
params.movieNoiseLevel = 0.5; % proportion of pairs that are noise in sequence

% NOTE: visual angles for a 24" Dell 2414 monitor viewed at 24" (~60 cm)
% +/- 23 degrees horizontal (edge to edge)
% +/- 14 degreees vertical
% params.arrayRadius = 7 works on standard 24" display

% --- DEFINE AND INITIALIZE STIM STRUCT
stim.x = NaN;
stim.y = NaN;

% --- COMPUTE STIMULUS X,Y LOCATIONS
stimPos = repmat(stim, 1, params.stimArraySize);
for s = 1 : params.stimArraySize
    [stimPos(s).x, stimPos(s).y] = xPairs_findStimXY(params, s);
end

% --- DEFINE AND INITIALIZE CHOICE STRUCT
choice.x = NaN;
choice.y = NaN;

% --- COMPUTE CHOICE X,Y LOCATIONS 
choicePos = repmat(choice, 1, params.numChoices);
for c = 1 : params.numChoices
    [choicePos(c).x, choicePos(c).y] = xPairs_findChoiceXY(params, c);
end

% --- DEFINE AND INITIALIZE CONDITION STRUCT
cond.stim1 = stim;
cond.stim2 = stim;
cond.choice1 = choice;
cond.choice2 = choice;
cond.rewState = NaN;
cond.choiceConfig = 1;
cond.soa = 2; % screen refresh units
cond.stimOrder = 1;
cond.movieMode = params.movieMode;

% --- movieMode options:
% 'simultaneous'
% 'simultaneous_repeat'
% 'simultaneous_noise'
% 'stdp'
% 'stdp_repeat'
% 'stdp_noise'

% --- CREATE 2D CONDITIONS ARRAY
% each condition is defined by a stimulus pair and a choice configuration
% each block is defined by a set of 4 stimulus pairs (xPairs)
% dimensions of condArray are consequently (numBlocks, pairsPerBLock)
condArrayTemp = repmat(cond, [params.numBlocks params.pairsPerBlock]);

% --- SELECT RANDOM xPairs WITHIN EACH BLOCK
for b = 1 : params.numBlocks

    % Select 4 stimulus locations from stimArray at random and organize
    % them into xPairs by pairing random indices within stimArray
    [stimPairs, noisePairs] = xPairs_buildStimPairs_v2(params);

    for c = 1:2 % choice config, randomize choice image location to implement
        % object bandit (rather than spatial bandit)
        % choice config 1 =  choice1:left, choice2:right
        % choice config 2 =  choice2:left, choice1:right
        for p = 1 : params.pairsPerBlock
            condArrayTemp(b, c, p).blockNum = b;
            condArrayTemp(b, c, p).pairNum = p;
            % --- set informative stimulus pairs
            condArrayTemp(b, c, p).stim1 = stimPos(stimPairs(p).stim1_indx); % sets stim1.x and stim1.y
            condArrayTemp(b, c, p).stim1_fn = 'filledCircle.png';
            condArrayTemp(b, c, p).stim2 = stimPos(stimPairs(p).stim2_indx); % sets stim2.x and stim2.y
            condArrayTemp(b, c, p).stim2_fn = 'filledCircle.png';
            condArrayTemp(b, c, p).pairID = stimPairs(p).pairID;
            condArrayTemp(b, c, p).rewState = stimPairs(p).rewState;
            % --- stimulus pair timing parameters
            condArrayTemp(b, c, p).preMovieDur = params.preMovieDur;
            condArrayTemp(b, c, p).postMovieDur = params.postMovieDur;
            condArrayTemp(b, c, p).stimDur = params.stimDur;
            condArrayTemp(b, c, p).soa = params.soa;
            condArrayTemp(b, c, p).stimOrder = params.stimOrder;  % 1 = stim1-stim2, 2 = stim2-stim1
            condArrayTemp(b, c, p).movieMode = params.movieMode;
            % --- insert array of all noise pairs. If noise enabled, will
            % select randomly from noise pair array when generating movie.
            for n = 1 : size(noisePairs, 2)
                condArrayTemp(b, c, p).noisePairs(n).noise1 = stimPos(noisePairs(n).noise1_indx); % sets noise1.x and noise1.y
                condArrayTemp(b, c, p).noisePairs(n).noise1_fn = 'filledCircle.png';
                condArrayTemp(b, c, p).noisePairs(n).noise2 = stimPos(noisePairs(n).noise2_indx); % sets noise2.x and noise2.y
                condArrayTemp(b, c, p).noisePairs(n).noise2_fn = 'filledCircle.png';
            end
            % --- choice parameters
            condArrayTemp(b, c, p).choiceConfig = c;
            % buildChoices assigns reward probabilities to choice stimuli and choice stimuli to locations.  
            % This depends on both stimPair.rewState and choice configuration (c)
            choices = xPairs_buildChoices(params, c, stimPairs(p).rewState);
            % set choice1 (green)
            condArrayTemp(b, c, p).choice1.x = choicePos(choices(1).posIndx).x;
            condArrayTemp(b, c, p).choice1.y = choicePos(choices(1).posIndx).y;
            if condArrayTemp(b, c, p).choice1.x < 0
                condArrayTemp(b, c, p).choice1.side = 'left';
            elseif condArrayTemp(b, c, p).choice1.x > 0
                condArrayTemp(b, c, p).choice1.side = 'right';
            elseif condArrayTemp(b, c, p).choice1.x == 0
                condArrayTemp(b, c, p).choice1.side = 'center';
            end      
            condArrayTemp(b, c, p).choice1.fileName = choices(1).fileName;
            condArrayTemp(b, c, p).choice1.rewProb = choices(1).rewProb;
            % set choice2 (red)
            condArrayTemp(b, c, p).choice2.x = choicePos(choices(2).posIndx).x;
            condArrayTemp(b, c, p).choice2.y = choicePos(choices(2).posIndx).y;
            if condArrayTemp(b, c, p).choice2.x < 0
                condArrayTemp(b, c, p).choice2.side = 'left';
            elseif condArrayTemp(b, c, p).choice2.x > 0
                condArrayTemp(b, c, p).choice2.side = 'right';
            elseif condArrayTemp(b, c, p).choice2.x == 0
                condArrayTemp(b, c, p).choice2.side = 'center';
            end
            condArrayTemp(b, c, p).choice2.fileName = choices(2).fileName;
            condArrayTemp(b, c, p).choice2.rewProb = choices(2).rewProb;
        end  % next p
    end % next c
end  % next b

% Dell Inspiron laptop default refresh rate is 120 Hz, 8.33 ms per refresh.

%  NOTES ON STIMULUS TIMING FOR LEARNING EFFECTS
% McMahon and Leopold (2010) tested effect of stimulus timing and order on
% plasticity of face perception. Two faces, variable morph levels between
% them, task to identify morphs as face A or B. Obtain psychophysical
% thresolds before and after image pairing.  Image pairing paradigm:
% - each trial, an image pair was presented (face or nonface) at fovea
% - 120 trials, 100 face pairs, 20 nonface pairs
% - each image in pair visible for 1 screen refresh (10 ms at 100 Hz)
% - SOA 10-100 ms
% - After 1 pair, press button if face, withhold if nonface (attention)
% - Interpair interval 800-1200 ms (ITI)
% - Trial length, fix (500 ms), pair (max 120 ms), 1200 ms ITI = ~ 2 s
% - Plasticity effect peaked at SOA = 20 ms, 100 pairs sufficient
% - xPairs prototype (based on above):
% - Single target pair flashed
% - Choice target array
% - Response
% - Don't vary repetition number, vary order and SOA.

% Convert contitions matrix into a one dimensional struct array
condArray = [];
for b = 1 : params.numBlocks
    for c = 1:2
        for p = 1: params.pairsPerBlock
            thisCond = condArrayTemp(b, c, p);
            condArray = [condArray; thisCond];
        end
    end
end

bob = 1;


%% -------- BUILD TRIAL STACK --------
% Create a one-dimensional array of rep counters, one for each condition.
% This will work because each block has a unique set of conditions, so the
% block can be indexed by the condition number

params.repsPerCond = 5;

for c = 1 : size(condArray, 1)
    condReps(c) = params.repsPerCond;
end

bob = 1;

end

