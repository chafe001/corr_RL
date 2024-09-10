
function [condArray, condReps, params] = xPairs_buildTrials_mix_v1()

% This utility function builds the condition and condition rep arrays.
% These supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions to specify stimulus, choice, and reward
% information necessary to generate and run one trial of the task.

% --- VERSION HISTORY

% V1 Derived from buildTrials.  Mix variant combines all 4 stimulus pairs
% into each condition, presenting pairs correpsonding to reward state A and
% B in different proportions.  This is analogous to motion coherence,
% intended to provide ability to obtain psychometric functions, thresholds
% to see shifts in thresholds according to associative and reward history.
% Also minimizes the explicit 2 pairs mapping to 1 reward state feature, or
% lookup table attributes of initial design

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
% --- params that control task block structure and control
params.numBlocks = 4;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWins';
% params.blockChange = 'condReps';
params.netWin_criterion = 3;  % number of netWins before switching block

% --- params that control position of stimuli
% NOTE: visual angles for a 24" Dell 2414 monitor viewed at 24" (~60 cm)
% +/- 23 degrees horizontal (edge to edge)
% +/- 14 degreees vertical
% params.arrayRadius = 7 works on standard 24" display
params.arrayRadius = 7;
params.stimArraySize = 8;
% --- params that control stimulus movies
% rewState1_props specifies proportion of pairs that instruct reward state 1 in
% each movie
% params.rewState1Proportions = [0.2 0.3 0.4 0.5 0.6 0.7 0.8]; 
% params.rewState1Proportions = [.2 .8]; 
params.rewState1Proportions = [0 1]; 
params.moviePairReps = 100;
% --- params that control addition of noise pairs to movies
% will vary noise at the block level first to see if there are learning
% effects
params.addNoise = false;
params.noiseProp = 0.1;  % fixed for now, may vary in blocks or at the trial level
% --- params that control how movies are structured
% params.movieMode = 'simultaneous';
params.movieMode = 'stdp';
% --- params that control choices
params.choice_x = 4;
params.choice_y = 0;
% --- params that control probabilistic reward
params.highRewProb = 1.0;
params.lowRewProb = 0;
% --- params that control stimulus timing
params.preMovieDur = 60;  % 60 frames is 0.5 seconds at 120 Hz
params.postMovieDur = 6000;
params.stimDur = 1;
params.soa = 2;
params.interPair = 5;
% --- params that control subject feedback
params.printOutcome = true;
params.rewBox_width = 15; % degrees visual angle
params.rewBox_maxWins = 8;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -15;
params.rewText_yPos = -20;

% --- DEFINE AND INITIALIZE STIM STRUCT
stim.x = NaN;
stim.y = NaN;

% --- COMPUTE STIMULUS X,Y LOCATIONS
stimPos = repmat(stim, 1, params.stimArraySize);
for s = 1 : params.stimArraySize
    [stimPos(s).x, stimPos(s).y] = xPairs_findStimXY(params, s);
end

% --- DEFINE AND INITIALIZE CONDITION STRUCT
% cond.stim1 = stim;
% cond.stim2 = stim;
% cond.rewState = NaN;
% cond.choiceConfig = NaN;
% cond.soa = params.soa; % screen refresh units
% cond.movieMode = params.movieMode;

% --- SELECT RANDOM xPairs WITHIN EACH BLOCK
for b = 1 : params.numBlocks

    % Select 4 stimulus locations from stimArray at random and organize
    % them into xPairs by pairing random indices within stimArray. V2
    % builds stim pairs from 4 randomly selected stimuli (in array of 8)
    % and noise pairs from remaining 4 stimuli (so no stimulus overlap
    % between stim and noise pairs).
    [stimPairs, noisePairs, ind] = xPairs_buildStimPairs_v3(params);

    for c = 1 : 2 % num choices

        for m = 1 : size(params.rewState1Proportions, 2)  % levels of proportional mixing of stimulus pairs instructing different reward states

            % --- save blockNum
            condArrayTemp(b, c, m).blockNum = b;

            % --- save stim and noise array indices randomly selected for this block
            condArrayTemp(b, c, m).stimIndx = ind.stimIndx;
            condArrayTemp(b, c, m).noiseIndx = ind.noiseIndx;

            % --- set stimulus pair indices, xy positions
            for n = 1 : size(stimPairs, 2)
                condArrayTemp(b, c, m).stimPairs(n).stim1 = stimPos(stimPairs(n).stim1_indx); % sets stim1.x and stim1.y
                condArrayTemp(b, c, m).stimPairs(n).stim1_fn = 'filledCircle.png';
                condArrayTemp(b, c, m).stimPairs(n).stim2 = stimPos(stimPairs(n).stim2_indx); % sets stim2.x and stim2.y
                condArrayTemp(b, c, m).stimPairs(n).stim2_fn = 'filledCircle.png';
                condArrayTemp(b, c, m).stimPairs(n).stimPairID = stimPairs(n).pairID;
                condArrayTemp(b, c, m).stimPairs(n).stimPairRewState = stimPairs(n).rewState;
            end

            % --- set noise pair indices, xy positions
            for n = 1 : size(noisePairs, 2)
                condArrayTemp(b, c, m).noisePairs(n).noise1 = stimPos(noisePairs(n).noise1_indx); % sets noise1.x and noise1.y
                condArrayTemp(b, c, m).noisePairs(n).noise1_fn = 'filledCircle.png';
                condArrayTemp(b, c, m).noisePairs(n).noise2 = stimPos(noisePairs(n).noise2_indx); % sets noise2.x and noise2.y
                condArrayTemp(b, c, m).noisePairs(n).noise2_fn = 'filledCircle.png';
                condArrayTemp(b, c, m).noisePairs(n).noisePairID = noisePairs(n).pairID;
                condArrayTemp(b, c, m).noisePairs(n).noisePairRewState = noisePairs(n).rewState;
            end

            % --- set proportion of stimulus pairs in movie that instruct
            % reward state 1 (remainder instruct reward state 2).  Reward
            % state is controlled by this proportion
            condArrayTemp(b, c, m).rewState1prop = params.rewState1Proportions(m);

            % --- set reward condition and reward probabilities according
            % to proportion of stimulus pairs shown in movie that instruct 
            % reward state 1 versus 2.  rewState -1 indicates chance (0.5)
            % reward probability on the two choices
            if condArrayTemp(b, c, m).rewState1prop > 0.5
                condArrayTemp(b, c, m).rewState = 1;
                condArrayTemp(b, c, m).choice1_rewProb = params.highRewProb;
                condArrayTemp(b, c, m).choice2_rewProb = params.lowRewProb;
            elseif condArrayTemp(b, c, m).rewState1prop == 0.5
                condArrayTemp(b, c, m).rewState = -1;
                condArrayTemp(b, c, m).choice1_rewProb = 0.5;
                condArrayTemp(b, c, m).choice2_rewProb = 0.5;
            elseif condArrayTemp(b, c, m).rewState1prop < 0.5
                condArrayTemp(b, c, m).rewState = 2;
                condArrayTemp(b, c, m).choice1_rewProb = params.lowRewProb;
                condArrayTemp(b, c, m).choice2_rewProb = params.highRewProb;
            end
            
            % --- set choice configuration for this condition
            condArrayTemp(b, c, m).choiceConfig = c;
            switch c
                case 1  % set choice configuration 1, green right, red left
                    % set choice 1
                    condArrayTemp(b, c, m).choice1_fn = 'greenChoice.png';
                    condArrayTemp(b, c, m).choice1_x = params.choice_x;
                    condArrayTemp(b, c, m).choice1_y = params.choice_y;
                    condArrayTemp(b, c, m).choice1_side = 'right';
                    % set choice 2
                    condArrayTemp(b, c, m).choice2_fn = 'redChoice.png';
                    condArrayTemp(b, c, m).choice2_x = -params.choice_x;
                    condArrayTemp(b, c, m).choice2_y = params.choice_y;
                    condArrayTemp(b, c, m).choice2_side = 'left';
                case 2 % set choice configuration 2, green left, red right
                    % set choice 1
                    condArrayTemp(b, c, m).choice1_fn = 'greenChoice.png';
                    condArrayTemp(b, c, m).choice1_x = -params.choice_x;
                    condArrayTemp(b, c, m).choice1_y = params.choice_y;
                    condArrayTemp(b, c, m).choice1_side = 'left';
                    % set choice 2
                    condArrayTemp(b, c, m).choice2_fn = 'redChoice.png';
                    condArrayTemp(b, c, m).choice2_x = params.choice_x;
                    condArrayTemp(b, c, m).choice2_y = params.choice_y;
                    condArrayTemp(b, c, m).choice2_side = 'right';
            end

        end % next l

    end  % next c

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

% Convert conditions matrix into a one dimensional struct array
condArray = [];
for b = 1 : params.numBlocks
    for c = 1:2
        for m = 1: size(params.rewState1Proportions, 2)
            thisCond = condArrayTemp(b, c, m);
            condArray = [condArray; thisCond];
        end
    end
end

bob = 1;


%% -------- BUILD TRIAL STACK --------
% Create a one-dimensional array of rep counters, one for each condition.
% This will work because each block has a unique set of conditions, so the
% block can be indexed by the condition number

for c = 1 : size(condArray, 1)
    condReps(c) = params.repsPerCond;
end

bob = 1;

end

