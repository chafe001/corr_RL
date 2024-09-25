function behv_tbt_v4()

% first pass tbt behavioral analysis program

% v4: including trials with trial error 5: no reward given (still valid
% trials)

tic;

%ccc;

%put winbin in stdin

% clear left over variables from prior runs...
clear;

% --- PARAMS ---
% params.trialSet = 'all';
params.maxHeaderCols = 60;
params.maxEventCodes = 30;
params.sepValue = -111111;
params.minTrials = 50;  % minimum trials per file to include
params.minReps = 4;  % minimum number of repetitions per trial to include
% --- RECODE stimuli IDs as integers, saved as strings
% from tbt_train_stage1_3arm.m (ML task code)
% Astim = 'greenpentagon.png'; 
% Bstim = 'bluetriangle.png'; 
% Cstim = 'orangerectangle.png';
params.Astim = 1; 
params.Bstim = 2;
params.Cstim = 3;
% --- RECODE stimuli locations
params.left = 1;
params.right = 2;
params.up = 3;

params.rewardCode = 140; % behavioral code written by goodmonkey in tbt_vanilla_3arm_final.m

% if error, stop execution and hold variables in memory, don't exit
dbstop if error

% ------------------------ INITIALIZE
COMPUTER = getenv('COMPUTERNAME');
if (isempty(COMPUTER))
    COMPUTER = getenv('HOSTNAME');
end

switch COMPUTER
    case 'MATTWALLIN'
        stdInPath = 'D:\DATA\stdin\';
        stdOutPath = 'D:\DATA\stdout\';

    case 'DESKTOP-RJQAES2'  % lab remote desktop
        stdInPath = 'D:\DATA\stdin\TBT\';
        stdOutPath = 'D:\DATA\stdout\TBT\';

    case 'DESKTOP-SR3DBPM'
        stdInPath = 'D:\2 DATA\Big Dan\Behavior Files\Big Dan\TBT\November 2022\Random Walk ON\';
        stdOutPath = 'D:\2 DATA\stdout\';

    case 'DESKTOP-7CHQEHS'  % home PC
        stdInPath = 'D:\DATA\stdin\';
        stdOutPath = 'D:\DATA\stdout\';

    case 'DESKTOP-RV80PF6' % lab main computer
        stdInPath = 'D:\DATA\stdin\tbt\';
        stdOutPath = 'D:\DATA\stdout\tbt\';

    case 'BEAST'
        stdInPath = 'D:\DATA\stdin\TBT\';
        stdOutPath = 'D:\DATA\stdout\tbt\';

end

% ------------------------ GET LIST OF  FILES TO PROCEESS
cd(stdInPath);
pathFile = strcat(stdInPath, '*.mat');
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
    inDat = load(pathFile);  % data do not come in as subfield of 'ans' as in TOPX data so conversion here not necessary

    % ------------- AGGREGATE BDATA OVER TRIALS IN SESSION
    % depending on how data are saved to files in ML, trial sets come in as
    % fields in inDat.  Have to figure out the field name, and use string
    % to access the field contents.
    fieldsHere = fieldnames(inDat);
    fieldStr = string(fieldsHere);
    inDat = inDat.(fieldStr); % parentheses trick to use str to access structure field by name

    nTrials = size(inDat, 2);
    for t = 1 : nTrials
        inTrial = inDat(t);

        % --- IF ERROR TRIAL, SKIP
        if inTrial.TrialError ~= 0
            if inTrial.TrialError ~= 5
                continue;
            end
        end

        % --- pull behavioral data out of native ML structure array
        % format to construct matrix, recompute stdcol every trial is
        % redundant but code will be easier to maintain as changes to
        % extractTrial are made...
        [thisTrial stdcol] = extractTrial(inTrial, params, thisFile);  % pass in s for set counter in header
        session_bData = [session_bData; thisTrial];
    end

    % --- AGGREGATE BDATA OVER SESSIONS
    bData = [bData; session_bData];

end  % for thisFile = 1:numFiles


analyze_bData(bData, stdcol, params);


toc;

end  % end topx_behv fx

% -------------------------------------------------------------------------
% ------------------------- UTILITY FUNCTIONS -----------------------------
% -------------------------------------------------------------------------


% EXTRACT TRIAL -----------------------------------------------------------
function [thisTrial stdcol] = extractTrial(inTrial, params, thisFile)

trialData = [];
eventData = [];

% --- AGGREGATE ML HEADER TRIAL DATA as originally saved
trialCountData = [thisFile inTrial.Trial inTrial.BlockCount inTrial.TrialWithinBlock inTrial.Block inTrial.Condition inTrial.TrialError...
    inTrial.AbsoluteTrialStartTime inTrial.TrialDateTime];

stdcol.fileNum = 1;
stdcol.trial = stdcol.fileNum + 1;
stdcol.blockCount = stdcol.trial + 1;
stdcol.trialInBlock = stdcol.blockCount + 1;
stdcol.block = stdcol.trialInBlock + 1;
stdcol.cond = stdcol.block  + 1;
stdcol.trialError = stdcol.cond + 1;
stdcol.absStartTime = stdcol.trialError + 1;
stdcol.trialYear = stdcol.absStartTime + 1;
stdcol.trialMonth = stdcol.trialYear + 1;
stdcol.trialDay = stdcol.trialMonth + 1;
stdcol.trialHour = stdcol.trialDay + 1;
stdcol.trialMin = stdcol.trialHour + 1;
stdcol.trialSec = stdcol.trialMin + 1;
stdcol.endTrialCountData = stdcol.trialSec + 1;

% --- AGGREGATE EVENT CODES AND TIMES
% the number of events and times varies across trials depending on
% performance.  Pad to align the data and square the matrix.

numEventCodes = numel(inTrial.BehavioralCodes.CodeNumbers');
numEventTimes = numel(inTrial.BehavioralCodes.CodeTimes');

if numEventCodes ~= numEventTimes
    error('Numbers of beh event codes and times do not match');
end

missingCols = params.maxEventCodes - numEventCodes;
padVect = zeros(1, missingCols);

eventNums = [inTrial.BehavioralCodes.CodeNumbers' padVect];
eventTimes = [inTrial.BehavioralCodes.CodeTimes' padVect];

stdcol.firstEventCodeCol = stdcol.endTrialCountData + 1;
stdcol.endEventCodeData = stdcol.firstEventCodeCol + params.maxEventCodes;
stdcol.firstEventTimeCol = stdcol.endEventCodeData + 1;
stdcol.endEventTimeData = stdcol.firstEventTimeCol + params.maxEventCodes;

eventData = [eventNums params.sepValue eventTimes];

% --- AGGREGATE/RECODE STIMULUS AND RESPONSE DATA
% Each trial we need to know what the spatial arrangement of stimuli and
% reward probabilities were, and what stimulus/location/rew prob that were
% selected.

% One way to do this is with a collection of 3-element vectors

% --- STIMULUS LOCATION VECTOR
% 1. stimLocs = [1 3 2]; specifies stimulus array. Numbers indicate which
% stimuli, A(1), B(2), C(3) are located in which positions on screen [L R U].
% from tbt_train_final_3arm.m task code:
% Astim = 'greenpentagon.png'; 
% Bstim = 'bluetriangle.png'; 
% Cstim = 'orangerectangle.png';
% recode strings as...
% params.Astim = 1; 
% params.Bstim = 2;
% params.Cstim = 3;
switch inTrial.UserVars.left_pic
    case 'greenpentagon.png'
        leftCue = params.Astim;
        leftProb = inTrial.UserVars.ArewProb;
        Aloc = params.left;
    case 'bluetriangle.png'
        leftCue = params.Bstim;
        leftProb = inTrial.UserVars.BrewProb;
        Bloc = params.left;
    case 'orangerectangle.png'
        leftCue = params.Cstim;
        leftProb = inTrial.UserVars.CrewProb;
        Cloc = params.left;
end

switch inTrial.UserVars.right_pic
    case 'greenpentagon.png'
        rightCue = params.Astim;
        rightProb = inTrial.UserVars.ArewProb;
        Aloc = params.right;
    case 'bluetriangle.png'
        rightCue = params.Bstim;
        rightProb = inTrial.UserVars.BrewProb;
        Bloc = params.right;
    case 'orangerectangle.png'
        rightCue = params.Cstim;
        rightProb = inTrial.UserVars.CrewProb;
        Cloc = params.right;
end

switch inTrial.UserVars.up_pic
    case 'greenpentagon.png'
        upCue = params.Astim;
        upProb = inTrial.UserVars.ArewProb;
        Aloc = params.up;
    case 'bluetriangle.png'
        upCue = params.Bstim;
        upProb = inTrial.UserVars.BrewProb;
        Bloc = params.up;
    case 'orangerectangle.png'
        upCue = params.Cstim;
        upProb = inTrial.UserVars.CrewProb;
        Cloc = params.up;
end

locStimVect = [leftCue rightCue upCue];

stdcol.leftCue = stdcol.endEventTimeData + 1;
stdcol.rightCue = stdcol.leftCue + 1;
stdcol.upCue = stdcol.rightCue + 1;
stdcol.endlocStim = stdcol.upCue + 1;

% --- STIMULUS PROBABILITY VECTOR
% 2. stimProbs = [0.8 0.2 0.1]; indicates which reward probabilities in which positions, order
% in array indicates position, L, R, U

locProbVect = [leftProb rightProb upProb];

stdcol.leftProb = stdcol.endlocStim + 1;
stdcol.rightProb = stdcol.leftProb + 1;
stdcol.upProb = stdcol.rightProb + 1;
stdcol.endlocProb = stdcol.upProb + 1;

stimData = [locStimVect params.sepValue locProbVect];

% --- AGGREGATE CHOICE DATA
% 3. choseStimVect = [bStim 0 1 0]; first element indicates which stimulus id
% was chosen, A(1), B(2) or C(3). Next three elements indicate whether A
% (1st element), B (2nd element), or C (3rd element) were 
% chosen (1) or not (0)

% 4. choseLocVect = [stimLoc 0 1 0]; first element indicates which stimulus
% location was chosen, left(1), right(2) or up(3). Next three elements
% indicate whether left (1st element), right (2nd element), or up (3rd element) locations
% were chosen (1) or not (0)

% 5. choseProbVect = [stimProb 0 1 0]; first element indicates the reward
% probability of the selected stimulus. Next three elements indicate
% whether the low(1st element), middle(2nd element) or high(3rd element) reward probability stimulus was
% chosen (1) or not (0)


% Rank stimulus probabilitiess
probVect = [inTrial.UserVars.ArewProb inTrial.UserVars.BrewProb inTrial.UserVars.CrewProb];
probSort = sort(probVect, 'ascend');

% initialize location and probability vectors
locVect = [0 0 0];
probVect = [0 0 0];
switch inTrial.UserVars.chosenStimulus
    case 'Astim'
        chosenStimVect = [params.Astim 1 0 0];
        locVect(Aloc) = 1;
        chosenLocVect = [Aloc locVect];
        chosenProb = inTrial.UserVars.ArewProb;
        probVect(probSort(:) == chosenProb) = 1;
        chosenProbVect = [chosenProb probVect];
    case 'Bstim'
        chosenStimVect = [params.Bstim 0 1 0];
        locVect(Bloc) = 1;
        chosenLocVect = [Bloc locVect];
        chosenProb = inTrial.UserVars.BrewProb;
        probVect(probSort(:) == chosenProb) = 1;
        chosenProbVect = [chosenProb probVect];
    case 'Cstim'
        chosenStimVect = [params.Cstim 0 0 1];
        locVect(Cloc) = 1;
        chosenLocVect = [Cloc locVect];
        chosenProb = inTrial.UserVars.CrewProb;
        probVect(probSort(:) == chosenProb) = 1;
        chosenProbVect = [chosenProb probVect];
end

stdcol.choseStim = stdcol.endlocProb + 1;
stdcol.choseA = stdcol.choseStim + 1;
stdcol.choseB = stdcol.choseA + 1;
stdcol.choseC = stdcol.choseB + 1;
stdcol.endChoseStim = stdcol.choseC + 1;

stdcol.choseLoc = stdcol.endChoseStim + 1;
stdcol.choseLeft = stdcol.choseLoc + 1;
stdcol.choseRight = stdcol.choseLeft + 1;
stdcol.choseUp = stdcol.choseRight + 1;
stdcol.endChoseLoc = stdcol.choseUp + 1;

stdcol.choseProb = stdcol.endChoseLoc + 1;
stdcol.choseLow = stdcol.choseProb + 1;
stdcol.choseMid = stdcol.choseLow + 1;
stdcol.choseHigh = stdcol.choseMid + 1;
stdcol.endChoseProb = stdcol.choseHigh + 1;

choiceData = [chosenStimVect params.sepValue chosenLocVect params.sepValue chosenProbVect];


% --- AGGREGATE OUTCOME DATA
% --- RT
respRT = inTrial.UserVars.stimRespRT;
retRT = inTrial.UserVars.probeReturnRT;

stdcol.respRT = stdcol.endChoseProb  + 1;
stdcol.retRT = stdcol.respRT + 1;

% --- result code
switch inTrial.UserVars.trialResult
    case 'noEyeJoyFix'
        resultCode = 0;
    case 'breakFix_joy'
        resultCode = 1;
    case 'breakFix_eye'
        resultCode = 2;
    case 'breakFix_eye_joy'
        resultCode = 3;
    case 'correctChoice'
        resultCode = 4;
    case 'incorrectChoice'
        resultCode = 5;
    case 'noResponse'
        resultCode = 6;
    case  'joyReturnSuccess'
        resultCode = 7;
end

% --- result scene
switch inTrial.UserVars.resultScene
    case 'preCue'
        resultScene = 0;
    case 'cue'
        resultScene = 1;
    case 'isi'
        resultScene = 2;
    case 'probe'
        resultScene = 3;
    case 'post_stim_resp'
        resultScene = 4;
    case 'post_probe_resp'
        resultScene = 5;    
    case 'post_probe_return'
        resultScene = 5;
    case 'feedback'
        resultScene = 6;
end

stdcol.resultCode = stdcol.retRT + 1;
stdcol.resultScene = stdcol.resultCode + 1;

% --- FIGURE OUT IF REWARDED OR NOT PROBABLISTICALLY
% goodmonkey puts in behavioral code 140
rewardVect = ismember(inTrial.BehavioralCodes.CodeNumbers, params.rewardCode);
if(sum(rewardVect) > 0)
    rewardGiven = true;
else
    rewardGiven = false;
end

outcomeData = [respRT retRT resultCode resultScene rewardGiven];

% --- CONCATENATE DATA TO BUILD TRIAL ROW
sep = params.sepValue;
thisTrial = [trialCountData sep eventData sep stimData sep choiceData sep outcomeData];

return;

end

% ANALYZE BDATA -----------------------------------------------------------
function [] = analyze_bData(bData, stdcol, params)

keepData = [];

% --- create consecutive trial numbers for each file/set
filesHere = unique(bData(:, stdcol.fileNum));

for f = 1 : numel(filesHere)

    fileMat = bData(bData(:, stdcol.fileNum) == filesHere(f), :);
    consTrials = (1:size(fileMat, 1));
    fileMat(:, stdcol.trial) = consTrials';

    if numel(consTrials) < params.minTrials
        continue
    end

    keepData = [keepData; fileMat];

end

% ---- Plot stim choice (A, B or C) on same axes, per file (day) in the
% aggregated data
left = 2.0;
bottom = 2.0;
width = 36.0;
height = 6.0;
trialStart = 0;
% trialStop = 600;
trialStop = size(bData, 1);

filesHere = unique(keepData(:, stdcol.fileNum));

for f = 1 : numel(filesHere)
    thisFile = keepData(keepData(:, stdcol.fileNum) == filesHere(f), :);

    % --- RUN BECKET'S HMM CODE
    [states,stateProbs,LL,nParams,Tall,Eall] = find3States(thisFile(:, stdcol.choseStim)');

    state1 = (states(:) == 1);
    state2 = (states(:) == 2);
    state3 = (states(:) == 3);
    state4 = (states(:) == 4);

    explore = (states(:) == 1);
    exploit = (states(:) ~= 1);

    % --- shift explore/exploit values up for plotting with choices on same axes
    explore = explore + 3.0;
    exploit = exploit + 3.0;

    % --- PLOT explore/exploit
    figure;
    pExplore = plot(explore);
    pExplore.Color = "magenta";
    pExplore.LineWidth = 1.5;
    hold on;
    pExploit = plot(exploit);
    pExploit.Color = "black";
    pExploit.LineWidth = 1.5;

    % --- ADD choice L, R, U (left, right, up)
    plotL = plot(thisFile(:, stdcol.choseLeft) + 1.5);
    plotL.Color = [0.4940 0.1840 0.5560];  % purple
    plotL.LineWidth = 1.5;

    plotR = plot(thisFile(:, stdcol.choseRight) + 1.5);
    plotR.Color = [0.9290 0.6940 0.1250];  % orange
    plotR.LineWidth = 1.5;

    plotR = plot(thisFile(:, stdcol.choseUp) + 1.5);
    plotR.Color = [0 0.4470 0.7410];  % blue
    plotR.LineWidth = 1.5;
    
    % --- ADD choice A, B, C (greenpentagon, bluetriangle, orangerectangle)
    plotA = plot(thisFile(:, stdcol.choseA));
    plotA.Color = "green";
    plotA.LineWidth = 1.5;

    hold on;
    plotB = plot(thisFile(:, stdcol.choseB));
    plotB.Color = "blue";
    plotB.LineWidth = 1.5;

    plotC = plot(thisFile(:, stdcol.choseC));
    plotC.Color = [1 0.6 0];  % orange
    plotC.LineWidth = 1.5;

    % --- add title, use cell array for multiple lines
    title({"STATE (top) Explore=Magenta Exploit=Black", "DIRECTION (middle) chose Left=Purple, Right=Orange, Up=Dk Blue", "OBJECT (bottom) chose A=Green(pentagon) B=Blue(triangle) C=Orange(rectangle)"});

    % reformat plot
    axis([trialStart, trialStop, -0.5, 5.0]);  %  reset ranges for x and y axes
    set(gca, 'Units', 'centimeters');
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontSize', 9);
    set(gca, 'FontSmoothing', 'off');
    set(gca, 'TickDir', 'out');                     %  switch side of axis for tick marks
    set(gca, 'Box', 'off');
    set(gca, 'Position', [left bottom width height]);
    set(gca, 'TickLength', [0.01 0.01]);
    set(gca, 'xTick', trialStart:20:trialStop);

end

% --- plot response probability as a function of reward probability
left = 2.0;
bottom = 2.0;
width = 4.0;
height = 4.0;
figure
hist(keepData(:, stdcol.choseProb));
set(gca, 'Units', 'centimeters');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', 9);
set(gca, 'FontSmoothing', 'off');
set(gca, 'TickDir', 'out');                     %  switch side of axis for tick marks
set(gca, 'Box', 'off');
set(gca, 'Position', [left bottom width height]);
set(gca, 'TickLength', [0.03 0.03]);
set(gca, 'xTick', 0:0.1:1);
set(gca, 'yTick', 0:250:1500);



bob = 1;

return;

end

% TO-DO: save data to outfile?
