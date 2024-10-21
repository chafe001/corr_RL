function corrRL_bin2mat_v6()
%%

% This function opens monkeyLogic bhv2 output files, converts to a matlab
% matrix and saves

% Version history
% V1: built to work with xPairs (dot design)
% V2: adapted to work with corr_RL
% v4: working with new bar paring algorithm
% v5: adapted to carry pairs variable through pipeline
% v6: add pairSeq to output matrix

dbstop if error
tic;
clear;

% --- PARAMS ---
params.maxEventCodes = 300;
params.sepValue = -111111;

% params.stimType = 'curves';
params.stimType = 'bars';

% --- CONTROL NUMBER OF VARIABLES INCLUDED IN OUTFILE
params.shortOutput = true;
params.saveMatOut= true;

% ------------------------ INITIALIZE
COMPUTER = getenv('COMPUTERNAME');
if (isempty(COMPUTER))
    COMPUTER = getenv('HOSTNAME');
end

switch COMPUTER
    case 'MATTWALLIN'
        stdInPath = 'D:\DATA\stdin\';
        stdOutPath = 'D:\DATA\stdout\';

    case 'DESKTOP-7CHQEHS'  % home PC
        stdInPath = 'D:\DATA\stdin\';
        stdOutPath = 'D:\DATA\stdout\';

    case 'MATT_MICRO'
        stdInPath = 'C:\MYFILES\1 DATA\stdin\';
        stdOutPath = 'C:\MYFILES\1 DATA\stdin\';
    case '3080Y25-G0Y3FF'
        % augsburg desktop
        stdInPath = 'C:\Users\crowe\Documents\GitHub\corr_RL\corr_RL task code\';
        stdOutPath = 'C:\Users\crowe\Documents\GitHub\corr_RL\corr_RL task code\';
end

% ------------------------ GET LIST OF  FILES TO PROCEESS
cd(stdInPath);
pathFile = strcat(stdInPath, '*.bhv2');
fileNames  = dir(pathFile);
numFiles = length(fileNames);
if(numFiles == 0)
    error('No files in stdIn direction, put some files in there to analyze.');
end

% ------------- LOOP THROUGH FILE LIST, AGGREGATE BDATA ACROSS ENSEMBLES
% v5: adding trial count for bal pre per ensemble
bData = [];
rtData= [];

disp('accumulating bData...');

for thisFile = 1 : numFiles

    % ------------ INITIALIZE ENS LEVEL VARIABLES IN LOOP
    session_bData = [];

    % ------------- OPEN NEXT WINBIN FILE
    thisFileName = fileNames(thisFile).name;
    disp(thisFileName);
    pathFile = strcat(stdInPath, thisFileName);
    inDat = mlread(pathFile);  % data do not come in as subfield of 'ans' as in TOPX data so conversion here not necessary

    % ------------- AGGREGATE BDATA OVER TRIALS IN SESSION
    nTrials = size(inDat, 2);
    for t = 1 : nTrials
        inTrial = inDat(t);

        % --- pull behavioral data out of native ML structure array
        % format to construct matrix, recompute stdcol every trial is
        % redundant but code will be easier to maintain as changes to
        % extractTrial are made...

        if inTrial.TrialError == 0

            % --- extract trial depending on which stimType
            switch params.stimType
                case 'bars'
                    [thisTrial, stdcol] = extractTrial_bars(inTrial, params, thisFile); 

                case 'curves'
                    [thisTrial, stdcol] = extractTrial_curves(inTrial, params, thisFile);
            end

            % --- add trial
            session_bData = [session_bData; thisTrial];

        end
    end

    bob = 'here';

    % --- AGGREGATE BDATA OVER SESSIONS
    bData = [bData; session_bData];

end  % for thisFile = 1:numFiles

if params.saveMatOut
    % --- SAVE THIS SUBJECTS BDATA in case of crash, takes forever to read
    % the binary files
    outFileName = 'all_bData.mat';
    save(outFileName, "bData", "stdcol");
end


bob = 1;


toc;
%%

params.stimType = 'bars';

switch params.stimType
    case 'bars'
        plot_bData_bars(stdcol, bData);

    case 'curves'
        plot_bData_curves(stdcol, bData);

end

end


% -------------------------------------------------------------------------
% ------------------------- UTILITY FUNCTIONS -----------------------------
% -------------------------------------------------------------------------

% ----------------------------------------------------------------------
function [thisTrial, stdcol] = extractTrial_bars(inTrial, params, thisFile)

trialData = [];
eventData = [];

% --- AGGREGATE ML HEADER TRIAL DATA as originally saved
trialCountData = [thisFile inTrial.Trial inTrial.BlockCount inTrial.TrialWithinBlock inTrial.Block inTrial.Condition inTrial.TrialError params.sepValue];

% --- add header vars to stdcol
stdcol.fileNum = 1;
stdcol.trial = stdcol.fileNum + 1;
stdcol.blockCount = stdcol.trial + 1;
stdcol.trialInBlock = stdcol.blockCount + 1;
stdcol.block = stdcol.trialInBlock + 1;
stdcol.cond = stdcol.block  + 1;
stdcol.trialError = stdcol.cond + 1;
stdcol.endTrialCountData = stdcol.trialError + 1;

% --- AGGREGATE PARAMS
nb = inTrial.UserVars.params.numBlocks;
rpc = inTrial.UserVars.params.repsPerCond;
switch inTrial.UserVars.params.blockChange
    case 'netWinsMode'
        bcm = 1;
    case 'condRepsMode'
        bcm = 2;
end
nwc = inTrial.UserVars.params.netWin_criterion;
rcp = double(inTrial.UserVars.params.randCuePercent);
cp = inTrial.UserVars.condArray(inTrial.Condition).cuePercent;
cpr = inTrial.UserVars.params.cuePercentRange;
% compute cuePercentGroup based on cuePercent and cuePercentRange
cpg = find(inTrial.UserVars.params.cuePercentRange == cp);
cp_e = inTrial.UserVars.params.cuePercent_easy;
cp_h = inTrial.UserVars.params.cuePercent_hard;

switch inTrial.UserVars.params.movieMode
    case 'simPairs'
        mm = 1;
    case 'stdp'
        mm = 2;
end

ncs = inTrial.UserVars.params.numCueStim;
ncr = inTrial.UserVars.params.numCueReps;

switch inTrial.UserVars.params.pairMode
    case 'xPairs'
        pm = 1;
    case 'randList'
        pm = 2;
end

switch inTrial.UserVars.params.barNoiseMode
    case 'breakPairs'
        bnm = 1;
    case 'noisePairs'
        bnm = 2;
end

hrp = inTrial.UserVars.params.highRewProb;
lrp = inTrial.UserVars.params.lowRewProb;

paramData = [nb rpc bcm nwc rcp cp cpr cpg cp_e cp_h mm ncs ncr pm bnm hrp lrp params.sepValue];

% --- add parameter vars to stdcol
stdcol.numBlocks = stdcol.endTrialCountData + 1;
stdcol.repsPerCond = stdcol.numBlocks + 1;
stdcol.blockChangeMode = stdcol.repsPerCond + 1;
stdcol.netWinCriterion = stdcol.blockChangeMode + 1;
stdcol.randCuePerc = stdcol.netWinCriterion + 1;
stdcol.cuePercent = stdcol.randCuePerc + 1;
stdcol.cuePercRange = stdcol.cuePercent + 1;
stdcol.cuePercentGroup = stdcol.cuePercRange + length(inTrial.UserVars.params.cuePercentRange);
stdcol.cuePercent_easy = stdcol.cuePercentGroup + 1;
stdcol.cuePercent_hard = stdcol.cuePercent_easy + 1;
stdcol.movieMode = stdcol.cuePercent_hard + 1;
stdcol.numCueStim = stdcol.movieMode + 1;
stdcol.numCueReps = stdcol.numCueStim + 1;
stdcol.pairMode = stdcol.numCueReps + 1;
stdcol.barNoiseMode = stdcol.pairMode + 1;
stdcol.highRewProb = stdcol.barNoiseMode + 1;
stdcol.lowRewProb = stdcol.highRewProb + 1;
stdcol.endParamData = stdcol.lowRewProb + 1;

% --- AGGREGATE CHOICE REWARD DATA
rs = inTrial.UserVars.condArray(inTrial.Condition).state;
r_t = inTrial.UserVars.choices.rewardTrial;
rt = inTrial.ReactionTime;
bw = inTrial.UserVars.TrialRecord.User.blockWins;
bl = inTrial.UserVars.TrialRecord.User.blockLosses;
nw = inTrial.UserVars.TrialRecord.User.netWins;
cc = inTrial.UserVars.choices.choseCorrect;
rk = inTrial.UserVars.choices.responseKey;
% rnw = random number at runtime to determine whether to reward trial
% according to reward state probabilities
rnw = inTrial.UserVars.choices.randNum_rew;

rewChoiceData = [rs r_t rt bw bl nw cc rk rnw params.sepValue];

% --- add choice and reward vars to stdcol
stdcol.rewardState = stdcol.endParamData + 1;
stdcol.rewardTrial = stdcol.rewardState + 1;
stdcol.reactionTime = stdcol.rewardTrial + 1;
stdcol.blockWins = stdcol.reactionTime + 1;
stdcol.blockLosses = stdcol.blockWins + 1;
stdcol.netWins = stdcol.blockLosses + 1;
stdcol.choseCorrect = stdcol.netWins + 1;
stdcol.responseKey = stdcol.choseCorrect + 1;
stdcol.randNum_rew = stdcol.responseKey + 1;
stdcol.endChoiceData = stdcol.randNum_rew + 1;


% --- AGGREGATE MOVIE DATA

maxMovieFrames = 40;

% determine number of stimulus frames shown
numFrames = size(inTrial.UserVars.TrialRecord.User.pairs, 2);

% aggregate stimulus ids in each frame shown, including pairs and
% singletons

leftID_vect = [];
rightID_vect = [];

for p = 1 : numFrames
    switch inTrial.UserVars.TrialRecord.User.pairs(p).showStim
        case 'both'
            leftID_vect = [leftID_vect inTrial.UserVars.TrialRecord.User.pairs(p).leftStim_id];
            rightID_vect = [rightID_vect inTrial.UserVars.TrialRecord.User.pairs(p).rightStim_id];

        case 'leftOnly'
            leftID_vect = [leftID_vect inTrial.UserVars.TrialRecord.User.pairs(p).leftStim_id];
            rightID_vect = [rightID_vect NaN];

        case 'rightOnly'
            leftID_vect = [leftID_vect NaN];
            rightID_vect = [rightID_vect inTrial.UserVars.TrialRecord.User.pairs(p).rightStim_id];
    end

end

if length(leftID_vect) < maxMovieFrames
    numPad = maxMovieFrames - length(leftID_vect);
    leftID_vect = [leftID_vect NaN(1, numPad)];
end

if length(rightID_vect) < maxMovieFrames
    numPad = maxMovieFrames - length(rightID_vect);
    rightID_vect = [rightID_vect NaN(1, numPad)];
end

% count reps of each stim type at left and right positions to check equal numbers
tblLeft = tabulate(leftID_vect);
tblRight = tabulate(rightID_vect);

stimLeft = tblLeft(:, 1)';
repsLeft = tblLeft(:, 2)';

stimRight = tblRight(:, 1)';
repsRight = tblRight(:, 2)';

pairSeq = inTrial.UserVars.TrialRecord.User.pairSeq;

sep = params.sepValue;

movieData  = [leftID_vect sep rightID_vect sep stimLeft sep repsLeft sep stimRight sep repsRight sep pairSeq];

stdcol.firstLeftStim = stdcol.endChoiceData + 1;
stdcol.endLeftStim = stdcol.firstLeftStim + maxMovieFrames;
stdcol.firstRightStim = stdcol.endLeftStim + 1;
stdcol.endRightStim = stdcol.firstRightStim + maxMovieFrames;
stdcol.firstStimID_left = stdcol.endRightStim + 1;
stdcol.endStimID_left = stdcol.firstStimID_left + length(stimLeft);
stdcol.firstStimRep_left = stdcol.endStimID_left + 1;
stdcol.endStimRep_left = stdcol.firstStimRep_left + length(repsLeft);
stdcol.firstStimID_right = stdcol.endStimRep_left + 1;
stdcol.endStimID_right = stdcol.firstStimID_right + length(stimLeft);
stdcol.firstStimRep_right = stdcol.endStimID_right + 1;
stdcol.endStimRep_right = stdcol.firstStimRep_right + length(repsLeft);
stdcol.firstPairSeq = stdcol.endStimRep_right + 1;


% --- CONCATENATE DATA TO BUILD TRIAL ROW
thisTrial = [trialCountData paramData rewChoiceData movieData];

return;

end

% ----------------------------------------------------------------------
function [thisTrial, stdcol] = extractTrial_curves(inTrial, params, thisFile)

trialData = [];
eventData = [];


% --- AGGREGATE ML HEADER TRIAL DATA as originally saved
trialCountData = [thisFile inTrial.Trial inTrial.BlockCount inTrial.TrialWithinBlock inTrial.Block inTrial.Condition inTrial.TrialError];

% --- add header vars to stdcol
stdcol.fileNum = 1;
stdcol.trial = stdcol.fileNum + 1;
stdcol.blockCount = stdcol.trial + 1;
stdcol.trialInBlock = stdcol.blockCount + 1;
stdcol.block = stdcol.trialInBlock + 1;
stdcol.cond = stdcol.block  + 1;
stdcol.trialError = stdcol.cond + 1;
stdcol.endTrialCountData = stdcol.trialError + 1;

% --- AGGREGATE PARAMS
nb = inTrial.UserVars.params.numBlocks;
rpc = inTrial.UserVars.params.repsPerCond;
switch inTrial.UserVars.params.blockChange
    case 'netWinsMode'
        bcm = 1;
    case 'condRepsMode'
        bcm = 2;
end
nwc = inTrial.UserVars.params.netWin_criterion;
switch inTrial.UserVars.params.movieMode
    case 'stdp'
        mm = 1;
end
switch inTrial.UserVars.params.stimulusType
    case 'bars'
        st = 1;
    case 'curves'
        st = 2;
end
cpm = inTrial.UserVars.params.nCurvesPerMovie;
switch inTrial.UserVars.params.blockParam

    case 'curveMovieType'
        bp = 1;

end
ntvm = inTrial.UserVars.params.n_tvals_main;
ntvo = inTrial.UserVars.params.n_tvals_ortho;
skg = inTrial.UserVars.params.size_of_knot_grid;
mkn = inTrial.UserVars.params.max_knot_number;
nkp = inTrial.UserVars.params.n_knot_points;
qd = inTrial.UserVars.movieParams.quad;
switch inTrial.UserVars.movieParams.curveMovieType
    case 'smooth'
        cmt = 1;
    case 'rough'
        cmt = 2;
end
switch inTrial.UserVars.movieParams.orientation
    case 'horizontal'
        cmo = 1;
    case 'vertical'
        cmo = 2;
    case 'diagonal'
        cmo = 3;
end
msq = inTrial.UserVars.movieParams.mainSeq;
osq = inTrial.UserVars.movieParams.orthoSeq;
mtv = inTrial.UserVars.movieParams.mainTvalSeq;
otv = inTrial.UserVars.movieParams.orthoTvalSeq;
hrp = inTrial.UserVars.params.highRewProb;
lrp = inTrial.UserVars.params.lowRewProb;

paramData = [nb rpc bcm nwc mm st cpm bp ntvm ntvo skg mkn nkp qd cmt cmo msq params.sepValue osq params.sepValue mtv params.sepValue otv params.sepValue hrp lrp];

% --- add parameter vars to stdcol
stdcol.numBlocks = stdcol.endTrialCountData + 1;
stdcol.repsPerCond = stdcol.numBlocks + 1;
stdcol.blockChangeMode = stdcol.repsPerCond + 1;
stdcol.netWinCriterion = stdcol.blockChangeMode + 1;
stdcol.movieMode = stdcol.netWinCriterion + 1;
stdcol.stimulusType = stdcol.movieMode + 1;
stdcol.nCurvesPerMovie = stdcol.stimulusType + 1;
stdcol.blockParam = stdcol.nCurvesPerMovie + 1;
stdcol.n_tvals_main = stdcol.blockParam + 1;
stdcol.n_tvals_ortho = stdcol.n_tvals_main + 1;
stdcol.size_of_knot_grid = stdcol.n_tvals_ortho + 1;
stdcol.max_knot_number = stdcol.size_of_knot_grid + 1;
stdcol.n_knot_points = stdcol.max_knot_number + 1;
stdcol.curveGridQuad = stdcol.n_knot_points + 1;
stdcol.curveMovieType = stdcol.curveGridQuad + 1;
stdcol.curveMovieOrientation = stdcol.curveMovieType + 1;
stdcol.mainSeq = stdcol.curveMovieOrientation + 1;
stdcol.endMainSeq = stdcol.mainSeq + length(msq);
stdcol.orthoSeq = stdcol.endMainSeq + 1;
stdcol.endOrthoSeq = stdcol.orthoSeq + length(osq);
stdcol.mainTvalSeq = stdcol.endOrthoSeq + 1;
stdcol.endMainTvalSeq = stdcol.mainTvalSeq + length(mtv);
stdcol.orthoTvalSeq = stdcol.endMainTvalSeq + 1;
stdcol.endOrthoTvalSeq = stdcol.orthoTvalSeq + length(otv);
stdcol.highRewProb = stdcol.endOrthoTvalSeq + 1;
stdcol.lowRewProb = stdcol.highRewProb + 1;
stdcol.endParamData = stdcol.lowRewProb + 1;

% --- AGGREGATE CHOICE REWARD DATA
rs = inTrial.UserVars.condArray(inTrial.Condition).state;
r_t = inTrial.UserVars.choices.rewardTrial;
rt = inTrial.ReactionTime;
bw = inTrial.UserVars.TrialRecord.User.blockWins;
bl = inTrial.UserVars.TrialRecord.User.blockLosses;
nw = inTrial.UserVars.TrialRecord.User.netWins;
cc = inTrial.UserVars.choices.choseCorrect;
rk = inTrial.UserVars.choices.responseKey;
% rnw = random number at runtime to determine whether to reward trial
% according to reward state probabilities
rnw = inTrial.UserVars.choices.randNum_rew;

rewChoiceData = [rs r_t rt bw bl nw cc rk rnw];

% --- add choice and reward vars to stdcol
stdcol.rewardState = stdcol.endParamData + 1;
stdcol.rewardTrial = stdcol.rewardState + 1;
stdcol.reactionTime = stdcol.rewardTrial + 1;
stdcol.blockWins = stdcol.reactionTime + 1;
stdcol.blockLosses = stdcol.blockWins + 1;
stdcol.netWins = stdcol.blockLosses + 1;
stdcol.choseCorrect = stdcol.netWins + 1;
stdcol.responseKey = stdcol.choseCorrect + 1;
stdcol.randNum_rew = stdcol.responseKey + 1;

% --- CONCATENATE DATA TO BUILD TRIAL ROW
sep = params.sepValue;
thisTrial = [trialCountData sep paramData sep rewChoiceData];

return;

end


% ----------------------------------------------------------------------
function [] = plot_bData_bars(stdcol, bData)

trialMin = 0;
trialMax = 40;
trialTick = 5;
tickLength = 0.03;
left = 1.0;
bottom = 1.0;
width = 4.0;
height = 3.0;
perfMin = 0.0;
perfMax = 1.0;
perfTick = 0.10;

% proportion choseCorrect by trialInBlock, learning curve in block
cc_by_trlBlk = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.trialInBlock));
figure;
plot(cc_by_trlBlk);
axis([trialMin, trialMax, perfMin, perfMax]);  %  reset ranges for x and y axes
set(gca, 'box', 'off');
set(gca, 'TickDir', 'out');   
set(gca, 'XTick', trialMin:trialTick:trialMax);
set(gca, 'YTick', perfMin:perfTick:perfMax);
set(gca, 'TickLength', [tickLength tickLength]);            %  this in proportion of x axis
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);  
set(gca, 'Units', 'centimeters');
set(gca, 'Position', [left bottom width height]);
title('choseCorrect by trialInBlock', 'FontSize', 9, 'FontWeight', 'normal');

minCuePerc = 1;
maxCuePerc = 4;
cuePercTick = 1;

% proportion choseCorrect by cuePercent, effect of noise
[mean, sem, grp] = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.cuePercentGroup), {'mean', 'sem', 'gname'});
figure;
errorbar(mean, sem);
xSpan = xlim;
ySpan = ylim;
axis([xSpan(1) - 0.5, xSpan(2) + 0.5, ySpan(1), ySpan(2)]);
set(gca, 'box', 'off');
set(gca, 'TickDir', 'out');   
set(gca, 'XTick', xSpan(1):1:xSpan(2));
set(gca, 'YTick', perfMin:perfTick:perfMax);
set(gca, 'TickLength', [tickLength tickLength]);            %  this in proportion of x axis
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);  
set(gca, 'Units', 'centimeters');
set(gca, 'Position', [left bottom width height]);
title('choseCorrect by cuePerc, all trials', 'FontSize', 9, 'FontWeight', 'normal');

% divide data by corrStrength
cuePerc_here = unique(bData(:, stdcol.cuePercent));
figure;
hold on;
for f = 1 : length(cuePerc_here)

    thisLevel = bData(bData(:, stdcol.cuePercent) == cuePerc_here(f), :);

    perf = grpstats(thisLevel(:, stdcol.choseCorrect), thisLevel(:, stdcol.trialInBlock));

    plot(perf);
end



bob = 1;

end

% ----------------------------------------------------------------------
function [] = plot_bData_curves(stdcol, bData)

trialMin = 0;
trialMax = 40;
trialTick = 5;
tickLength = 0.03;
left = 1.0;
bottom = 1.0;
width = 4.0;
height = 3.0;
perfMin = 0.0;
perfMax = 1.0;
perfTick = 0.10;

% proportion choseCorrect by trialInBlock, learning curve in block
cc_by_trlBlk = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.trialInBlock));
figure;
plot(cc_by_trlBlk);
axis([trialMin, trialMax, perfMin, perfMax]);  %  reset ranges for x and y axes
set(gca, 'box', 'off');
set(gca, 'TickDir', 'out');   
set(gca, 'XTick', trialMin:trialTick:trialMax);
set(gca, 'YTick', perfMin:perfTick:perfMax);
set(gca, 'TickLength', [tickLength tickLength]);            %  this in proportion of x axis
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);  
set(gca, 'Units', 'centimeters');
set(gca, 'Position', [left bottom width height]);
title('choseCorrect by trialInBlock', 'FontSize', 9, 'FontWeight', 'normal');

minCuePerc = 1;
maxCuePerc = 4;
cuePercTick = 1;

% proportion choseCorrect by cueMovieOrientation, direction of movie
% through feature/noise feature grid
[mean, sem] = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.curveMovieOrientation), {'mean', 'sem'});
figure;
errorbar(mean, sem);
xSpan = xlim;
ySpan = ylim;
axis([xSpan(1) - 0.5, xSpan(2) + 0.5, ySpan(1), ySpan(2)]);
set(gca, 'box', 'off');
set(gca, 'TickDir', 'out');   
set(gca, 'XTick', xSpan(1):1:xSpan(2));
set(gca, 'YTick', perfMin:perfTick:perfMax);
set(gca, 'TickLength', [tickLength tickLength]);            %  this in proportion of x axis
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);  
set(gca, 'Units', 'centimeters');
set(gca, 'Position', [left bottom width height]);
title('choseCorrect by curveMovieOrientation', 'FontSize', 9, 'FontWeight', 'normal');

% propotion choseCorrect by curveMovieType, smooth or rough
[mean, sem] = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.curveMovieType), {'mean', 'sem'});
figure;
errorbar(mean, sem);
xSpan = xlim;
ySpan = ylim;
axis([xSpan(1) - 0.5, xSpan(2) + 0.5, ySpan(1), ySpan(2)]);
set(gca, 'box', 'off');
set(gca, 'TickDir', 'out');   
set(gca, 'XTick', xSpan(1):1:xSpan(2));
set(gca, 'YTick', perfMin:perfTick:perfMax);
set(gca, 'TickLength', [tickLength tickLength]);            %  this in proportion of x axis
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);  
set(gca, 'Units', 'centimeters');
set(gca, 'Position', [left bottom width height]);
title('choseCorrect by curveMovieType', 'FontSize', 9, 'FontWeight', 'normal');


bob = 1;

end

% % ANALYZE BDATA -----------------------------------------------------------
% function [] = analyze_bData(bData, stdcol, params)
%
% keepData = [];
%
% % --- create consecutive trial numbers for each file/set
% filesHere = unique(bData(:, stdcol.fileNum));
% for f = 1 : numel(filesHere)
%     fileMat = bData(bData(:, stdcol.fileNum) == filesHere(f), :);
%     consTrials = (1:size(fileMat, 1));
%     fileMat(:, stdcol.trial) = consTrials';
%     if numel(consTrials) < params.minTrials
%         continue
%     end
%     keepData = [keepData; fileMat];
% end
%
% % ---- Plot stim choice (A, B or C) on same axes, per file (day) in the
% % aggregated data
% left = 2.0;
% bottom = 2.0;
% width = 36.0;
% height = 6.0;
% trialStart = 0;
% % trialStop = 600;
% trialStop = size(bData, 1);
%
% filesHere = unique(keepData(:, stdcol.fileNum));
%
% for f = 1 : numel(filesHere)
%     thisFile = keepData(keepData(:, stdcol.fileNum) == filesHere(f), :);
%
%     % --- RUN BECKET'S HMM CODE
%     [states,stateProbs,LL,nParams,Tall,Eall] = find3States(thisFile(:, stdcol.choseStim)');
%
%     state1 = (states(:) == 1);
%     state2 = (states(:) == 2);
%     state3 = (states(:) == 3);
%     state4 = (states(:) == 4);
%
%     explore = (states(:) == 1);
%     exploit = (states(:) ~= 1);
%
%     % --- shift explore/exploit values up for plotting with choices on same axes
%     explore = explore + 3.0;
%     exploit = exploit + 3.0;
%
%     % --- PLOT explore/exploit
%     figure;
%     pExplore = plot(explore);
%     pExplore.Color = "magenta";
%     pExplore.LineWidth = 1.5;
%     hold on;
%     pExploit = plot(exploit);
%     pExploit.Color = "black";
%     pExploit.LineWidth = 1.5;
%
%     % --- ADD choice L, R, U (left, right, up)
%     plotL = plot(thisFile(:, stdcol.choseLeft) + 1.5);
%     plotL.Color = [0.4940 0.1840 0.5560];  % purple
%     plotL.LineWidth = 1.5;
%
%     plotR = plot(thisFile(:, stdcol.choseRight) + 1.5);
%     plotR.Color = [0.9290 0.6940 0.1250];  % orange
%     plotR.LineWidth = 1.5;
%
%     plotR = plot(thisFile(:, stdcol.choseUp) + 1.5);
%     plotR.Color = [0 0.4470 0.7410];  % blue
%     plotR.LineWidth = 1.5;
%
%     % --- ADD choice A, B, C (greenpentagon, bluetriangle, orangerectangle)
%     plotA = plot(thisFile(:, stdcol.choseA));
%     plotA.Color = "green";
%     plotA.LineWidth = 1.5;
%
%     hold on;
%     plotB = plot(thisFile(:, stdcol.choseB));
%     plotB.Color = "blue";
%     plotB.LineWidth = 1.5;
%
%     plotC = plot(thisFile(:, stdcol.choseC));
%     plotC.Color = [1 0.6 0];  % orange
%     plotC.LineWidth = 1.5;
%
%     % --- add title, use cell array for multiple lines
%     title({"STATE (top) Explore=Magenta Exploit=Black", "DIRECTION (middle) chose Left=Purple, Right=Orange, Up=Dk Blue", "OBJECT (bottom) chose A=Green(pentagon) B=Blue(triangle) C=Orange(rectangle)"});
%
%     % reformat plot
%     axis([trialStart, trialStop, -0.5, 5.0]);  %  reset ranges for x and y axes
%     set(gca, 'Units', 'centimeters');
%     set(gca, 'FontName', 'Arial');
%     set(gca, 'FontSize', 9);
%     set(gca, 'FontSmoothing', 'off');
%     set(gca, 'TickDir', 'out');                     %  switch side of axis for tick marks
%     set(gca, 'Box', 'off');
%     set(gca, 'Position', [left bottom width height]);
%     set(gca, 'TickLength', [0.01 0.01]);
%     set(gca, 'xTick', trialStart:20:trialStop);
%
% end
%
% % --- plot response probability as a function of reward probability
% left = 2.0;
% bottom = 2.0;
% width = 4.0;
% height = 4.0;
% figure
% hist(keepData(:, stdcol.choseProb));
% set(gca, 'Units', 'centimeters');
% set(gca, 'FontName', 'Arial');
% set(gca, 'FontSize', 9);
% set(gca, 'FontSmoothing', 'off');
% set(gca, 'TickDir', 'out');                     %  switch side of axis for tick marks
% set(gca, 'Box', 'off');
% set(gca, 'Position', [left bottom width height]);
% set(gca, 'TickLength', [0.03 0.03]);
% set(gca, 'xTick', 0:0.1:1);
% set(gca, 'yTick', 0:250:1500);
%
% bob = 1;
%
% return;
%
% end

