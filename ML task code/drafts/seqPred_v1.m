% seqPred task code

% BASIC FRAMEWORK
% 1. Replace single Gabor cue with cue sequence
% 2. Each cue is a doublet, a pair of Gabors in which each member of the
% pair is equally associated with A and B cues.  Present Gabors in each
% doublet at timings consistent with STDP window.  Only way to learn
% behavioral significance of the cue is to learn the stimulus association
% at some level in the brain.  This gives us access to NMDAR mediated
% learning
% 3. Cue sequence is a minimum of 2 doublets
% 4. Vary predictability/surprise of the cues to engage variable sequence
% prediction error signals.
% 5. Vary reward prediction error associated with each cue sequence
% 6. Dissociate sequence prediction error and reward prediction error
% 7. Fit model to performance to identify separable influence of RPE and
% SPE on choice probability
% 8. Learning should be fastest for combinations of stimulus conditions
% that recruit NMDA activation just before DA activation.
% 9. Test prediction that working memory only engaged when cue 1 predicts
% cue 2 (or modifies its meaning).
% 10. For response, try a single target, and look for RT effects showing
% prediction of whether the response target will appear left or right
% 11. Alternative response mechanism, 2 targets appear, forced choice read
% out sequence explicitly

% TODO:
% 1. Use ImageChanger to present a sequence of Gabors for the cue rather
% than a single Gabor
% 2. Associate different cue sequences to A and B
% 3. See if humans can learn this
% 4. Modify stimulus timing and reward payoff to find training effects

% IDEAS FOR DEVELOPMENT:

% STIMULI: Each cue is a pair of stimuli.  Stimuli will be jpegs, so gabors, 
% dots, pictures, as desired. The order and SOA of stimulus presentation 
% in each pair is varied according to DA Leopold 2012 paper showing face 
% perception training using STDP stimulus timing in humans. Need 10 ms
% increments, so need graphics to run at 100 Hz.  Will need photodiode 
% signal to confirm stimulus onset timing for this as the stimulus timing 
% accuracy is critical.  Will need to count stimulus durations in screen
% frames.
% - NEURAL SIGNALS.  We are seeking neural signals that reflect state
% abstracted from stimulus features.  This requires that multiple
% stimuli evoke the same neural response. This can be achieved by how
% individual gabors are combined into pairs, and/or how pairs of gabors are
% combined into A and B categories (categorization is already a feature of
% TOPX), or how sequences of gabors are combined into A and B categories.
% State signals also need to be abstracted from response direction
% (options for how to do that are considered below).
% So this experiment can examine how RL and Hebb are used to group stimuli
% into pairs (association), groups (catgories), and temporal structures
% (sequences).  The limiting factor will be what monkeys can learn in 300
% trials. 
% - DATA STRUCTURE FOR STIMULUS CONTROL: Structure array, each element one
% trial.  Top level elements specifies trial level variables. Cue (A/B), 
% response target, and the like. This top level contains another structure
% array, each element is one stimulus pair. This level contains pair level
% variables, stimulus locations, timings, identities (the name of the jpg
% file to call).

% STEP 1: WRITE TRIAL STACK, specifying stimulus pairs, categories, and
% sequences, and response contingencies.


% CODE PLANNING:
% --- Data structures needed:
% - Each cue is going to be a sequence of stimulus pairs
% - Stimuli will be Gabors (for now).  Ideas is that although
% - The condition number will specify the sequence

% -------------------------------------------------------------------------
% ----------------- CUE/PROBE and RESPONSE LOCATIONS ----------------------
% -------------------------------------------------------------------------

% --- SET CUE/PROBE LOCATIONS
% X,Y degree coordinates for human stimulus locations from
% Michael-Paul. These locations are important as EEG components are
% location specific
% proper stimulus positions: -3.46, -2; 3.46, -2
cuePos = [0 0];
probePos = [0 0];

% --- SET RESPONSE DIRECTION
LEFT = 1;
RIGHT = 2;
leftTarg = [-9.5, 0];
rightTarg = [9.5, 0];

if TrialRecord.CurrentCondition == 1 %AX trial
    correctTarg = leftTarg;
    incorrectTarg = rightTarg;
    strCorrectTarg = 'leftTarg';
    correctDir = LEFT;
    incorrectDir = RIGHT;
else % all other trial types
    correctTarg = rightTarg;
    incorrectTarg = leftTarg;
    strCorrectTarg = 'rightTarg';
    correctDir = RIGHT;
    incorrectDir = LEFT;
end

% -------------------------------------------------------------------------
% ---------------------- TASK CONTROL SWITCHES ----------------------------
% -------------------------------------------------------------------------

% --- Enable cue sequence
cueSeq = false;

% --- Display joystick
% This will display the joystick cursor, but for both the experimenter and
% subject screen. Not sure there's a way to only display to experimenter
% screen, but I think the joystick cursor should show in replay.
showcursor(false);

% --- Multiple hits
% require that 2-n correct trials are performed in a row before delivering
% reward drops equal to the number of successive trials on the last trial.
% Fixation errors do not increase or decrease the counter
multipleHits = true;
numHits = 4;
rewCorrect = true;  % dispenses 1 small drop of juice with every correct response, but keeps the "jackpot" for MH

% --- Extra time after jackpot
% Gives a longer ITI following MH large "jackpot" reward to give time to
% drink juice and hopefully prevent ignore/error on trial immediately
% following
jackpotITI = true;
jackpotTime = 3500;

% --- Multiple errors
% Counts the number of errors obtained in the past n trials. If the number
% of errors occurs within the counter, will give a penalty of increased ITI
% and reset. If the counter expires without detecting the number of errors,
% all resets. This has errors but idk how to make it better?
multipleErrors = true;
numErrors = 3;  % number of errors needed to trigger
multipleErrorsCounter = 5;  % trial counter/window to track errors within - will reset if this number is exceeded
multipleErrorsITI = 10000;   % 10 seconds??? idk

% --- Random reward sizes
% Has a random chance of giving a large or very large reward (more drops).
% NOTE: I figured it wouldn't make sense to run both multiple hits and
% random reward size at the same time, so ideally you will pick one or the
% other. The code checks for multipleHits first, then rndNumDrops, so
% multipleHits = true will override this.
rndNumDrops = false;

% --- Differential reward (side bias training)
% With the rndNumDrops, adjusts the base reward sizes to give higher reward
% for left and right choices
diffRew = false;

% --- Make a fake ITI as a final scene to give more time for manual
% rewarding
fakeITI = false;

% --- Randomize isi and iti to match human imaging experiments
rndTiming = true;

% --- Include a tone as a secondary feedback measure
toneFeedback = true;

% --- Control number of conditions and trials
trialSet = 'cond8_seqPred';

% Options: 'cond36_trials480', 'cond36_trials400', 'cond36_trials300',
% 'cond36_danEzPrep', 'cond36_danMidPrep', 'cond36_danHardPrep', 'cond36_equalLR',
% 'cond36_moreBX', 'cond36_AXBXonly', 'cond36_goodAXBXonly', 'cond36_equalLR_goodBXonly',
% 'cond52_trials770', 'cond36_test'
if TrialRecord.CurrentTrialNumber == 1
    [condAra, condAraLabel, trialAra, numConds] = seqPred_conditionsSetup(trialSet);
    TrialRecord.User.condAra = condAra;
    bhv_variable('condAra', condAra);
    TrialRecord.User.condAraLabel = condAraLabel;
    bhv_variable('condAraLabel', condAraLabel);
    TrialRecord.User.masterTrialAra = trialAra;
    bhv_variable('masterTrialAra', trialAra);
    TrialRecord.User.trialsLeft = trialAra;
    TrialRecord.User.numConds = numConds;
    bhv_variable('numConds', numConds);
end

% -------------------------------------------------------------------------
% --------------------------- SCENE TIMING --------------------------------
% -------------------------------------------------------------------------
pretrial_time = 750;                    % baseline neural activity before trial
precue_eyejoy_waitTime = 1000;          % Time allowed to acquire eye and joystick fixation
precue_eyejoy_holdTime = 300;           % 300 Time required to hold center eye and joystick at screen center before cue
cue_eyejoy_waitTime = 0;                % waitTime is 0 because eye and joystick are already on central target from prior scene
cue_eyejoy_holdTime = 250;              % CUE DURATION: Time required to hold eye and joystick fixation at center while cue appears. % was 1000, needs to be 250?

probe_dur = 250;                    % PROBE DURATION
afterProbe = 2750;                  % Time of empty display after probe disappears, while joy response can still be made
probe_eye_waitTime = 0;              % waitTime is 0 because eye is already on central target from prior scene
probe_eye_holdTime = 3000;            % maintain eye fix for entire probe scene
probeResp_joy_waitTime = 3000;          % Time allowed to make post-probe response to one of two targets (MultiTarget)
probeResp_joy_holdTime = 75;            % Time required to hold chosen peripheral target
postResp_joy_waitTime = 2000;           % Time to get joy back to center
postResp_joy_holdTime = 75;         % Time required to hold center joystick fixation after probe response and before feedback

beforeFeedback = 250;                   % Time in ms before feedback ring
feedbackTime = 100;                   % Time in ms of feedback ring
afterFeedback = 150;                   % Time in ms after feedback ring
feedback_eyejoy_waitTime = 0;           % waitTime is 0 because eye and joystick are already on central target from prior scene
feedback_eyejoy_holdTime = beforeFeedback + feedbackTime + afterFeedback;         % TOTAL FEEDBACK DURATION: Time required to hold eye and joystick fixation at center while feedback ring appears.

% --- Overwrite default isi and iti times if randomization enabled
if fakeITI
    fakeITIwaitTime = 0; % hopefully joy already centered?
    fakeITIholdTime = 2200;
    isiBase = 700;                          % Base time for ISI randomization
    isiTime = isiBase + randi(3)*100;       % Shorter randomized ISI between 800-1000 ms
    itiTime = randi(11)*100;                % ITI: Randomized ITI between 2300-3300 ms total
elseif rndTiming
    isiBase = 700;                          % Base time for ISI randomization
    %isiTime = isiBase + randi(7)*100;       % ISI: Randomized ISI between 800-1400 ms
    isiTime = isiBase + randi(3)*100;       % Shorter randomized ISI between 800-1000 ms
    itiBase = 1200;                         % Base time for ITI randomization
    itiTime = itiBase + randi(11)*100;      % ITI: Randomized ITI between 2300-3300 ms
else
    isiTime = 1000;
    itiTime = 1500;
    itiPenaltyTime = 2000;                  % penalty to add to ITI if post-reward fixation is broken
end
set_iti(itiTime);                      % Overrides iti value from the main menu


% -------------------------------------------------------------------------
% ---------------------- BEHAVIORAL EVENT CODES----------------------------
% -------------------------------------------------------------------------
% STRATEGY FOR BEHAVIORAL EVENT LOGGING:
% We are presently using 6 different methods for event logging.
% 1) run_scene(adapter, event code): writes event at first screen flip
% 2) OnOffMarker(adapter).onMarker: writes event when adapter conditions satisfied
% 3) goodmonkey(duration,... 'EventMarker', [code, code]): codes for drops
% 4) idle(dur, [R G B], eventcodes): logging trial info
% 5) ImageChanger()
% 6) eventmarker()

% Basically, we use run_scene() to log stimulus on/off, and OnOffMarker to
% log eye or joystick events.  This seems to be working (as of v3_5).

% other ways to mark events (not in use)
% set_frame_event(); could be used to mark a specific frame count

% -------------------------- EVENT SEQUENCE -------------------------------
% We will attempt to write 8-bit words near the start of each trial to
% save ML trial and condition numbers to the SpkeGadgets data stream
% ML_TRL_LOW = [];        % 1-256
% ML_TRL_HIGH = [];       % 1-256
% ML_COND_NUM = [];       % 1-56

% --- this is the full set of behavioral event codes we will write to the
% SpikeGadgets data stream and ML outfile
preTrial_eventCode = 10;  % NOT USED DELETE
fixTargOn_eventCode = 11;
gazeFixAcq_eventCode = 12;
joyFixAcq_eventCode = 13; % Not too informative as self-centering joystick, but no harm
% cueOnEventCode = 20-27, controlled by condition number below
cueOff_eventCode = 30;
% probeOnEventCode = 40-46, controlled by condition number below
probeOff_eventCode = 50;
joyOut_eventCode = 60;
leftCorrResp_eventCode = 61;
rightCorrResp_eventCode = 62;
leftErrResp_eventCode = 63;
rightErrResp_eventCode = 64;
retStart_eventCode = 65;
joyBack_eventCode = 66;
feedbackStart_eventCode = 70;
corrFeedback_eventCode = 71;
errFeedback_eventCode = 72;
feedbackOff_eventCode = 73;
rewDrop1_eventCode = 81;
rewDrop2_eventCode = 82;
rewDrop3_eventCode = 83;
rewDrop4_eventCode = 84;
rewDrop5_eventCode = 85;
rewDrop6_eventCode = 86;
brokeGazeFix_eventCode = 90;
brokeJoyFix_eventCode = 91;
brokeBothFix_eventCode = 92;
neverFix_eventCode = 93;
noJoy_eventCode = 94;

% bhv_code(...
%     10, 'fixOn', ...                    % beginning eye/joy fixation scene
%     20, 'eyeFixAcq', ...                % acquire eye fixation
%     30, 'joyFixAcq', ...                % acquire joy fixation
%     40, 'cueOn',...                     % cue onset
%     50, 'isiStart', ...                 % start of interstimulus interval period
%     60, 'probeOn',...                  % probe onset, possibly redundant w/ sc4_fliptime
%     70, 'probeRespStart', ...          % end of sc6 wtHold, when probe turns off
%     80, 'probeResp', ...               % one of two choice targets acquired
%     90, 'probeReturnStart', ...        % beginning of probe return period
%     100, 'probeReturn', ...             % probeReturn joystick movement made
%     110, 'feedbackStart', ...           % beginning of post-probeReturn fixation period, no intra-scene events
%     120, 'correctFeedbackOn', ...       % display correct feedback ring (green)
%     130, 'incorrectFeedbackOn', ...     % display incorrect feedback ring (red)
%     140, 'feedbackOff',...              % feedback ring turned off
%     150, 'reward_1', ...                % delivery of reward drop #1 by GoodMonkey
%     160, 'reward_2', ...                % delivery of reward drop #2 by GoodMonkey
%     170, 'fakeITI');                   % fake ITI scene start


% -------------------------------------------------------------------------
% -------------------- ACTIVATE SIM MODE SETTINGS -------------------------
% -------------------------------------------------------------------------
% simML flag sets parameters for running in simulation mode for debugging

simML = false;   % should be false for training/recording
dbstop if error;

% -------------------------------------------------------------------------
% ------------------- INIT TRIAL FLAGS AND COUNTERS -----------------------
% -------------------------------------------------------------------------
% --- These variables track behavioral events for trial control

% flag to call 'return' to end trial prematurely if error
abortTrial = false;

% flag for determining trialerror if all scenes completed successfully
totalTrialSuccess = 0;

% flag to determine if probe response was successfully completed (out and
% back)
probeRespCompleted = false;

global successiveHits
global successiveErrors
global trialCounter

if TrialRecord.CurrentTrialNumber == 1
    successiveHits = 0;
    successiveErrors = 0;
    trialCounter = 0;
end

% -------------------------------------------------------------------------
% --------------------------- CONSTANTS -----------------------------------
% -------------------------------------------------------------------------
% Task objects. Numbers are column indices in the conditions *.txt file and
% control how ML accesses stimulus information from the conditions file. We
% are using this mostly to control stimulus positions.  Stimuli identities
% are controlled by setting the filenames of *.png files to read from disk
taskObj_fix = 1;

% Eye and joy fixation window (in degrees)
eye_radius = 4;
joy_radius = 3;

% reward sizes
if rndNumDrops && diffRew
    chanceHigh = 0.15; % I can't do math, does this make sense?
    chanceVHigh = 0.05;

    rightRewDur = 100;
    rightNumDrops = 1;

    leftRewDur = 100;
    leftNumDrops = 5;

    highRewDur = 100;
    highNumDrops = 4;

    vHighRewDur = 100;
    vHighNumDrops = 6;
elseif rndNumDrops
    chanceHigh = 0.15; % I can't do math, does this make sense?
    chanceVHigh = 0.05;

    normRewDur = 70;
    normNumDrops = 2;

    highRewDur = 100;
    highNumDrops = 3;

    vHighRewDur = 200;
    vHighNumDrops = 5;
else
    normRewDur = 250;   % 235 by 5
    normNumDrops = 5;
    smRewDur = 65;
    smNumDrops = 1;
end

correctFeedbackImg = 'green_ring.png';
incorrectFeedbackImg = 'red_ring.png';

% -------------------------------------------------------------------------
% ---------------------- TRIAL OUTCOME VARIABLES --------------------------
% -------------------------------------------------------------------------
% --- these variables save behavioral events to the outfile

% trialResult is a string that should take on one of the following values
% 'null' (initialized)
% 'noEyeJoyFix'
% 'breakFix_eye'
% 'breakFix_joy'
% 'breakFix_eye_joy'
% 'noResponse'
% 'correctChoice'
% 'incorrectChoice'
trialResult = 'null';

% resultScene is the scene in which the result occurred, and should take
% on one of the following values
% 'null' (initialization)
% 'preCue'
% 'cue'
% 'post_cue_resp'
% 'post_cue_return'
% 'isi'
% 'probe'
% 'post_probe_resp'
% 'post_probe_return'
% 'post_probe_fix'
% 'feedback'
% 'reward'
% 'post_reward_fix'
resultScene = 'null';

% -------------------------------------------------------------------------
% ----------------- SIM MODE SETTINGS (for debugging) ---------------------
% -------------------------------------------------------------------------
if simML
    showcursor(true);  % for running in simulation mode/debugging
    joy_radius = 4;
end

% -------------------------------------------------------------------------
% ------------------------ CHECK HARDWARE ---------------------------------
% -------------------------------------------------------------------------

% check eye input is detected
if ~exist('eye_','var'), error('This task requires eye signal input. Please set it up or try the simulation mode.'); end

% set hotkey for exit
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Note for manual reward: during task, [R] is preprogrammed as a manual
% reward hotkey and will dispense the amount of reward specified in the
% section of the main menu
% [R] key: Delivers a manual reward (initial pulse duration: 100 ms, juiceline: as determined in Reward of the main menu).

% -------------------------------------------------------------------------
% -------- SELECT CUE AND PROBE BASED ON TRIAL CONDITION NUMBER -----------
% -------------------------------------------------------------------------
% determine the filename of the correct cue image file based on the
% CurrentCondition number. CurrentCondition is the condition number
% drawn at random by MonkeyLogic at trial start corresponding to one of
% the lines in the conditions txt file

if contains(TrialRecord.DataFile, 'goodAXBXonly')
    % you will need to change this every time you update the Bs to be
    % included, you're welcome :)
    switch TrialRecord.CurrentCondition
        case {1}  %A cue
            cueStr = 'A';
            cueID = 0;
            cue_pic = 'calA_100_2p50c.png';
            cueOn_eventCode = 20;
        case {2}  %B1 cue
            cueStr = 'B1';
            cueID = 1;
            cue_pic = 'calB_010_1p0c.png';
            cueOn_eventCode = 21;
        case {3}  %B2 cue
            cueStr = 'B2';
            cueID = 2;
            cue_pic = 'calB_020_1p0c.png';
            cueOn_eventCode = 22;
        case {4}  %B4 cue
            cueStr = 'B4';
            cueID = 4;
            cue_pic = 'calB_000_1p0c.png';
            cueOn_eventCode = 24;
    end

    switch TrialRecord.CurrentCondition
        case {1, 2, 3, 4}        %X probe
            probeStr = 'X';
            probeID = 0;
            probe_pic = 'calX_055_1p20c.png';
            probeOn_eventCode = 40;
    end

    % set up numerical ID for trial type
    % 0 = AX, 1 = AY, 2 = BX, 3 = BY
    if cueID == 0 && probeID == 0
        % cue is A and probe is X
        trialTypeID = 0;
    else % it's a BX in this mix
        trialTypeID = 2;
    end

elseif contains(TrialRecord.DataFile, 'goodBXonly')
    switch TrialRecord.CurrentCondition
        case {1, 2, 3, 4, 5, 6}        %A cue
            cueStr = 'A';
            cueID = 0;
            cue_pic = 'calA_100_2p50c.png';
            cueOn_eventCode = 20;
        case {7, 10, 11, 12, 13, 14}  %B1 cue
            cueStr = 'B1';
            cueID = 1;
            cue_pic = 'calB_010_1p0c.png';
            cueOn_eventCode = 21;
        case {8, 15, 16, 17, 18, 19}  %B2 cue
            cueStr = 'B2';
            cueID = 2;
            cue_pic = 'calB_020_1p0c.png';
            cueOn_eventCode = 22;
        case {9, 20, 21, 22, 23, 24}  %B4 cue
            cueStr = 'B4';
            cueID = 4;
            cue_pic = 'calB_000_1p0c.png';
            cueOn_eventCode = 24;
    end
    switch TrialRecord.CurrentCondition
        case {1, 7, 8, 9} %X probe
            probeStr = 'X';
            probeID = 0;
            probe_pic = 'calX_055_1p20c.png';
            probeOn_eventCode = 40;
        case {2, 10, 15, 20} %Y1 probe
            probeStr = 'Y1';
            probeID = 1;
            probe_pic = 'calY_024_0p60c.png';
            probeOn_eventCode = 41;
        case {3, 11, 16, 21} %Y2 probe
            probeStr = 'Y2';
            probeID = 2;
            probe_pic = 'calY_032_0p50c.png';
            probeOn_eventCode = 42;
        case {4, 12, 17, 22} %Y3 probe
            probeStr = 'Y3';
            probeID = 3;
            probe_pic = 'calY_040_0p40c.png';
            probeOn_eventCode = 43;
        case {5, 13, 18, 23} %Y4 probe
            probeStr = 'Y4';
            probeID = 4;
            probe_pic = 'calY_070_0p40c.png';
            probeOn_eventCode = 44;
        case {6, 14, 19, 24} %Y5 probe
            probeStr = 'Y5';
            probeID = 5;
            probe_pic = 'calY_078_0p50c.png';
            probeOn_eventCode = 45;

    end

    % set up numerical ID for trial type
    % 0 = AX, 1 = AY, 2 = BX, 3 = BY
    if cueID == 0 && probeID == 0
        % cue is A and probe is X
        trialTypeID = 0;
    elseif cueID == 0 && probeID ~= 0
        % cue is A and probe is not X (is Y)
        trialTypeID = 1;
    elseif cueID ~= 0 && probeID == 0
        % cue is not A (is B) and probe is X
        trialTypeID = 2;
    else
        % cue is not A (is B) and probe is not X (is Y)
        trialTypeID = 3;
    end

else
    switch TrialRecord.CurrentCondition
        case {1, 2, 3, 4, 5, 6}        %A cue
            cueStr = 'A';
            cueID = 0;
            cue_pic = 'calA_100_2p50c.png';
            cueOn_eventCode = 20;
        case {7, 12, 13, 14, 15, 16}  %B1 cue
            cueStr = 'B1';
            cueID = 1;
            cue_pic = 'calB_010_1p0c.png';
            cueOn_eventCode = 21;
        case {8, 17, 18, 19, 20, 21}  %B2 cue
            cueStr = 'B2';
            cueID = 2;
            cue_pic = 'calB_020_1p0c.png';
            cueOn_eventCode = 22;
        case {9, 22, 23, 24, 25, 26}  %B3 cue
            cueStr = 'B3';
            cueID = 3;
            cue_pic = 'calB_030_1p0c.png';
            cueOn_eventCode = 23;
        case {10, 27, 28, 29, 30, 31}  %B4 cue
            cueStr = 'B4';
            cueID = 4;
            cue_pic = 'calB_000_1p0c.png';
            cueOn_eventCode = 24;
        case {11, 32, 33, 34, 35, 36}  %B5 cue
            cueStr = 'B5';
            cueID = 5;
            cue_pic = 'calB_330_1p0c.png';
            cueOn_eventCode = 25;
    end

    % determine the filename of the correct probe image file based
    % on the CurrentCondition number

    switch TrialRecord.CurrentCondition
        case {1, 7, 8, 9, 10, 11} %X probe
            probeStr = 'X';
            probeID = 0;
            probe_pic = 'calX_055_1p20c.png';
            probeOn_eventCode = 40;
        case {2, 12, 17, 22, 27, 32} %Y1 probe
            probeStr = 'Y1';
            probeID = 1;
            probe_pic = 'calY_024_0p60c.png';
            probeOn_eventCode = 41;
        case {3, 13, 18, 23, 28, 33} %Y2 probe
            probeStr = 'Y2';
            probeID = 2;
            probe_pic = 'calY_032_0p50c.png';
            probeOn_eventCode = 42;
        case {4, 14, 19, 24, 29, 34} %Y3 probe
            probeStr = 'Y3';
            probeID = 3;
            probe_pic = 'calY_040_0p40c.png';
            probeOn_eventCode = 43;
        case {5, 15, 20, 25, 30, 35} %Y4 probe
            probeStr = 'Y4';
            probeID = 4;
            probe_pic = 'calY_070_0p40c.png';
            probeOn_eventCode = 44;
        case {6, 16, 21, 26, 31, 36} %Y5 probe
            probeStr = 'Y5';
            probeID = 5;
            probe_pic = 'calY_078_0p50c.png';
            probeOn_eventCode = 45;

    end

    % set up numerical ID for trial type
    % 0 = AX, 1 = AY, 2 = BX, 3 = BY
    if cueID == 0 && probeID == 0
        % cue is A and probe is X
        trialTypeID = 0;
    elseif cueID == 0 && probeID ~= 0
        % cue is A and probe is not X (is Y)
        trialTypeID = 1;
    elseif cueID ~= 0 && probeID == 0
        % cue is not A (is B) and probe is X
        trialTypeID = 2;
    else
        % cue is not A (is B) and probe is not X (is Y)
        trialTypeID = 3;
    end
end

% -------------------------------------------------------------------------
% ---------------------- BUILD AND RUN SCENES -----------------------------
% -------------------------------------------------------------------------
% clear user screen
dashboard(1,sprintf('')); % Trial condition number for this trial
dashboard(2,sprintf('')); % Cue and probe stimuli for this trial
% output to user screen
dashboard(1,sprintf('Trial condition: %.1f, Block: %.0f, Trl in block: %.0f', ...
    TrialRecord.CurrentCondition, TrialRecord.CurrentBlock, TrialRecord.CurrentTrialWithinBlock));
dashboard(2,sprintf('Cue: %s, Probe: %s', cueStr, probeStr));


% -------------------------------------------------------------------------
% --- PRETRIAL period
% provide some time before trial start bounded by events to examine
% pretrial neural activity patterns. Write ML condition and trial numbers
% to behavioral events, including output to NI DAQ

% idle(duration, [RGB], eventcodes) changes background color, has timer
% built in, and writes event codes. Empty brackets for screen color leaves
% color unchanged.

% we want to write event codes to DAQ to capture ML trial number and condition
% number in SpikeGadgets datafile
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);

% >>> SAVE BEHAVIORAL EVENT
% --- write three eventcodes, each an 8-bit word, to DAQ at trial start that reflect ML condition
% number and trial number
idle(pretrial_time, [], [TrialRecord.CurrentCondition mult256 mod256]);

% -------------------------------------------------------------------------
% SCENE 1: PRECUE FIX
% Direct eye and joy positions to target at screen center

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(4,sprintf('')); % Scene behavioral outcome
dashboard(5,sprintf('')); % Misc information
dashboard(6,sprintf('')); % Misc information
dashboard(7,sprintf('')); % Misc information

dashboard(3, sprintf('Running scene 1: PRECUE FIX'));

% --- BUILD ADAPTOR CHAINS
% SingleTarget()
% Success: true while the position of the XY signal is within the window,
% false otherwise
% Stop: When success becomes true
% Input properties: TaskObj# or 2-element vector [X,Y], in degrees
% Output properties: Time (when signal enters window)

% Present fixation target and establish XY position window for eye
sc1_eyeCenter = SingleTarget(eye_);
sc1_eyeCenter.Target = taskObj_fix;
sc1_eyeCenter.Threshold = eye_radius;

% Mark behavioral event: eye fixation
% OnOffMarker()
% Success: true when the child adapter's Success is true
% Stop: when the child adapter stops
% Input propertie: OnMarker, event code to send when child adapter state
% changes from false to true. OffMarker, event code to send when child
% adapter state changes from true to false. ChildProperty, property of the
% child adapter to monitor.  'Success' by default.
% INTENDED BEHAVIOR: Send EventMarker when eye fixation is acquired and
% Success property goes from false to true
sc1_eyeCenter_oom = OnOffMarker(sc1_eyeCenter);
sc1_eyeCenter_oom.OnMarker = gazeFixAcq_eventCode; %'eyeFixAcq'
sc1_eyeCenter_oom.ChildProperty = 'Success';

% Present fixation target and establish XY position window for joy
sc1_joyCenter = SingleTarget(joy_);
sc1_joyCenter.Target = taskObj_fix;
sc1_joyCenter.Threshold = joy_radius;

% Mark behavioral event: joy fixation
sc1_joyCenter_oom = OnOffMarker(sc1_joyCenter);
sc1_joyCenter_oom.OnMarker = joyFixAcq_eventCode; %'joyFixAcq'
sc1_joyCenter_oom.ChildProperty = 'Success';

% NOTE: scene can start recording eye and joystick position before the
% first screen displays, depending on the timing of the screen refresh. If
% the eye and/or joy are already at screen center before the first screen
% is shown with the fixation target, event codes 20 (acqFix_eye) and 30
% (acqFix_joy) will be recorded before event 10 (fixOn).

% AndAdaptor()
% Success: true when all child chains' Success property becomes true
% Stop: When Success becomes true
% INTENDED BEHAVIOR: the combined eye/joy SingleTarget will become
% true when both eye and joy are within their respective windows
sc1_eyejoy = AndAdapter(sc1_eyeCenter_oom);
sc1_eyejoy.add(sc1_joyCenter_oom);

% WaitThenHold()
% Success: true if the Success of the child adapter becomes true within
% WaitTime AND stays true for HoldTime, false, until then.
% Stop: When Success becomes true OR when WaitTime is over without any
% fixation attempt OR when the acquried fixation is broken before HoldTime
% passes
% INTENDED BEHAVIOR: the Success condition of the adaptor chain will become
% true IF eye and joy enter their respective windows in WaitTime AND eye
% and joy remain in their windows for HoldTime.
sc1_wtHold = WaitThenHold(sc1_eyejoy);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc1_wtHold.WaitTime = precue_eyejoy_waitTime;
sc1_wtHold.HoldTime = precue_eyejoy_holdTime;

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_wtHold, taskObj_fix);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, fixTargOn_eventCode); %'fixOn'

% --- CHECK BEHAVIORAL OUTCOMES
% Note: this status checking structure copied from ML documentation on
% WaitThenHold()
if sc1_wtHold.Success
    dashboard(4, 'PRECUE FIX sc1_wtHold: Success');
elseif sc1_wtHold.Waiting
    idle(0, [], neverFix_eventCode);
    trialerror(4); %'No fixation'
    abortTrial = true;
    trialResult = 'noEyeJoyFix';
    resultScene = 'preCue';
    dashboard(4, 'PRECUE FIX sc1_wtHold: Waiting');
else  % fixation acquired but broken
    trialerror(3);    %'Break fixation'
    abortTrial = true;
    dashboard(4, 'PRECUE FIX sc1_wtHold: Broken fixation');
    % figure out which fixation was broken, eye or joy, by checking last
    % sampled value of Success property at time that adapter chain
    % terminated
    if sc1_eyeCenter.Success && ~sc1_joyCenter.Success
        dashboard(5, 'sc1_eyeCenter: Success');
        dashboard(6, 'sc1_joyCenter: Fail');
        trialResult = 'breakFix_joy';
        resultScene = 'preCue';
        idle(0, [], brokeJoyFix_eventCode);
    elseif ~sc1_eyeCenter.Success && sc1_joyCenter.Success
        dashboard(5, 'sc1_eyeCenter: Fail');
        dashboard(6, 'sc1_joyCenter: Success');
        trialResult = 'breakFix_eye';
        resultScene = 'preCue';
        idle(0, [], brokeGazeFix_eventCode);
    elseif ~sc1_eyeCenter.Success && ~sc1_joyCenter.Success % not likely, but possible
        dashboard(5, 'sc1_eyeCenter: Fail');
        dashboard(6, 'sc1_joyCenter: Fail');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'preCue';
        idle(0, [], brokeBothFix_eventCode);
    end
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', nan, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', nan, ...
        'probeReturnRT', nan, ...
        'probeRespChoice', nan, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% -------------------------------------------------------------------------
% SCENE 2: CUE
% Present cue during central eye and joy fixation.  No response allowed
% while cue is visible

if cueSeq
% clear scene output to user screen
    dashboard(3,sprintf('')); % clear first
    dashboard(4,sprintf('')); % Scene behavioral outcome
    dashboard(5,sprintf('')); % Misc information
    dashboard(6,sprintf('')); % Misc information

    dashboard(3, sprintf('Running scene 2: CUE SEQUENCE'));

    % --- BUILD ADAPTOR CHAINS
    % Present fixation target and establish XY position window for eye
    sc2_eyeCenter = SingleTarget(eye_);
    sc2_eyeCenter.Target = taskObj_fix;
    sc2_eyeCenter.Threshold = eye_radius;

    % Present fixation target and establish XY position window for joy
    sc2_joyCenter = SingleTarget(joy_);
    sc2_joyCenter.Target = taskObj_fix;
    sc2_joyCenter.Threshold = joy_radius;

    % AND eye and joy
    sc2_eyejoy = AndAdapter(sc2_eyeCenter);
    sc2_eyejoy.add(sc2_joyCenter);

    % pass eye AND joy to WaitThenHold
    sc2_wtHold = WaitThenHold(sc2_eyejoy);
    sc2_wtHold.WaitTime = cue_eyejoy_waitTime;
    sc2_wtHold.HoldTime = cue_eyejoy_holdTime;


    % Build the cue sequence
    img = ImageChanger();
    img.List

    % Present the cue stimulus
    % ImageGraphic()
    % Success: true when the child adapter's Success is true
    % Stop: when the child adapter stops
    % Input Properties: Position [X Y] in degs, Scale (1 by default), Angle
    % (rotation in degs), List An n-by-2, 3 or 4 matrix listing the stimuli to
    % be displayed.  1st col: image filename, 2nd col: image XY position, cols
    % 3-5 optional (see ML documentation), Trigger true or false, EventMarker
    % code to send when trigger activates
    % INTENDED BEHAVIOR: present the cue image by ImageGraphic.  Enable
    % triggered mode for ImageGraphic to allow EventMarker output.
    % ImageGraphic will fire when the child adapter state becomes true. Since
    % the child adapter is sc2_eyeCenter, and the Success state of this adapter
    % is true at the beginning of the scene (eyes are already on target),
    % ImageGraphic fires immediately.
%     sc2_cueImg = ImageGraphic(sc2_eyeCenter);
%     sc2_cueImg.List = { cue_pic, cuePos };

    % Concurrent()
    % Success: true when first chain succeeds
    % Stop: when the first chain stops
    % INTENDED BEHAVIOR: Concurrent() will run wtHold and image at the same
    % time but scene timing will depend on wtHold only, if this is the first
    % adaptor added.
    sc2_wtHold_cue = Concurrent(sc2_wtHold);
    sc2_wtHold_cue.add(sc2_cueImg);

    % --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
    scene2 = create_scene(sc2_wtHold_cue, taskObj_fix);
    scene2_start = run_scene(scene2, cueOn_eventCode);
    

else

    % clear scene output to user screen
    dashboard(3,sprintf('')); % clear first
    dashboard(4,sprintf('')); % Scene behavioral outcome
    dashboard(5,sprintf('')); % Misc information
    dashboard(6,sprintf('')); % Misc information

    dashboard(3, sprintf('Running scene 2: CUE'));

    % --- BUILD ADAPTOR CHAINS
    % Present fixation target and establish XY position window for eye
    sc2_eyeCenter = SingleTarget(eye_);
    sc2_eyeCenter.Target = taskObj_fix;
    sc2_eyeCenter.Threshold = eye_radius;

    % Present fixation target and establish XY position window for joy
    sc2_joyCenter = SingleTarget(joy_);
    sc2_joyCenter.Target = taskObj_fix;
    sc2_joyCenter.Threshold = joy_radius;

    % AND eye and joy
    sc2_eyejoy = AndAdapter(sc2_eyeCenter);
    sc2_eyejoy.add(sc2_joyCenter);

    % pass eye AND joy to WaitThenHold
    sc2_wtHold = WaitThenHold(sc2_eyejoy);
    sc2_wtHold.WaitTime = cue_eyejoy_waitTime;
    sc2_wtHold.HoldTime = cue_eyejoy_holdTime;

    % Present the cue stimulus
    % ImageGraphic()
    % Success: true when the child adapter's Success is true
    % Stop: when the child adapter stops
    % Input Properties: Position [X Y] in degs, Scale (1 by default), Angle
    % (rotation in degs), List An n-by-2, 3 or 4 matrix listing the stimuli to
    % be displayed.  1st col: image filename, 2nd col: image XY position, cols
    % 3-5 optional (see ML documentation), Trigger true or false, EventMarker
    % code to send when trigger activates
    % INTENDED BEHAVIOR: present the cue image by ImageGraphic.  Enable
    % triggered mode for ImageGraphic to allow EventMarker output.
    % ImageGraphic will fire when the child adapter state becomes true. Since
    % the child adapter is sc2_eyeCenter, and the Success state of this adapter
    % is true at the beginning of the scene (eyes are already on target),
    % ImageGraphic fires immediately.
    sc2_cueImg = ImageGraphic(sc2_eyeCenter);
    sc2_cueImg.List = { cue_pic, cuePos };

    % Concurrent()
    % Success: true when first chain succeeds
    % Stop: when the first chain stops
    % INTENDED BEHAVIOR: Concurrent() will run wtHold and image at the same
    % time but scene timing will depend on wtHold only, if this is the first
    % adaptor added.
    sc2_wtHold_cue = Concurrent(sc2_wtHold);
    sc2_wtHold_cue.add(sc2_cueImg);

    % --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
    scene2 = create_scene(sc2_wtHold_cue, taskObj_fix);
    scene2_start = run_scene(scene2, cueOn_eventCode);
end


% --- CHECK BEHAVIORAL OUTCOMES
if sc2_wtHold.Success
    dashboard(4, 'sc2_cueFix: Success');
elseif sc2_wtHold.Waiting
    trialerror(4);  %'No fixation'
    idle(0, [], neverFix_eventCode);
    abortTrial = true;
    trialResult = 'noEyeJoyFix';
    resultScene = 'cue';
    dashboard(4, 'sc2_wtHold: Waiting');
else  % fixation acquired but broken
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    dashboard(4, 'sc2_wtHold: Broken fixation');
    % figure out which fixation was broken, eye or joy
    if sc2_eyeCenter.Success && ~sc2_joyCenter.Success
        dashboard(5, 'sc2_eyeCenter: Success');
        dashboard(6, 'sc2_joyCenter: Fail');
        trialResult = 'breakFix_joy';
        resultScene = 'cue';
        idle(0, [], brokeJoyFix_eventCode);
    elseif ~sc2_eyeCenter.Success && sc2_joyCenter.Success
        dashboard(5, 'sc2_eyeCenter: Fail');
        dashboard(6, 'sc2_joyCenter: Success');
        trialResult = 'breakFix_eye';
        resultScene = 'cue';
        idle(0, [], brokeGazeFix_eventCode);
    elseif ~sc2_eyeCenter.Success && ~sc2_joyCenter.Success % not likely, but possible
        dashboard(5, 'sc2_eyeCenter: Fail');
        dashboard(6, 'sc2_joyCenter: Fail');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'cue';
        idle(0, [], brokeBothFix_eventCode);
    end
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', nan, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', nan, ...
        'probeReturnRT', nan, ...
        'probeRespChoice', nan, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% -------------------------------------------------------------------------
% SCENE 3: ISI
% maintain eye and joystick fixation at screen center after cue offset and
% before probe onset

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(4,sprintf('')); % Scene behavioral outcome
dashboard(5,sprintf('')); % Misc information
dashboard(6,sprintf('')); % Misc information
dashboard(7,sprintf('')); % Misc information

dashboard(3, sprintf('Running scene 3: ISI'));

% --- BUILD ADAPTOR CHAINS

% Present fixation target and establish XY position window for eye
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = eye_radius;

% Present fixation target and establish XY position window for joy
sc3_joyCenter = SingleTarget(joy_);
sc3_joyCenter.Target = taskObj_fix;
sc3_joyCenter.Threshold = joy_radius;

sc3_eyeANDjoy = AndAdapter(sc3_eyeCenter);
sc3_eyeANDjoy.add(sc3_joyCenter);

sc3_wtHold = WaitThenHold(sc3_eyeANDjoy);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc3_wtHold.WaitTime = 0;
sc3_wtHold.HoldTime = isiTime;

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_wtHold,taskObj_fix);
scene3_start = run_scene(scene3, cueOff_eventCode);

% --- CHECK BEHAVIORAL OUTCOMES
if sc3_wtHold.Success
    dashboard(4, 'sc3_wtHold: Success');
elseif sc3_wtHold.Waiting
    idle(0, [], neverFix_eventCode);
    trialerror(4);  %'No fixation'
    abortTrial = true;
    trialResult = 'noEyeJoyFix';
    resultScene = 'isi';
    dashboard(4, 'sc3_wtHold: Waiting');
else  % fixation acquired but broken

    trialerror(3);  %'Break fixation'
    abortTrial = true;
    dashboard(4, 'sc3_wtHold: Broken fixation');
    % figure out which fixation was broken, eye or joy, by checking last
    % sampled value of Success property at time that adapter chain
    % terminated
    if sc3_eyeCenter.Success && ~sc3_joyCenter.Success
        dashboard(5, 'sc3_eyeCenter: Success');
        dashboard(6, 'sc3_joyCenter: Fail');
        trialResult = 'breakFix_joy';
        resultScene = 'isi';
        idle(0, [], brokeJoyFix_eventCode);
    elseif ~sc3_eyeCenter.Success && sc3_joyCenter.Success
        dashboard(5, 'sc3_eyeCenter: Fail');
        dashboard(6, 'sc3_joyCenter: Success');
        trialResult = 'breakFix_eye';
        resultScene = 'isi';
        idle(0, [], brokeGazeFix_eventCode);
    elseif ~sc3_eyeCenter.Success && ~sc3_joyCenter.Success % not likely, but possible
        dashboard(5, 'sc3_eyeCenter: Fail');
        dashboard(6, 'sc3_joyCenter: Fail');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'isi';
        idle(0, [], brokeBothFix_eventCode);
    end
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', nan, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', nan, ...
        'probeReturnRT', nan, ...
        'probeRespChoice', nan, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% -------------------------------------------------------------------------
% SCENE 4: PROBE & RESPONSE
% Displaying probe with response window for joystick up. Probe will go away
% after 250 ms, joy will be able to respond for 3 s.

% clear scene output to user screen
dashboard(3,sprintf(''));
dashboard(4,sprintf(''));
dashboard(5,sprintf(''));
dashboard(6,sprintf(''));
dashboard(7,sprintf(''));

dashboard(3, sprintf('Running scene 4: PROBE'));

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc4_eyeCenter = SingleTarget(eye_);
sc4_eyeCenter.Target = taskObj_fix;
sc4_eyeCenter.Threshold = eye_radius;

% pass eye to WaitThenHold
sc4_wtHold = WaitThenHold(sc4_eyeCenter);
sc4_wtHold.WaitTime = probe_eye_waitTime;
sc4_wtHold.HoldTime = probe_eye_holdTime; % entire duration of scene

% Present the probe stimulus, and mark behavioral event
sc4_probeImg = ImageChanger(null_);
sc4_probeImg.List = {probe_pic, probePos, probe_dur, [];...
    [], [], afterProbe, probeOff_eventCode;};
sc4_probeImg.DurationUnit = 'msec';

% MultiTarget()
sc4_mTarg_joy = MultiTarget(joy_);
sc4_mTarg_joy.Target = [correctTarg; incorrectTarg];
% Note: this will end up as equal to 1 or 2! NOT the coordinates!
sc4_mTarg_joy.Threshold = joy_radius;
sc4_mTarg_joy.WaitTime = probeResp_joy_waitTime;
sc4_mTarg_joy.HoldTime = probeResp_joy_holdTime;

% Mark behavioral event: probeResp, when MultiTarget choice is acquired
sc4_mTarg_joy_oom = OnOffMarker(sc4_mTarg_joy);
sc4_mTarg_joy_oom.OffMarker = joyOut_eventCode;
% Mark event when waiting goes from true to false, start of joy
% fixation at selected MultiTarget choice
sc4_mTarg_joy_oom.ChildProperty = 'Waiting';

% AllContinue will be used to continue eye fix, probe image changer, and
% joy multitarget. It will stop once any one of these stops (hopefully, joy
% causing multitarget success).
sc4_probeFix = AllContinue(sc4_mTarg_joy_oom); % this will hopefully end scene when joy moves
sc4_probeFix.add(sc4_probeImg);
sc4_probeFix.add(sc4_wtHold);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
% scene6 will terminate when gaze hold at center is complete, hold time is
% 250 ms, which corresponds to probe duration
scene4 = create_scene(sc4_probeFix, taskObj_fix);
scene4_start = run_scene(scene4, probeOn_eventCode);

% --- CHECK BEHAVIORAL OUTCOMES
if sc4_mTarg_joy.Success % response made to one of two response windows, not nessarily the correct one
    rt = sc4_mTarg_joy.RT;
    probeRespRT = sc4_mTarg_joy.RT;
    if sc4_mTarg_joy.ChosenTarget == 1 % correct target
        successiveHits = successiveHits + 1;
        trialResult = 'correctChoice';
        resultScene = 'post_probe_resp';
        dashboard(4,sprintf('sc4_mTarg_joy: Correct choice'));
        probeRespChoice = 'correctChoice';
        % --- WRITE EVENT CODE specifying correct response to ML and NI DAQ
        if correctDir == LEFT
            eventmarker(leftCorrResp_eventCode);
        elseif correctDir == RIGHT
            eventmarker(rightCorrResp_eventCode);
        end
        dashboard(3,sprintf('sc4_wtHold: Correct target (x,y) = %d %d', sc4_mTarg_joy.Target(1), sc4_mTarg_joy.Target(2)));
        dashboard(4,sprintf('sc4_wtHold: Chosen target = %d', sc4_mTarg_joy.ChosenTarget));
        dashboard(5,sprintf('sc4_wtHold: Correct choice'));
        dashboard(6,sprintf('sc4_successiveHits = %d', successiveHits));

    elseif sc4_mTarg_joy.ChosenTarget == 2 % incorrect target
        successiveHits = 0;
        successiveErrors = successiveErrors + 1;
        trialResult = 'incorrectChoice';
        resultScene = 'post_probe_resp';
        dashboard(4,sprintf('sc4_mTarg_joy: Incorrect choice'));
        probeRespChoice = 'incorrectChoice';
        % --- WRITE EVENT CODE specifying error response to ML and NI DAQ
        if correctDir == LEFT
            eventmarker(rightErrResp_eventCode); % WRONG DIRECTION
        elseif correctDir == RIGHT
            eventmarker(leftErrResp_eventCode);  % WRONG DIRECTION
        end
        trialerror(6);  %'Incorrect'
        dashboard(3,sprintf('sc4_wtHold: Incorrect target (x,y) = %d %d', sc4_mTarg_joy.Target(1), sc4_mTarg_joy.Target(2)));
        dashboard(4,sprintf('sc4_wtHold: Chosen target = %d', sc4_mTarg_joy.ChosenTarget));
        dashboard(5,sprintf('sc4_wtHold: Incorrect choice'));
    end
elseif sc4_mTarg_joy.Waiting
    idle(0, [], noJoy_eventCode);
    trialerror(1);  %'No response'
    abortTrial = true;
    trialResult = 'noResponse';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc4_mTarg_joy: Waiting');
elseif sc4_eyeCenter.Success
    % scene terminated with eye in window. Therefore eye did not cause
    % scene to terminate. The joystick caused the scene to terminate.
    % Joystick not success, not waiting, therefore joystick must have
    % acquired target but not been held for HoldTime
    idle(0, [], brokeJoyFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_joy';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc4_mTarg_joy: Fail');
    dashboard(5, 'sc4_eyeCenter: Success');
elseif ~sc4_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    idle(0, [], brokeGazeFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_eye';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc4_mTarg_joy: In window, holding');
    dashboard(5, 'sc4_eyeCenter: Fail');
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', nan, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', nan, ...
        'probeReturnRT', nan, ...
        'probeRespChoice', nan, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% ------------------------------------------------------------
% SCENE 5: POST-PROBE RESPONSE JOYSTICK RETURN

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(3, sprintf('Running scene 5: POST RESP RETURN'));

% --- CREATE ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc5_eyeCenter = SingleTarget(eye_);
sc5_eyeCenter.Target = taskObj_fix;
sc5_eyeCenter.Threshold = eye_radius;

% Set up WaitThenHold in relation to eye target
sc5_wtHold_eye = WaitThenHold(sc5_eyeCenter);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc5_wtHold_eye.WaitTime = 0; % eye already in-window
sc5_wtHold_eye.HoldTime = postResp_joy_waitTime + postResp_joy_holdTime + 5000;  % big number, joy wtHold will time out first

% Present fixation target and establish XY position window for joy.
sc5_joyCueTarg = SingleTarget(joy_);
sc5_joyCueTarg.Target = [0 0]; % joy back to screen center
sc5_joyCueTarg.Threshold = joy_radius;

% Set up WaitThenHold in relation to joy target
sc5_wtHold_joy = WaitThenHold(sc5_joyCueTarg);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc5_wtHold_joy.WaitTime = postResp_joy_waitTime;
sc5_wtHold_joy.HoldTime = postResp_joy_holdTime;

% Mark behavioral event: probe return
sc5_wtHold_joy_oom = OnOffMarker(sc5_wtHold_joy);
sc5_wtHold_joy_oom.OffMarker = joyBack_eventCode;  %'probeReturn'
% Mark event when waiting goes from true to false, start of joy
% fixation back at central fixation target after probeReturn
sc5_wtHold_joy_oom.ChildProperty = 'Waiting';

% AllContinue eye wtHold and probeReturn response, with scene timing
% dependent on the joystick response
sc5_probeReturn = AllContinue(sc5_wtHold_eye);
sc5_probeReturn.add(sc5_wtHold_joy_oom);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene5 = create_scene(sc5_probeReturn, taskObj_fix);
scene5_start = run_scene(scene5, retStart_eventCode); %'probeReturnStart'

% --- CHECK BEHAVIORAL OUTCOMES
% this scene runs separate eye and joystick WaitThenHolds and runs them
% in parallel using AllContinue, with timing such that joystick wtHold
% controls task timing and scene termination, and eye wtHold will never
% terminate
if sc5_wtHold_joy.Success
    probeReturnRT = sc5_wtHold_joy.AcquiredTime;
    dashboard(4, 'sc5_wtHold_joy: Success');
    trialResult = 'joyReturnSuccess';
    probeRespCompleted = true;

    % >>> UPDATE TRIALS LEFT HERE!!
    % --- delete this condition trial rep from trialsLeft if this scene
    % completes successfully.  This applies to both correct and error
    % joystick responses in the previous scene.
    if ismember(TrialRecord.CurrentCondition, TrialRecord.User.trialsLeft)
        blastIndxVect = find(TrialRecord.User.trialsLeft == TrialRecord.CurrentCondition);
        TrialRecord.User.trialsLeft(blastIndxVect(1)) = [];
    else
        error('This trial condition not among trialsLeft')
    end
elseif sc5_wtHold_joy.Waiting
    idle(0, [], noJoy_eventCode);
    trialerror(1);  %'No response'
    abortTrial = true;
    trialResult = 'noResponse';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc5_wtHold_joy: Waiting');
elseif sc5_eyeCenter.Success
    % scene terminated with eye in window. Therefore eye did not cause
    % scene to terminate. The joystick caused the scene to terminate.
    % Joystick not success, not waiting, therefore joystick must have
    % acquired target but not been held for HoldTime
    idle(0, [], brokeJoyFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_joy';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc5_wtHold_joy: Fail');
    dashboard(5, 'sc5_eyeCenter: Success');
elseif ~sc5_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    idle(0, [], brokeGazeFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_eye';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc5_wtHold_joy: Holding');
    dashboard(5, 'sc5_eyeCenter: Fail');
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', sc4_mTarg_joy.ChosenTarget, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', probeRespRT, ...
        'probeReturnRT', nan, ...
        'probeRespChoice', probeRespChoice, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% -------------------------------------------------------------------------
% SCENE 6: FEEDBACK
% Present feedback during central eye and joy fixation. Feedback given
% based on performance during probe response only if task has been run
% successfully up to this point (any errors like breaks in fixation cause
% the trial to end without feedback).

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(4,sprintf('')); % Scene behavioral outcome
dashboard(5,sprintf('')); % Misc information
dashboard(6,sprintf('')); % Misc information

dashboard(3, sprintf('Running scene 6: FEEDBACK'));

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc6_eyeCenter = SingleTarget(eye_);
sc6_eyeCenter.Target = taskObj_fix;
sc6_eyeCenter.Threshold = eye_radius;

% Present fixation target and establish XY position window for joy
sc6_joyCenter = SingleTarget(joy_);
sc6_joyCenter.Target = taskObj_fix;
sc6_joyCenter.Threshold = joy_radius;

% AND eye and joy
sc6_eyejoy = AndAdapter(sc6_eyeCenter);
sc6_eyejoy.add(sc6_joyCenter);

% pass eye AND joy to WaitThenHold
sc6_wtHold = WaitThenHold(sc6_eyejoy);
sc6_wtHold.WaitTime = feedback_eyejoy_waitTime;
sc6_wtHold.HoldTime = feedback_eyejoy_holdTime;

% Present the feedback ring stimulus, and mark behavioral event
sc6_feedbackImg = ImageChanger(null_);

if sc4_mTarg_joy.ChosenTarget == 1 % correct target
    sc6_feedbackImg.List = {[], [], beforeFeedback, []; ...
        correctFeedbackImg, [0 0], feedbackTime, corrFeedback_eventCode;...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc6_feedbackImg.DurationUnit = 'msec';
elseif sc4_mTarg_joy.ChosenTarget == 2 % incorrectTarg
    sc6_feedbackImg.List = {[], [], beforeFeedback, []; ...
        incorrectFeedbackImg, [0 0], feedbackTime, errFeedback_eventCode;...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc6_feedbackImg.DurationUnit = 'msec';
end

% Tone feedback, if toggle is on
if toneFeedback
    if sc4_mTarg_joy.ChosenTarget == 1 % correct target
        sc6_feedbackSnd = AudioSound(null_);
        sc6_feedbackSnd.List = 'load_waveform({''sin'', 0.5, 800})';  % 800 Hz sine wave for 0.5 sec
    elseif sc4_mTarg_joy.ChosenTarget == 2 % incorrectTarg
        sc6_feedbackSnd = AudioSound(null_);
        sc6_feedbackSnd.List = 'load_waveform({''sin'', 0.5, 500})';  % 800 Hz sine wave for 0.5 sec
    end
end

% Concurrent central eye/joy fixation and feedback ring presentation
sc6_feedbackFix = Concurrent(sc6_wtHold);
sc6_feedbackFix.add(sc6_feedbackImg);
sc6_feedbackFix.add(sc6_feedbackSnd);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene6 = create_scene(sc6_feedbackFix, taskObj_fix);
scene6_start = run_scene(scene6, feedbackStart_eventCode); %'feedbackStart'

% --- CHECK BEHAVIORAL OUTCOMES
if sc6_wtHold.Success
    idle(0);
    dashboard(4, 'sc10_cueFix: Success');
    totalTrialSuccess = 1;
elseif sc6_wtHold.Waiting
    idle(0, [], noJoy_eventCode); % turns FIX OFF
    trialerror(4);  %'No fixation'
    abortTrial = true;
    trialResult = 'noEyeJoyFix';
    resultScene = 'feedback';
    dashboard(4, 'sc6_wtHold: Waiting');
else  % fixation acquired but broken
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    dashboard(4, 'sc10_wtHold: Broken fixation');
    % figure out which fixation was broken, eye or joy
    if sc6_eyeCenter.Success && ~sc6_joyCenter.Success
        idle(0, [], brokeJoyFix_eventCode);
        dashboard(5, 'sc6_eyeCenter: Success');
        dashboard(6, 'sc6_joyCenter: Fail');
        trialResult = 'breakFix_joy';
        resultScene = 'feedback';
    elseif ~sc6_eyeCenter.Success && sc6_joyCenter.Success
        idle(0, [], brokeGazeFix_eventCode);
        dashboard(5, 'sc6_eyeCenter: Fail');
        dashboard(6, 'sc6_joyCenter: Success');
        trialResult = 'breakFix_eye';
        resultScene = 'feedback';
    elseif ~sc6_eyeCenter.Success && ~sc6_joyCenter.Success % not likely, but possible
        idle(0, [], brokeBothFix_eventCode);
        dashboard(5, 'sc6_eyeCenter: Fail');
        dashboard(6, 'sc6_joyCenter: Fail');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'feedback';
    end
end

% bomb trial if error
if abortTrial
    % --- SAVE USER VARS
    bhv_variable(...
        'cuePos', cuePos, ...
        'probePos', probePos, ...
        'cueID', cueID, ...
        'cueStr', cueStr, ...
        'cueFileName', cue_pic, ...
        'probeID', probeID, ...
        'probeStr', probeStr, ...
        'probeFileName', probe_pic, ...
        'trialID', trialTypeID, ...
        'chosenTarget', sc4_mTarg_joy.ChosenTarget, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'isiTime', isiTime, ...
        'itiTime', itiTime, ...
        'probeRespRT', probeRespRT, ...
        'probeReturnRT', probeReturnRT, ...
        'probeRespChoice', probeRespChoice, ...
        'probeRespCompleted', probeRespCompleted, ...
        'trialSet', trialSet, ...
        'numConds', TrialRecord.User.numConds, ...
        'condAra', TrialRecord.User.condAra, ...
        'condAraLabel', TrialRecord.User.condAraLabel, ...
        'masterTrialAra', TrialRecord.User.masterTrialAra, ...
        'trialsLeft', TrialRecord.User.trialsLeft);
    return;
end

% --- Adjust ITI for errorMultipleHits
if multipleErrors
    % Making the 5 trial counter for tracking 3 errors in this window
    if totalTrialSuccess == 1   % increment on completed trials
        trialCounter = trialCounter + 1;
    end
    if trialCounter > multipleErrorsCounter % restart if it gets above 5
        trialCounter = 0;
        successiveErrors = 0;
    end
    if successiveErrors >= numErrors && trialCounter <= multipleErrorsCounter
        itiTime = multipleErrorsITI;
        set_iti(itiTime);
        trialCounter = 0;
        successiveErrors = 0;
    end
end

% --- REWARD
if multipleHits && rewCorrect
    if totalTrialSuccess == 1 && successiveHits >= numHits
        goodmonkey(normRewDur, 'juiceline',1, 'numreward', normNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        idle(0);
        trialerror(0);  %'Correct'
        successiveHits = 0;
        if jackpotITI == true
            itiTime = jackpotTime;
            set_iti(itiTime);
        end
    elseif totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice')
        goodmonkey(smRewDur, 'juiceline',1, 'numreward', smNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        idle(0);
        trialerror(0);  %'Correct'
    else
        trialerror(6);  %Incorrect
        idle(0);
    end
elseif multipleHits
    if totalTrialSuccess == 1 && successiveHits >= numHits
        goodmonkey(normRewDur, 'juiceline',1, 'numreward', normNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        idle(0);
        trialerror(0);  %'Correct'
        successiveHits = 0;
        if jackpotITI == true
            itiTime = jackpotTime;
            set_iti(itiTime);
        end
    elseif totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice')
        idle(0);
        trialerror(0);  %'Correct'
    else
        trialerror(6);  %Incorrect
        idle(0);
    end
elseif rndNumDrops && diffRew
    if totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice') && strcmp(strCorrectTarg, 'leftTarg')
        if chanceVHigh >= rand
            goodmonkey(vHighRewDur, 'juiceline',1, 'numreward', vHighNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        elseif chanceHigh >= rand
            goodmonkey(highRewDur, 'juiceline',1, 'numreward', highNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        else
            goodmonkey(leftRewDur, 'juiceline',1, 'numreward', leftNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        end
        idle(0);
        trialerror(0);  %'Correct'
    elseif totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice') && strcmp(strCorrectTarg, 'rightTarg')
        if chanceVHigh >= rand
            goodmonkey(vHighRewDur, 'juiceline',1, 'numreward', vHighNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        elseif chanceHigh >= rand
            goodmonkey(highRewDur, 'juiceline',1, 'numreward', highNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        else
            goodmonkey(rightRewDur, 'juiceline',1, 'numreward', rightNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        end
        idle(0);
        trialerror(0);  %'Correct'
    else
        trialerror(6);  %Incorrect
        idle(0);
    end
elseif rndNumDrops
    if totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice')
        if chanceVHigh >= rand
            goodmonkey(vHighRewDur, 'juiceline',1, 'numreward', vHighNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        elseif chanceHigh >= rand
            goodmonkey(highRewDur, 'juiceline',1, 'numreward', highNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        else
            goodmonkey(normRewDur, 'juiceline',1, 'numreward', normNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        end
        idle(0);
        trialerror(0);  %'Correct'
    else
        trialerror(6);  %Incorrect
        idle(0);
    end
else
    if totalTrialSuccess == 1 && strcmp(probeRespChoice, 'correctChoice')
        goodmonkey(normRewDur, 'juiceline',1, 'numreward', normNumDrops, 'pausetime',500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
        idle(0);
        trialerror(0);  %'Correct'
    else
        trialerror(6);  %Incorrect
        idle(0);
    end
end

% -------------------------------------------------------------------------
% --- SAVE BEHAVIORAL VARIABLES TO OUTFILE
% This is where we can save variables in the behavioral outfile for later
% reference. Mainly timing variables, including the randomized delay
% times and when the joystick hit certain targets

bhv_variable(...
    'cuePos', cuePos, ...
    'probePos', probePos, ...
    'cueID', cueID, ...
    'cueStr', cueStr, ...
    'cueFileName', cue_pic, ...
    'probeID', probeID, ...
    'probeStr', probeStr, ...
    'probeFileName', probe_pic, ...
    'trialID', trialTypeID, ...
    'chosenTarget', sc4_mTarg_joy.ChosenTarget, ...
    'trialResult', trialResult, ...
    'resultScene', resultScene, ...
    'isiTime', isiTime, ...
    'itiTime', itiTime, ...
    'probeRespRT', probeRespRT, ...
    'probeReturnRT', probeReturnRT, ...
    'probeRespChoice', probeRespChoice, ...
    'probeRespCompleted', probeRespCompleted, ...
    'trialSet', trialSet, ...
    'numConds', TrialRecord.User.numConds, ...
    'condAra', TrialRecord.User.condAra, ...
    'condAraLabel', TrialRecord.User.condAraLabel, ...
    'masterTrialAra', TrialRecord.User.masterTrialAra, ...
    'trialsLeft', TrialRecord.User.trialsLeft);

