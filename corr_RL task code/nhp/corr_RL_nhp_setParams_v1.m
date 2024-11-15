function [params] = corr_RL_nhp_setParams_v1()

% VERSION HISTORY

% v1: porting human v6 to NHP

% --- STIMULUS FEATURE SPACE

% --- variable feature dimensions
params.Angles = [0 45];
% params.Angles = [0 45 90 135];
% params.Angles = [0 30 60 90 120 150];
% params.FaceColors = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
% params.FaceColors = [0 0 0; 1 1 1];  
params.FaceColors = [0 0 0];  

% --- fixed feature dimensions
params.Size = [1 4]; % [width height] in degrees
params.leftPos = [-4 0];
params.rightPos = [4 0];

% --- BLOCK STRUCTURE AND CONTROL
params.numBlocks = 10;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWinsMode';
% params.blockChange = 'condRepsMode';
params.netWin_criterion = 25;  % number of netWins before switching block
% params.netWin_criterion = 5;  % number of netWins before switching block
params.numStates = 2; % this overwritten by curveParams if curveMovie at present, but needed for bars

% --- BAR CONTROL
params.randCuePercent = false;
params.numMoviePairs = 10;
% params.cuePercentRange = [0.3 0.5 0.7 0.9];
params.cuePercentRange = 1.0;
params.cuePercent_easy = max(params.cuePercentRange);
params.cuePercent_hard = min(params.cuePercentRange);
% params.movieMode = 'stdp';
params.movieMode = 'simPairs';  % simultaneous pairs
params.numCueStim = 2;  % new v5
params.numCueReps = 1;  % new v5
% adding new pairing algorithm
% params.pairMode = 'xPairs'; 
params.pairMode = 'randList';  % new v5
params.barNoiseMode = 'breakPairs';
% params.barNoiseMode = 'noisePairs';

% --- TRAINING FEATURES
% blockCond sets 1 condition per block, which would require a left or right
% response throughout the block.  This is intended to help associate
% changes in the visual display (movie) with changes in the response
% direction by blocking response direction.
params.blockCond = true;
params.constantPairs = true;
params.colorCue = true;

% --- CURVE CONTROL
% determine whether to use bars with xPairs algorithm or curves with Dave's
% curve generating code and Thomas' algorithm
params.stimulusType = 'bars';
% params.stimulusType = 'curves';
params.nCurvesPerMovie = 8;

% --- CHOICE/REWARD 
params.choice_x = 4;
params.choice_y = 0;
% params.highRewProb = 0.8;
% params.lowRewProb = 0.2;
params.highRewProb = 1;
params.lowRewProb = 0;

% --- JOYSTICK RESPONSE
% params.leftJoyRespWin = [-9.5, 0];
% params.rightJoyRespWin = [9.5, 0];

params.leftJoyRespWin = [-10, 0];
params.rightJoyRespWin = [10, 0];

% --- FIX WINDOW DIMENSIONS
% params.eye_radius = 10;
% params.joy_radius = 6;
params.eye_radius = 4;
params.joy_radius = 3;


% --- FEEDBACK
params.rewBox_width = 10; % degrees visual angle
params.rewBox_height = 1;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -10;
params.rewText_yPos = -20;

end
