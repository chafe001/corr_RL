function [params] = corr_RL_setParams_v2()

% --- STIMULUS FEATURE SPACE
% --- variable feature dimensions
params.Angles = [0 45 90 135];
% params.FaceColors = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
params.FaceColors = [0 0 0; 1 1 1];  % red, blue, black, white
% params.FaceColors = [0 0 0; 1 1 1];  % black, white
% --- fixed feature dimensions
params.Size = [1 4]; % [width height] in degrees
params.leftPos = [-4 0];
params.rightPos = [4 0];

% --- BLOCK STRUCTURE AND CONTROL
params.numBlocks = 10;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWinsMode';
% params.blockChange = 'condRepsMode';
params.netWin_criterion = 7;  % number of netWins before switching block

% --- MOVIE CONTROL
params.randCuePercent = false;
params.moviePairSlots = 10;  % Each pairSlot is a group of 3 frames to accomodate pairs with soa
params.movieStimReps = 5; % number of time each individual stimulus shown per movie

% --- NOISE CONTEONTL
% --- variable noise, optimal values vary with noiseMode, below
% params.cuePercentRange = [0 0.3 0.6 1];
% params.cuePercentRange = [0.2 0.4 0.6 0.8];
% params.cuePercentRange = [0.6 0.7 0.8 0.9];
params.cuePercentRange = [0.8 0.85 0.9 1];

% --- no noise
% params.cuePercentRange = [1 1 1 1];
params.cuePercent_easy = max(params.cuePercentRange);
params.cuePercent_hard = min(params.cuePercentRange);
% --- noise type
% singletonNoise: fixed reps left and right stimuli in each movie, vary the
% number of times the two stimuli are showed in a STDP left-right sequence,
% versus showing them as singletons.
% Challenge: working memory accumulates singleton stimuli into perceptual
% pairs, potentially weak noise manipulation

% params.noiseMode = 'singleton';`

% invertedNoise: noise pairs are spatially inverted cue pairs, so same two
% stimuli, but left/right screen positions swapped.  The key is that the
% inverted pairs are not related to state, they are equally mixed in each
% state 1 and 2 movie

params.noiseMode = 'invertedPairs';

% --- CHOICE/REWARD 
params.choice_x = 4;
params.choice_y = 0;
params.highRewProb = 1.0;
params.lowRewProb = 0;

% --- FEEDBACK
params.rewBox_width = 10; % degrees visual angle
params.rewBox_height = 1;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -10;
params.rewText_yPos = -20;

end
