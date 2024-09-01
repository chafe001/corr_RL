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
params.randCuePercent = true;
params.numMovieTriplets = 20;  % groups of 3 frames to accomodate pairs with soa
params.movieStimReps = 10; % number of time each individual stimulus shown per movie


% --- VARIABLE NOISE
params.cuePercentRange = [0.2 0.4 0.6 0.8];
% --- NO NOISE
% params.cuePercentRange = [1 1 1 1];
params.cuePercent_easy = max(params.cuePercentRange);
params.cuePercent_hard = min(params.cuePercentRange);

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
