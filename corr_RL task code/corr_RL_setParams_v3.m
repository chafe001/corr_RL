function [params] = corr_RL_setParams_v3()

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

% --- BAR CONTROL
params.randCuePercent = true;
params.numMoviePairs = 10;
% easyStim forces each of the 4 stimuli selected each block to have a
% unique orientation. This reduces task to 1D feature discrimination on
% orientation, color is added just as distractor. xPairs logic still works,
% but multi-dimensional logic does not.
params.easyStim = true;
params.cuePercentRange = [0.6 0.7 0.8 0.9];
% params.cuePercentRange = [1 1 1 1];  % no noise
params.cuePercent_easy = max(params.cuePercentRange);
params.cuePercent_hard = min(params.cuePercentRange);
params.movieMode = 'stdp';

% --- CURVE CONTROL
% determine whether to use bars with xPairs algorithm or curves with Dave's
% curve generating code and Thomas' algorithm
% params.stimulusType = 'bars';
params.stimulusType = 'curves';
params.nCurvesPerMovie = 5;
% set which movie parameter is modified at block level
params.blockParam = 'curveMovieType';
% params.blockParam = 'curveMovieNoise';
% params.blockParam = 'curveMovieOrder';
% params.blockParam = 'curveMovieGeometry';

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
