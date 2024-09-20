function [params] = corr_RL_setParams_v4()

% VERSION HISTORY

% v1-v3: used through corr_RL v4
% v4: written to support corr_RL v5, switch to randomized list system for
% pair generation (rather than xPairs). Removing easyStim option

% --- STIMULUS FEATURE SPACE

% --- variable feature dimensions
params.Angles = [0 45 90 135];
% params.FaceColors = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
params.FaceColors = [0 0 0; 1 1 1];  

% --- fixed feature dimensions
params.Size = [1 4]; % [width height] in degrees
params.leftPos = [-4 0];
params.rightPos = [4 0];

% --- BLOCK STRUCTURE AND CONTROL
params.numBlocks = 10;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWinsMode';
% params.blockChange = 'condRepsMode';
params.netWin_criterion = 10;  % number of netWins before switching block
params.numStates = 2; % this overwritten by curveParams if curveMovie at present, but needed for bars

% --- BAR CONTROL
params.randCuePercent = true;
params.numMoviePairs = 10;
params.cuePercentRange = [0.6 0.7 0.8 0.9];
params.cuePercent_easy = min(params.cuePercentRange);
params.cuePercent_hard = max(params.cuePercentRange);
params.randCuePercent = true;
params.movieMode = 'stdp';
params.numCueStim = 4;  % new v5
params.numCueReps = 3;  % new v5
% adding new pairing algorithm
% params.pairMod = 'xPairs'; % new v5
params.pairMode = 'randList';  % new v5

% --- CURVE CONTROL
% determine whether to use bars with xPairs algorithm or curves with Dave's
% curve generating code and Thomas' algorithm
params.stimulusType = 'bars';
% params.stimulusType = 'curves';
params.nCurvesPerMovie = 8;

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
