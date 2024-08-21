function [params] = setParams()

% --- STIMULUS FEATURE SPACE
% --- variable feature dimensions
params.Angles = [0 45 90 135];
params.FaceColors = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
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

% --- MOVIE CONTROL
params.randCuePairNum = true;
params.numMoviePairs = 30;
params.numCuePairs = [14 18 22 26];
params.numCuePairs_easy = max(params.numCuePairs);
params.numCuePairs_hard = min(params.numCuePairs);
% check each cue pair number is divisible by 2, error if not
for np = 1 : length (params.numCuePairs)
    if rem(params.numCuePairs(np), 2)
        error('error in setParams(), number of cue pairs must be divisible by 2');
    end
end

% params.movieMode = 'simultaneous';
params.movieMode = 'stdp';

% --- CHOICE/REWARD 
params.choice_x = 4;
params.choice_y = 0;
params.highRewProb = 0.8;
params.lowRewProb = 0.2;

% --- FEEDBACK
params.printOutcome = false;
params.rewBox_width = 15; % degrees visual angle
params.rewBox_height = 3;
params.rewBox_degPerWin = params.rewBox_width/ params.netWin_criterion;
params.rewBox_yPos = -15;
params.rewText_yPos = -20;

end