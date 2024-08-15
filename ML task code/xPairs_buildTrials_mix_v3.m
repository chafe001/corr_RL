
function [condArray, condReps, params] = xPairs_buildTrials_mix_v3()

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

% v2 Adding ability to set variable associative strength of movies at the
% block level. Retaining ability to vary associative strength at the trial
% level by disabling params.
%
% This could be addinging noise, or modifying proportion of
% stim pairs associated with reward states A and B in each movie.

% v3 Adding ability switch between varying associative strength by adding
% either noise pairs or modifying proportion of informative pairs for the
% two reward states.  Also adding ability to vary reward magnitude by
% modifying the magnitude of the size change in the netWins reward bar for
% each hit and loss

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
% - Order of presentation in each paircorrStrength_byBlock
% - Time between stimulus onset in each pair (SOA)

% -------- SET PARAMS
% --- params that control task block structure and control
params.numBlocks = 10;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWinsMode';
% params.blockChange = 'condRepsMode';
params.netWin_criterion = 10;  % number of netWins before switching block

% --- params that control position of stimuli
% NOTE: visual angles for a 24" Dell 2414 monitor viewed at 24" (~60 cm)
% +/- 23 degrees horizontal (edge to edge)
% +/- 14 degreees vertical
% params.arrayRadius = 7 works on standard 24" display
params.arrayRadius = 7;
params.stimArraySize = 8;
params.fixedStimLoc = false;

% --- vary correlation strength of stim movie
params.corrStrength_byBlock = false; % if false, varies by trial
%  corrStrength_mode controls how the associative strength of stim movies
% is controlled. In 'pairMix' mode, each movie has different proportions falsePairRatios
% of the alternative pairs associated with the two reward states, for
% example 80% A state and 20% B state.  The dots are restricted to the 4
% dots selected for that block as being informative with respect to reward
% state. In 'noiseMix' mode, movies contain varying proportions of
% informative stim pairs from a single reward state, and noise pairs not
% associated with any reward state. Noise pairs are made from remaining
% dots other than those selected for each block as informing reward state.

% params.corrStrength_mode = 'pairMix'; 
params.corrStrength_mode = 'noiseMix';

% falsePairRatios controls how many pairs to include in each movie that
% are 'incorrect', in the sense they do not instruct the reward state
% associated with the predominant pairs in each movie.  Incorrect pairs can
% be either noise pairs, or pairs instructing the alternative reward state.
% NOTE!!: falsePairRatios must be less than 0.5 or it will incorrectly
% invert the relationship between pair geometry and reward state
% 2nd NOTE!! The number of levels of falsePairRatios influence how the loops
% below run which influences the total number of conditions, which requires
% re-writing the conditions .txt file.  This keeps the mapping between
% condition numbers and blocks correct, which is critical for balancing
% reward states and everything else within the blocks.  So make sure to
% check the condition mapping in the cue using the current conditions file
% to make sure the right conditions are getting mapped to the right blocks.
% KEEP falsePairRatios at 4 LEVELS FOR NOW, if this changes, need to edit
% conditions file.
% params.falsePairRatios = [0.05 0.10 0.15 0.20];  % for noiseMix
params.falsePairRatios = [0.30 0.40 0.50 0.60];  % for pairMix
params.falsePairRatio_easyBlock = 0;
params.falsePairRatio_hardBlock = 0.4;
% --- control stimulus timing
params.moviePairReps = 100;
% params.movieMode = 'simultaneous';
params.movieMode = 'stdp';
% --- control choices
params.choice_x = 4;
params.choice_y = 0;
% --- control probabilistic reward
params.highRewProb = 0.8;
params.lowRewProb = 0.2;
% params.highRewProb = 1;
% params.lowRewProb = 0;
% --- control subject feedback
params.printOutcome = false;
params.rewBox_width = 15; % degrees visual angle
params.rewBox_height = 3;
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

% --- LOOP THROUGH VARIABLES DEFINING TRIAL CONDITIONS
for b = 1 : params.numBlocks

    % Build 4 stim pairs from 4 randomly selected stimuli (in array of 8)
    % and 4 noise pairs from remaining 4 stimuli (so no stimulus overlap
    % between stim and noise pairs).
    [stimPairs, noisePairs, ind] = xPairs_buildStimPairs_v4(params);

    % SET VECTOR OF CORRELATION STRENGTHS TO LOOP THROUGH
    if params.corrStrength_byBlock % set correlatoin level at block level
        if mod(b, 2) ~= 0 % odd block number
            falsePairProportions = params.falsePairRatio_easyBlock;
        else  % even block number
            falsePairProportions = params.falsePairRatio_hardBlock;
        end
    else
        falsePairProportions = params.falsePairRatios;  % set correlation level at trial level
    end
    
    for r = 1 : 2 % reward state, whether green or red will be high reward prob
        
        for c = 1 : 2 % choice configurations, green:L / red:R and reverse

            for m = 1 : size(falsePairProportions, 2)  % levels of proportional mixing of stimulus pairs instructing different reward states

                % --- save blockNum
                condArrayTemp(b, r, c, m).blockNum = b;

                % --- save rewState
                condArrayTemp(b, r, c, m).rewState = r;

                % --- save stim and noise array indices randomly selected for this block
                condArrayTemp(b, r, c, m).stimIndx = ind.stimIndx;
                condArrayTemp(b, r, c, m).noiseIndx = ind.noiseIndx;

                % --- set stimulus pair indices, xy positions
                for n = 1 : size(stimPairs, 2)
                    condArrayTemp(b, r, c, m).stimPairs(n).stim1 = stimPos(stimPairs(n).stim1_indx); % sets stim1.x and stim1.y
                    condArrayTemp(b, r, c, m).stimPairs(n).stim1_fn = 'filledCircle.png';
                    condArrayTemp(b, r, c, m).stimPairs(n).stim2 = stimPos(stimPairs(n).stim2_indx); % sets stim2.x and stim2.y
                    condArrayTemp(b, r, c, m).stimPairs(n).stim2_fn = 'filledCircle.png';
                    condArrayTemp(b, r, c, m).stimPairs(n).stimPairID = stimPairs(n).pairID;
                end

                % --- set noise pair indices, xy positions
                for n = 1 : size(noisePairs, 2)
                    condArrayTemp(b, r, c, m).noisePairs(n).noise1 = stimPos(noisePairs(n).noise1_indx); % sets noise1.x and noise1.y
                    condArrayTemp(b, r, c, m).noisePairs(n).noise1_fn = 'filledCircle.png';
                    condArrayTemp(b, r, c, m).noisePairs(n).noise2 = stimPos(noisePairs(n).noise2_indx); % sets noise2.x and noise2.y
                    condArrayTemp(b, r, c, m).noisePairs(n).noise2_fn = 'filledCircle.png';
                    condArrayTemp(b, r, c, m).noisePairs(n).noisePairID = noisePairs(n).pairID;
                end

                % --- set correlation strength according to corrStrength_mode
                condArrayTemp(b, r, c, m).falsePairProportion = falsePairProportions(m);

                % --- set reward probabilities based on rewState
                if condArrayTemp(b, r, c, m).rewState == 1
                    condArrayTemp(b, r, c, m).choice1_rewProb = params.highRewProb;
                    condArrayTemp(b, r, c, m).choice2_rewProb = params.lowRewProb;
                elseif condArrayTemp(b, r, c, m).rewState == 2
                    condArrayTemp(b, r, c, m).choice1_rewProb = params.lowRewProb;
                    condArrayTemp(b, r, c, m).choice2_rewProb = params.highRewProb;
                end

                % --- set choice configuration for this condition
                condArrayTemp(b, r, c, m).choiceConfig = c;
                switch c
                    case 1  % set choice configuration 1, green right, red left
                        % set choice 1
                        condArrayTemp(b, r, c, m).choice1_fn = 'greenChoice.png';
                        condArrayTemp(b, r, c, m).choice1_x = params.choice_x;
                        condArrayTemp(b, r, c, m).choice1_y = params.choice_y;
                        condArrayTemp(b, r, c, m).choice1_side = 'right';
                        % set choice 2
                        condArrayTemp(b, r, c, m).choice2_fn = 'redChoice.png';
                        condArrayTemp(b, r, c, m).choice2_x = -params.choice_x;
                        condArrayTemp(b, r, c, m).choice2_y = params.choice_y;
                        condArrayTemp(b, r, c, m).choice2_side = 'left';
                    case 2 % set choice configuration 2, green left, red right
                        % set choice 1
                        condArrayTemp(b, r, c, m).choice1_fn = 'greenChoice.png';
                        condArrayTemp(b, r, c, m).choice1_x = -params.choice_x;
                        condArrayTemp(b, r, c, m).choice1_y = params.choice_y;
                        condArrayTemp(b, r, c, m).choice1_side = 'left';
                        % set choice 2
                        condArrayTemp(b, r, c, m).choice2_fn = 'redChoice.png';
                        condArrayTemp(b, r, c, m).choice2_x = params.choice_x;
                        condArrayTemp(b, r, c, m).choice2_y = params.choice_y;
                        condArrayTemp(b, r, c, m).choice2_side = 'right';
                end

            end % next l

        end  % next c

    end  % next r

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
    for r = 1:2
        for c = 1:2
            for m = 1: size(falsePairProportions, 2)
                thisCond = condArrayTemp(b, r, c, m);
                condArray = [condArray; thisCond];
            end
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

