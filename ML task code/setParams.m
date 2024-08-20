function [params] = setParams()

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

% --- set noise levels for movies
params.randNoiseLevel = false;
params.noiseLevels = [0.20 0.30 0.40 0.50];  % for pairMix
params.noiseLevel_easy = min(params.noiseLevels);
params.noiseLevel_hard = max(params.noiseLevels);
% --- set movie params
params.moviePairReps = 20;
% params.movieMode = 'simultaneous';
params.movieMode = 'stdp';
% --- set choice params
params.choice_x = 4;
params.choice_y = 0;
% --- control probabilistic reward
params.highRewProb = 0.8;
params.lowRewProb = 0.2;
% --- control subject feedback
params.printOutcome = false;
params.rewBox_width = 15; % degrees visual angle
params.rewBox_height = 3;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -15;
params.rewText_yPos = -20;

% --- SET STIM SPACE
% --- variable feature dimensions
params.Angles = [0 45 90 135];
params.FaceColors = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
% --- fixed feature dimensions
params.Size = [1 4]; % [width height] in degrees
params.leftPos = [-4 0];
params.rightPos = [4 0];






end
