function corrRL_bin2mat_v2()
%%

% This function opens monkeyLogic bhv2 output files, converts to a matlab
% matrix and saves

% Version history
% V1: built to work with xPairs (dot design)\
% V2: adapted to work with corr_RL

dbstop if error
tic;
clear;

% --- PARAMS ---
params.maxEventCodes = 300;
params.sepValue = -111111;

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
            [thisTrial, stdcol] = extractTrial(inTrial, params, thisFile);  % pass in s for set counter in header
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


plot_bData(stdcol, bData);

end
% -------------------------------------------------------------------------
% ------------------------- UTILITY FUNCTIONS -----------------------------
% -------------------------------------------------------------------------

% EXTRACT TRIAL SHORT -----------------------------------------------------------
function [thisTrial, stdcol] = extractTrial(inTrial, params, thisFile)

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
cp = inTrial.UserVars.condArray(inTrial.Condition).cuePercent;
cpr = inTrial.UserVars.params.cuePercentRange;
% compute cuePercentGroup based on cuePercent and cuePercentRange
cpg = find(inTrial.UserVars.params.cuePercentRange == cp);
cp_eb = inTrial.UserVars.params.cuePercent_easy;
cp_hb = inTrial.UserVars.params.cuePercent_hard;
nmp = inTrial.UserVars.params.numMoviePairs;
switch inTrial.UserVars.params.movieMode
    case 'stdp'
        mm = 1;
    case 'simultaneous'
        mm = 2;
end
hrp = inTrial.UserVars.params.highRewProb;
lrp = inTrial.UserVars.params.lowRewProb;

paramData = [nb rpc bcm nwc cp cpg cpr cp_eb cp_hb nmp mm hrp lrp];

% --- add parameter vars to stdcol
stdcol.numBlocks = stdcol.endTrialCountData + 1;
stdcol.repsPerCond = stdcol.numBlocks + 1;
stdcol.blockChangeMode = stdcol.repsPerCond + 1;
stdcol.netWinCriterion = stdcol.blockChangeMode + 1;
stdcol.cuePercent = stdcol.netWinCriterion + 1;
stdcol.cuePercentGroup = stdcol.cuePercent + 1;
stdcol.cuePercentRangeStart = stdcol.cuePercentGroup + 1;
stdcol.cuePercentRangeStop = stdcol.cuePercentRangeStart + length(cpr) - 1;
stdcol.cuePercent_easy = stdcol.cuePercentRangeStop + 1;
stdcol.cuePercent_hard = stdcol.cuePercent_easy + 1;
stdcol.numMoviePairs = stdcol.cuePercent_hard + 1;
stdcol.movieMode = stdcol.numMoviePairs + 1;
stdcol.highRewProb = stdcol.movieMode + 1;
stdcol.lowRewProb = stdcol.highRewProb + 1;
stdcol.endParamData = stdcol.lowRewProb + 1;

% --- AGGREGATE CHOICE REWARD DATA
rs = inTrial.UserVars.condArray(inTrial.Condition).movieRewState;
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


% PLOT BDATA -------------------------------------------------------------
function [] = plot_bData(stdcol, bData)

bob = 1;

% plot probability of selecting high value target as a function of trial
% within block, are we learning yet?

cc_by_trlBlk = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.trialInBlock));
figure;
plot(cc_by_trlBlk);

[mean, sem] = grpstats(bData(:, stdcol.choseCorrect), bData(:, stdcol.cuePercentGroup), {'mean', 'sem'});
figure;
errorbar(mean, sem);


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

