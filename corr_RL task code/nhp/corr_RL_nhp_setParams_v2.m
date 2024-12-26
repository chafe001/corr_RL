function [params] = corr_RL_nhp_setParams_v2()

% VERSION HISTORY

% v1: porting human v6 to NHP
% v2: modifying pairMode to include training stages

% --- BLOCK STRUCTURE AND CONTROL
params.numBlocks = 10;  % WARNING: THIS NEEDS TO MATCH NUMBER OF BLOCKS IN CONDITIONS FILE not sure what will happen if it doesn't
params.repsPerCond = 4;
params.blockChange = 'netWinsMode';
% params.blockChange = 'condRepsMode';
% params.netWin_criterion = 15;  % number of netWins before switching block
params.netWin_criterion = 3;  % number of netWins before switching block
params.numStates = 2; % this overwritten by curveParams if curveMovie at present, but needed for bars

% --- INDIVIDUAL STIMULUS CONTROL

% --- bar stim angle range
% params.Angles = [0 90];
params.Angles = [0 45 90 135];  
% params.Angles = [0 30 60 90 120 150];

% --- bar stim color range
% params.FaceColors = [0 0 0; 1 1 1];   % black, white
params.FaceColors = [1 1 1];  

% --- number of bar stim specified
params.numAngles = size(params.Angles, 2);
params.numColors = size(params.FaceColors, 1);
params.numCueStim = params.numAngles * params.numColors;  

% --- number of times to show each pair in each movie
params.numCueReps = 1;  

% --- set bar locations on screen
% params.leftPos = [-1.5 3];
% params.rightPos = [1.5 3];
params.leftPos = [-1.5 2.75];
params.rightPos = [1.5 2.75];

% --- set movie noise level
params.randCuePercent = false;
% params.cuePercentRange = [0.3 0.5 0.7 0.9];
params.cuePercentRange = 1.0;
params.cuePercent_easy = max(params.cuePercentRange);
params.cuePercent_hard = min(params.cuePercentRange);

% --- set stimulus timing
% params.movieMode = 'stdp';
params.movieMode = 'simPairs';  % simultaneous pairs

% --- STIMULUS PAIR CONTROL
% these options constrain buildTrials, sampleStimSpace, and pairStim fxs 
% controlling what stim are generated and how they are paired to cue
% state 

params.pairMode = 'newPairs_each_block'; % generate new stim lists each block
% params.pairMode = 'newPairs_each_run'; % generate new stim list once at program start, but randomize
% params.pairMode = 'fixedPairs_randSeq'; % same stim pairs same order, all blocks and all runs



% --- control how stim correlation is degraded
params.barNoiseMode = 'breakPairs';
% params.barNoiseMode = 'noisePairs';

% --- TRAINING OPTIONS
% params.constantPairs = true;  % show fixed stim pairs over blocks
% params.onePairPerCond = true;  % show one stim pair per trial
% params.fixPairSeq = true;  % holds order of pairs in each movie constant
params.colorCue = false;
params.toneFeedback = true;
params.correctToneDur = 500;
params.correctToneFreq = 800;
params.errorToneDur = 500;
params.errorToneFreq = 0;

params.errorZeroRew = true;

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

params.leftJoyRespWin = [-8, 0];
params.rightJoyRespWin = [8, 0];

% --- FIX WINDOW DIMENSIONS
% params.eye_radius = 10;
% params.joy_radius = 6;
params.eye_radius = 4;
params.joy_radius = 5;

% --- FEEDBACK
params.rewBox_width = 10; % degrees visual angle
params.rewBox_height = 1;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -10;
params.rewText_yPos = -20;

end
