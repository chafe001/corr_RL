% -----------------------------------------------------------------------
% ----------------  CORR_RL_NHP TRAINING SEQUENCE -----------------------
% -----------------------------------------------------------------------

% -------------------------------------------------------------------------
% *** STAGE 1: simplest movie-joystick direction training 

% INITIAL (most forgiving) SETTINGS: 

% --- allocate one trial condition to each block
% USE conditions file: corr_RL_np_v4_blockCond.txt

% note: make sure the config file has the proper Diagonal Size, Viewing
% Distance, Conditions, and Blocks settings (copy from other config
% file if necessary).

% --- define only 2 different stimuli
% SET params.Angles = [0 90];
% SET params.FaceColors = [1 1 1];  

% --- disable movie noise on alternate blocks
% SET params.randCuePercent = false;
% SET params.cuePercentRange = 1.0;

% --- define constant stim pairs for left and right resp over blocks and runs
% SET params.pairMode = 'fixedPairs';

% --- present pairs in each movie in a fixed sequence
% SET params.fixPairSeq = true; 

% --- enable error feedback image
% SET params.noRewImg = true;

% --- decrement rather than zero netWins on error
% SET params.zero_netWins_onError = false;

% --- enable deterministic reward
% SET params.highRewProb = 1;
% SET params.lowRewProb = 0;

% --- reward every hit
% SET params.numDropsEach = 1;

% *** NOTE: reward every and number of bonus rewards, along with reward
% pulse width and delay, are now set by the setParams function

% PROGRESSION:
% --- implement multiple hits required for any reward to discourage settling in a garbage strategy
% SET params.numDropsEach = 0;
% SET params.zero_netWins_onError = true;
% note: this will require getting every response correct to achieve the
% netWins criterion and get jackpot, so no slacking

% -------------------------------------------------------------------------
% *** STAGE 2: enforce movie-joystick direction switching 

% --- allocate two trial conditions (L/R) to each block
% USE conditions file: corr_RL_np_v4.txt

% SET params.netWin_criterion = 2;
% SET params.numDropsEach = 0;
% SET params.zero_netWins_onError = true;
% note: will have to get 2 in a row correct to get any reward, this will
% require switching on ~ 1/2 of blocks 

% PROGRESSION
% SET params.netWin_criterion = 3-5;

% -------------------------------------------------------------------------
% *** STAGE 3: allow new pairs on different program runs 
% SET params.pairMode = 'newPairs_each_run';
% note: this should be minimally different from stage 2, but still could be
% challenging

% -------------------------------------------------------------------------
% *** STAGE 4: allow new pairs on different blocks of the same run
% SET params.pairMode = 'newPairs_each_block';
% note: this will definitely be challenging

% -------------------------------------------------------------------------
% *** STAGE 5: increase movie complexity 
% --- increase the number of distinct stimuli and hence number of different
% stimulus pairs shown in each movie
% SET params.Angles = [0 45 90]; 

% PROGRESSION
% SET params.Angles = [0 45 90 135];  


% -----------------------------------------------------------------------
% ---------------------  CORR_RL_NHP TASK CODE --------------------------
% -----------------------------------------------------------------------

% Version history
% v1: porting human v6 into NHP version, reintroducing eye, joystick
% control etc.  v1 is a working version with joystick response and eye gaze
% fixation implemented and tested in simulation.

% v2: Training stage.  Conditions (bar orientations) presented in blocks.
% Bars associated with different conditions are different colors.  Eye
% fixation implemented.

% v3: Training stage.  Adding auditory feedback for correct (and
% optionally) error movements at the time that the joystick cursor enters
% the response window.  Also implemented onPair, showing only a single pair
% per trial to simplify visual-motor association

% v4: Training stage. Implementing fixed pair sequence, correct and error
% feedback rigns, multiple hits reset to 0 on error, and break between 
% blocks as options.  Removing xPairs as a way to construct movies.
% Separated code at end of trial computing whether correct response was 
% made, and whether or not to reward trial (to simplify).

% -------------------------------------------------------------------------
% ---------------------- TASK CONTROL SWITCHES ----------------------------
% -------------------------------------------------------------------------

% --- Display joystick
showcursor(false);

% -------------------------------------------------------------------------
% --------------------------- CONSTANTS -----------------------------------
% -------------------------------------------------------------------------
% Task objects. Numbers are column indices in the conditions *.txt file and
% control how ML accesses stimulus information from the conditions file. We
% are using this mostly to control stimulus positions.  Stimuli identities
% are controlled by setting the filenames of *.png files to read from disk
taskObj_fix = 1;

trialerror(0, 'validResp', 1, 'earlyResp', 2, 'noResp');

% Reward sizes
rewDur1 = 100;
numDrops1 = 2;

% make sure these match values in buildTrials where they are associated
% with conditions
LEFT = 1;
RIGHT = 2;

% -------------------------------------------------------------------------
% ---------------------- TRIAL OUTCOME VARIABLES --------------------------
% -------------------------------------------------------------------------
% --- these variables save behavioral events to the outfile

trialResult = 'null';

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
stimRespCompleted = false;

% -------------------------------------------------------------------------
% ------------------------ CHECK HARDWARE ---------------------------------
% -------------------------------------------------------------------------

% check eye input is detected
if ~exist('eye_','var'), error('This demo requires eye signal input. Please set it up or try the simulation mode.'); end

% set hotkey for exit
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Note for manual reward: during task, [R] is preprogrammed as a manual
% reward hotkey and will dispense the amount of reward specified in the
% section of the main menu
% [R] key: Delivers a manual reward (initial pulse duration: 100 ms, juiceline: as determined in Reward of the main menu).

% -------------------------------------------------------------------------
% -------------------------- PARAMETERS -----------------------------------
% -------------------------------------------------------------------------
dbstop if error;
taskObj_fix = 1;

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------

% call fx to set trial timing
times = corr_RL_nhp_setTimes_v1();

% save times to TrialRecord
TrialRecord.User.times = times;

% -------------------------------------------------------------------------
% -------------- BUILD CONDITION AND TRIAL ARRAYS -------------------------
% -------------------------------------------------------------------------
% DO THIS ONCE AT START OF RUN (if first trial)
% This code generates the condition array, and the trial array, and stores
% these variables in the TrialRecord.  TrialRecord is defined by ML app
% code, and we can store user-defined variables at the trial level in this
% variable for future reference.

% conditions: each condition, specified by a number, provides all the
% information needed to generate a trial.

% trials: a vector of condition numbers corresponding to the trial types
% and frequencies we want to present to each subject (the trial 'stack').
% We draw randomly from the trialAra to specify the condition number for
% each trial
if TrialRecord.CurrentTrialNumber == 1

    [condArray, params] = corr_RL_nhp_buildTrials_v2();

    % store output in TrialRecord so variables live (have scope) beyond
    % this trial.  Other variables in script are only defined during the
    % trial.
    TrialRecord.User.condArray = condArray;
    % TrialRecord.User.condReps = condReps;
    TrialRecord.User.params = params;
    % init condition reps remaining counter (condRepRem) to initial
    % condition rep array
    % TrialRecord.User.condRepsRem = condReps;
    TrialRecord.User.times = times;

    switch TrialRecord.User.params.stimulusType
        case 'bars'
            codes = corr_RL_nhp_setBarCodes_v1();
        case 'curves'
            codes = corr_RL_setCurveCodes_v3();
    end

    TrialRecord.User.codes = codes;

end

% -------------------------------------------------------------------------
% --------------------- GENERATE STIMULUS MOVIE ---------------------------
% -------------------------------------------------------------------------

switch TrialRecord.User.params.stimulusType

    case 'bars'

        [movieFrames, pairSeq, pairs] = corr_RL_nhp_generateBarMovie_v2(TrialRecord);
        TrialRecord.User.movieFrames = movieFrames;
        TrialRecord.User.pairSeq = pairSeq;
        TrialRecord.User.pairs = pairs;

    case 'curves'
        % [movieFrames] = corr_RL_generateCurveMovie_v1(TrialRecord);
        [movieFrames, movieParams] = corr_RL_generateCurveMovie_v3(TrialRecord);
        TrialRecord.User.movieFrames = movieFrames;
        TrialRecord.User.movieParams = movieParams;
end


% -------------------------------------------------------------------------
% ----------------- INIT WITHIN BLOCK RESULT COUNTERS -----------------------
% -------------------------------------------------------------------------
if TrialRecord.CurrentTrialWithinBlock == 1
    TrialRecord.User.blockWins = 0;
    TrialRecord.User.blockLosses = 0;
    TrialRecord.User.netWins = 0;
end

% -------------------------------------------------------------------------
% ---------------- EXTRACT TRIAL INFO FROM TrialRecord --------------------
% -------------------------------------------------------------------------
t = TrialRecord.CurrentTrialNumber;
c = TrialRecord.CurrentCondition;
b = TrialRecord.CurrentBlock;

% -------------------------------------------------------------------------
% ---------------- SET CHOICE AND REWARD PARAMETERS -----------------------
% -------------------------------------------------------------------------

% set the choice feebback images
choices.rewImg = 'rewRing.png';
choices.noRewImg = 'noRewCross.png';
choices.choiceImg = 'choiceRing.png';

% init choice variables
choices.chosenSide = [];
choices.responseKey = [];
choices.choseCorrect = []; % selected the choice with the higher reward probability
choices.madeValidResp = [];

% -------------------------------------------------------------------------
% ----------------- PRINT TRIAL INFO TO USER SCREEN -----------------------
% -------------------------------------------------------------------------



switch TrialRecord.User.params.stimulusType

    case 'bars'
        switch TrialRecord.User.condArray(c).state
            case 1
                corrStr = 'CORRECT: LEFT';
            case 2
                corrStr = 'CORRECT: RIGHT';
        end

        % --- print correct response direction
        dashboard(1, corrStr, [1 1 1], 'FontSize', 8);

        % --- overwrite JOYSTICK entry from last trial
        dashboard(2, 'JOYSTICK:', [1 1 1], 'FontSize', 8);

        % overwrite RESULT entry from last trial
        dashboard(3, 'RESULT:', [1 1 1], 'FontSize', 8);

        % --- print trial info
        trlInfoStr = strcat('TRIAL:', num2str(t), ...
            '  BLOCK:', num2str(b), ...
            '  COND:', num2str(c));

        dashboard(5, trlInfoStr, [0 0 0], 'FontSize', 8);

        % --- stimulus pair details
        % pair1_Angles_str = strcat('Pair1 L_ang:', num2str(TrialRecord.User.condArray(c).cuePairs(1).leftStim.Angle), ...
        %     '  L_RGB: ', num2str(TrialRecord.User.condArray(c).cuePairs(1).leftStim.FaceColor), ...
        %     '  L_FN: ', TrialRecord.User.condArray(c).cuePairs(1).leftStim.FileName, ...
        %     '  R_ang: ', num2str(TrialRecord.User.condArray(c).cuePairs(1).rightStim.Angle), ...
        %     '  R_RGB: ', num2str(TrialRecord.User.condArray(c).cuePairs(1).rightStim.FaceColor), ...
        %     '  R_FN: ', TrialRecord.User.condArray(c).cuePairs(1).rightStim.FileName);
        %
        % pair2_Angles_str = strcat('Pair2 L_ang:', num2str(TrialRecord.User.condArray(c).cuePairs(2).leftStim.Angle), ...
        %     '  L_RGB: ', num2str(TrialRecord.User.condArray(c).cuePairs(2).leftStim.FaceColor), ...
        %     '  L_FN: ', TrialRecord.User.condArray(c).cuePairs(2).leftStim.FileName, ...
        %     '  R_ang: ', num2str(TrialRecord.User.condArray(c).cuePairs(2).rightStim.Angle), ...
        %     '  R_RGB: ', num2str(TrialRecord.User.condArray(c).cuePairs(2).rightStim.FaceColor), ...
        %     '  R_FN: ', TrialRecord.User.condArray(c).cuePairs(2).rightStim.FileName);

        % dashboard(4, pair1_Angles_str, [1 1 1], 'FontSize', 8);
        % dashboard(5, pair2_Angles_str, [1 1 1], 'FontSize', 8);

    case 'curves'
        trlInfoStr = strcat(corrStr, ...
            '  Trial:', num2str(t), ...
            '  Block:', num2str(b), ...
            '  Cond:', num2str(c), ...
            '  State:', num2str(TrialRecord.User.condArray(c).state));

        % --- DISPLAY movieParams for this movie
        cmt = TrialRecord.User.movieParams.curveMovieType;
        cmo = TrialRecord.User.movieParams.orientation;
        ms = num2str(TrialRecord.User.movieParams.mainSeq);
        os = num2str(TrialRecord.User.movieParams.orthoSeq);
        mt = num2str(TrialRecord.User.movieParams.mainTvalSeq);
        ot = num2str(TrialRecord.User.movieParams.orthoTvalSeq);

        movieInfoStr1 = strcat('movieP Type:', cmt, '  Orient: ', cmo, '  ms: ', ms, '  os: ', os);
        movieInfoStr2 = strcat('mt: ', mt);
        movieInfoStr3 = strcat('ot: ', ot);

        dashboard(1, trlInfoStr, [0 0 0], 'FontSize', 8);
        dashboard(3, movieInfoStr1, [0 0 0], 'FontSize', 8);
        dashboard(4, movieInfoStr2, [0 0 0], 'FontSize', 8);
        dashboard(5, movieInfoStr3, [0 0 0], 'FontSize', 8);

end


% *************************************************************************************************
% *************************************************************************************************
% ************************ BUILD AND RUN SCENES (RUN TRIAL) BELOW *********************************
% *************************************************************************************************
% *************************************************************************************************

% flag to call 'return' to end trial prematurely if error
abortTrial = false;

% -------------------------------------------------------------------------
% SCENE 1: PRETRIAL
% draw reward box, and count a clock down to record nerual activity before
% fixation onset

% write event codes to store ML condition and trial numbers
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);
% replaced idle() with eventmarker() for the human task code, prevents
% blinking of reward bar when called
eventmarker([TrialRecord.CurrentCondition mult256 mod256]);

% --- BUILD ADAPTOR CHAINS

% draw rewBox to indicate accumulated rewards
% NOTE: Passing wtHold into BoxGraphic works
rewBox = BoxGraphic(null_);
netWinBox_height = TrialRecord.User.params.rewBox_height;
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
maxWinBox_width = TrialRecord.User.params.rewBox_width;
% orange
% netWinBox_edgeColor = [0.9290 0.6940 0.1250];
% netWinBox_faceColor = [0.9290 0.6940 0.1250];
% light blue
netWinBox_edgeColor = [0.3010 0.7459 0.9330];
netWinBox_faceColor = [0.3010 0.7459 0.9330];

% figure out where to print white netWin reward box so it is left aligned
% with left edge of black maxWin reward box.  X position coordinate
% specifies screen coordinates of center of rectangle graphic. The center
% of the white bar is screen center -1/2 black bar width +1/2 white bar
% width
netWinBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);
rewBox.List = {netWinBox_edgeColor, netWinBox_faceColor, [netWinBox_width netWinBox_height], [netWinBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width netWinBox_height], [0 TrialRecord.User.params.rewBox_yPos - netWinBox_height]};

% pass rewBox to TimeCounter
sc1_tc = TimeCounter(rewBox);
sc1_tc.Duration = times.sc1_preTrial_ms;

% --- RUN SCENE
dashboard(4, 'SCENE: PRETRIAL (1)', 'FontSize', 8);
scene1 = create_scene(sc1_tc);
run_scene(scene1, TrialRecord.User.codes.sc1_preTrialStart);

% -------------------------------------------------------------------------
% SCENE 2: FIX

% --- BUILD ADAPTOR CHAINS

% present fix target, activatate eye window
sc2_eyeCenter = SingleTarget(eye_);
sc2_eyeCenter.Target = taskObj_fix;
sc2_eyeCenter.Threshold = TrialRecord.User.params.eye_radius;

% write event code for acquiring eye fixation
sc2_eyeCenter_oom = OnOffMarker(sc2_eyeCenter);
sc2_eyeCenter_oom.OnMarker = TrialRecord.User.codes.sc2_gazeFixAcq;
sc2_eyeCenter_oom.ChildProperty = 'Success';

% present joystick target, activate joystick window
sc2_joyCenter = SingleTarget(joy_);
sc2_joyCenter.Target = taskObj_fix;
sc2_joyCenter.Threshold = TrialRecord.User.params.joy_radius;

% write event code for acquiring joy fixation
sc2_joyCenter_oom = OnOffMarker(sc2_joyCenter);
sc2_joyCenter_oom.OnMarker = TrialRecord.User.codes.sc2_joyFixAcq;
sc2_joyCenter_oom.ChildProperty = 'Success';

% 'and' eye and joy together
sc2_eyejoy = AndAdapter(sc2_eyeCenter_oom);
sc2_eyejoy.add(sc2_joyCenter_oom);

% require maintaining eye and gaze fixation for holdTime
sc2_wtHold = WaitThenHold(sc2_eyejoy);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc2_wtHold.WaitTime = times.sc2_fix_eyejoy_waitTime_ms;
sc2_wtHold.HoldTime = times.sc2_fix_eyejoy_holdTime_ms;

% combine wtHold with rewbox
sc2_wtHold_rewBox = Concurrent(sc2_wtHold);
sc2_wtHold_rewBox.add(rewBox);

% --- RUN SCENE
dashboard(4, 'SCENE: FIX (2)', 'FontSize', 8);
% scene2 = create_scene(sc2_wtHold_rewBox);
scene2 = create_scene(sc2_wtHold_rewBox);
scene2_start = run_scene(scene2, TrialRecord.User.codes.sc2_fixTargOn);

% --- CHECK BEHAVIORAL OUTCOMES
% Note: this status checking structure copied from ML documentation on
% WaitThenHold()
if sc2_wtHold.Success
    % do nothing, advance to next scene
elseif sc2_wtHold.Waiting
    trialerror(4);
    trialResult = 'neverFix';
    abortTrial = true;
    idle(0, [], TrialRecord.User.codes.neverFix);
else  % broke fix, eye or joy
    trialerror(3);
    abortTrial = true;
    if sc2_eyeCenter.Success && ~sc2_joyCenter.Success
        trialResult = 'brokeJoy';
        idle(0, [], TrialRecord.User.codes.brokeJoyFix);
    elseif ~sc2_eyeCenter.Success && sc2_joyCenter.Success
        trialResult = 'brokeEye';
        idle(0, [], TrialRecord.User.codes.brokeGazeFix);
    end

end

% bomb trial if error
if abortTrial

    % --- SAVE USER VARS
    bhv_variable( ...
        'TrialRecord', TrialRecord, ...
        'choices', choices, ...
        'condArray', TrialRecord.User.condArray, ...
        'params', TrialRecord.User.params, ...
        'movieFrames', TrialRecord.User.movieFrames);

    % --- ABORT TRIAL
    eventmarker(TrialRecord.User.codes.abortTrial)
    return;
end

% -------------------------------------------------------------------------
% SCENE 3: STIMULUS MOVIE

% --- BUILD ADAPTOR CHAINS

% --- 1. eye joy control
% present fix target, activatate eye window
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = TrialRecord.User.params.eye_radius;

% present joystick target, activate joystick window
sc3_joyCenter = SingleTarget(joy_);
sc3_joyCenter.Target = taskObj_fix; % redundant
sc3_joyCenter.Threshold = TrialRecord.User.params.joy_radius;

% 'and' eye and joy together
sc3_eyejoy = AndAdapter(sc3_eyeCenter);
sc3_eyejoy.add(sc3_joyCenter);

% pass eyejoy to WaitThenHold, require eye and joy fixation for hold time
sc3_wtHold = WaitThenHold(sc3_eyejoy);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc3_wtHold.WaitTime = times.sc3_movie_eyejoy_waitTime_ms;
sc3_wtHold.HoldTime = times.sc3_movie_eyejoy_holdTime_ms;

% --- 2. movie adaptor
sc3_movie = ImageChanger(null_);
sc3_movie.List = movieFrames;
% sc3_movie.Repetition = 1;

% --- 3. combine movie, wtHold and rewbox
% use AllContinue so termination of any adaptor ends scene, either movie
% completes, or fixation broken
sc3_wtHold_movie = AllContinue(sc3_wtHold);
sc3_wtHold_movie.add(sc3_movie);
sc3_wtHold_movie.add(rewBox);

% --- RUN SCENE
dashboard(4, 'SCENE: CUE MOVIE (3)', 'FontSize', 8);
scene3 = create_scene(sc3_wtHold_movie);
scene3_start = run_scene(scene3, TrialRecord.User.codes.sc3_movieStart);

% --- SAVE FRAME TIMES IN MOVIE
TrialRecord.User.movieFrameTimes = sc3_movie.Time;

% --- CHECK BEHAVIORAL OUTCOMES
if sc3_movie.Success  % movie completed without breaking eye or joy fix
    % do nothing, advance to next scene
else  % broke fix, eye or joy
    trialerror(3);
    abortTrial = true;
    if sc3_eyeCenter.Success && ~sc3_joyCenter.Success
        trialResult = 'brokeJoy';
        idle(0, [], TrialRecord.User.codes.brokeJoyFix);
    elseif ~sc3_eyeCenter.Success && sc3_joyCenter.Success
        trialResult = 'brokeEye';
        idle(0, [], TrialRecord.User.codes.brokeGazeFix);
    end

end

% bomb trial if error
if abortTrial

    % --- SAVE USER VARS
    bhv_variable( ...
        'TrialRecord', TrialRecord, ...
        'choices', choices, ...
        'condArray', TrialRecord.User.condArray, ...
        'params', TrialRecord.User.params, ...
        'movieFrames', TrialRecord.User.movieFrames, ...
        'movieFrameTimes', TrialRecord.User.movieFrameTimes);

    % --- ABORT TRIAL
    eventmarker(TrialRecord.User.codes.abortTrial);
    return;
end


% -------------------------------------------------------------------------
% SCENE 4: JOYSTICK RESPONSE

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc4_eyeCenter = SingleTarget(eye_);
sc4_eyeCenter.Target = taskObj_fix;
sc4_eyeCenter.Threshold = TrialRecord.User.params.eye_radius;

% pass eye to WaitThenHold
sc4_wtHold = WaitThenHold(sc4_eyeCenter);
sc4_wtHold.WaitTime = times.sc4_eye_waitTime_ms;
sc4_wtHold.HoldTime = times.sc4_eye_holdTime_ms; % entire duration of scene

% MultiTarget()
sc4_mTarg_joy = MultiTarget(joy_);
sc4_mTarg_joy.Target = [TrialRecord.User.params.leftJoyRespWin; TrialRecord.User.params.rightJoyRespWin];
sc4_mTarg_joy.Threshold = TrialRecord.User.params.joy_radius;
sc4_mTarg_joy.WaitTime = times.sc4_joy_waitTime_ms;
sc4_mTarg_joy.HoldTime = times.sc4_joy_holdTime_ms;

% Mark behavioral event:
sc4_mTarg_joy_oom = OnOffMarker(sc4_mTarg_joy);
sc4_mTarg_joy_oom.OffMarker = TrialRecord.User.codes.sc4_joyResp_enterWindow;
% Mark event when waiting goes from true to false
sc4_mTarg_joy_oom.ChildProperty = 'Waiting';

% AllContinue will be used to continue eye fix, and
% joy multitarget. It will stop once either of these stops
sc4_joyResp = AllContinue(sc4_mTarg_joy_oom);
sc4_joyResp.add(sc4_wtHold);
sc4_joyResp.add(rewBox);

% --- RUN SCENE
dashboard(4, 'SCENE: JOY RESPONSE (4)', 'FontSize', 8);
scene4 = create_scene(sc4_joyResp);
scene4_start = run_scene(scene4, TrialRecord.User.codes.sc4_joyResp_openWindows);

% --- CHECK BEHAVIORAL OUTCOMES
% evaluate multiTarget output properties
if sc4_mTarg_joy.Waiting  % no response made
    choices.RT = NaN;
    choices.respDir = NaN;
    choices.madeValidResp = false;
    trialerror('noResp')
    abortTrial = true;
elseif sc4_mTarg_joy.ChosenTarget == LEFT % ordinal position 1, first target entered, LEFT
    choices.RT = sc4_mTarg_joy.RT;
    eventmarker(TrialRecord.User.codes.sc4_joyResp_moveLeft);
    choices.respDir = LEFT;
    choices.madeValidResp = true;
    trialerror('validResp')
elseif sc4_mTarg_joy.ChosenTarget == RIGHT % ordinal position 2, second target enetered, RIGHT
    choices.RT = sc4_mTarg_joy.RT;
    eventmarker(TrialRecord.User.codes.sc4_joyResp_moveRight);
    choices.respDir = RIGHT;
    choices.madeValidResp = true;
    trialerror('validResp')
else
    choices.madeValidResp = false;
end

if abortTrial

    switch TrialRecord.User.params.stimulusType
        case 'bars'
            bhv_variable( ...
                'TrialRecord', TrialRecord, ...
                'choices', choices, ...
                'condArray', TrialRecord.User.condArray, ...
                'params', TrialRecord.User.params, ...
                'movieFrames', TrialRecord.User.movieFrames, ...
                'movieFrameTimes', TrialRecord.User.movieFrameTimes);

        case 'curves'
            bhv_variable( ...
                'TrialRecord', TrialRecord, ...
                'choices', choices, ...
                'condArray', TrialRecord.User.condArray, ...
                'params', TrialRecord.User.params, ...
                'movieFrames', TrialRecord.User.movieFrames, ...
                'movieFrameTimes', TrialRecord.User.movieFrameTimes, ...
                'movieParams', TrialRecord.User.movieParams);
    end

    % --- 'RETURN' CALL TERMINATES TRIAL EARLY
    eventmarker(TrialRecord.User.codes.abortTrial)
    return;

end


% -------------------------------------------------------------------------
% SCENE 5: GIVE PROBABILISTIC REWARD AND DISPLAY FEEDBACK

% --- DETERMINE WHETHER CORRECT RESPONSE WAS MADE 
% correct means subj selected the high reward probability choice given
% the state indicated by the cue movie

if choices.madeValidResp

    if TrialRecord.User.condArray(c).state == LEFT
        if choices.respDir == LEFT % correct response
            eventmarker(TrialRecord.User.codes.sc5_joyResp_correctChoice);
            choices.choseCorrect = true;
            choices.respStr = 'JOYSTICK: LEFT';
        elseif choices.respDir == RIGHT % error
            eventmarker(TrialRecord.User.codes.sc5_joyResp_incorrectChoice);
            choices.choseCorrect = false;
            choices.respStr = 'JOYSTICK: RIGHT';
        end
    elseif TrialRecord.User.condArray(c).state == RIGHT
        if choices.respDir == LEFT
            eventmarker(TrialRecord.User.codes.sc5_joyResp_incorrectChoice);
            choices.choseCorrect = false;
            choices.respStr = 'JOYSTICK: LEFT';
        elseif choices.respDir == RIGHT
            eventmarker(TrialRecord.User.codes.sc5_joyResp_correctChoice);
            choices.choseCorrect = true;
            choices.respStr = 'JOYSTICK: RIGHT';
        end
    end

else  % NO VALID RESPONSE

    choices.rewardTrial = false;
    choices.respStr = 'JOYSTICK: NO VALID RESP';
    choices.resultStr = 'RESULT: NO VALID RESP';

end % made valid reponse


% --- DETERMINE PROBABILISTIC/DETERMINISTIC REWARD 
% select random number between 0 and 1 to determine probabilistic reward
% if high rew prob == 1 and low rew prob == 0, this is equivalent to
% deterministic reward
choices.randNum_rew = rand();

if choices.choseCorrect

    if choices.randNum_rew < TrialRecord.User.params.highRewProb  % --- WIN, HIGH PROB ---
        choices.rewardTrial = true;
        eventmarker(TrialRecord.User.codes.sc5_joyResp_probRew);
        TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
        choices.resultStr = 'RESULT: WIN SELECTING HIGH PROB';
    else  % --- LOSS, HIGH PROB ---
        choices.rewardTrial = false;
        eventmarker(TrialRecord.User.codes.sc5_joyResp_probNoRew);
        TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
        choices.resultStr = 'RESULT: LOSS SELECTING HIGH PROB';
    end

else

    if choices.randNum_rew < TrialRecord.User.params.lowRewProb  % --- WIN, LOW PROB ---
        choices.rewardTrial = true;
        eventmarker(TrialRecord.User.codes.sc5_joyResp_probRew);
        TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
        choices.resultStr = 'RESULT: WIN SELECTING LOW PROB';
    else  % --- LOSS, LOW PROB ---
        choices.rewardTrial = false;
        eventmarker(TrialRecord.User.codes.sc5_joyResp_probNoRew);
        TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
        choices.resultStr = 'RESULT: LOSS SELECTING LOW PROB';
    end

end

% SIMULATE MULTIPLE HITS by zeroing newtins on error, if enabled
if choices.choseCorrect == false && TrialRecord.User.params.zero_netWins_onError
    TrialRecord.User.netWins = 0;
    TrialRecord.User.blockWins = 0;
    TrialRecord.User.blockLosses = 0;
end

% --- if blockLosses > blockWins, reset counters to 0 to prevent
% accumulation of a deficit, don't want a hole subj has to dig out of
% before display shows accumulation of additional wins
if TrialRecord.User.netWins < 0
    TrialRecord.User.blockWins = 0;
    TrialRecord.User.blockLosses = 0;
    TrialRecord.User.netWins = 0;
end

% --- SAVE CHOICE INFORMATION to TrialRecord
TrialRecord.User.Choices = choices;

% --- UPDATE REWARD BOX WITH THIS RESULT
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
netWinBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);
rewBox.List = {netWinBox_edgeColor, netWinBox_faceColor, [netWinBox_width netWinBox_height], [netWinBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width netWinBox_height], [0 TrialRecord.User.params.rewBox_yPos - netWinBox_height]};

% --- INSTANTIATE IMAGECHANGER OBJ for FEEDBACK MOVIE
% base visual feedback on probabilistic reward rather than whether correct
% (high prob) choice was made or not.  Rationale is that all correlates of
% reward (juice, tone, increment of counter) should reflect probabilistic
% reward to keep cues consistent and not confound RL modeling with
% conflicting feedback for correct direction and probabilistic reward
% delivery
sc5_rewImg = ImageChanger(rewBox);
if choices.madeValidResp
    if choices.rewardTrial
        sc5_rewImg.List = ...
            {{choices.choiceImg}, [0 0], times.sc5_choiceImg_frames, TrialRecord.User.codes.sc5_joyResp_choiceImgOn; ...
            {choices.rewImg}, [0 0], times.sc5_rewImg_frames, TrialRecord.User.codes.sc5_joyResp_rewImgOn};
    elseif TrialRecord.User.params.noRewImg
        sc5_rewImg.List = ...
            {{choices.choiceImg}, [0 0], times.sc5_choiceImg_frames, TrialRecord.User.codes.sc5_joyResp_choiceImgOn; ...
            {choices.noRewImg}, [0 0], times.sc5_noRewImg_frames, TrialRecord.User.codes.sc5_joyResp_noRewImgOn};
    else
        sc5_rewImg.List = ...
            {{choices.choiceImg}, [0 0], times.sc5_choiceImg_frames, TrialRecord.User.codes.sc5_joyResp_choiceImgOn};
    end
else
    sc5_rewImg.List = ...
        {[], [0 0], times.sc5_choiceImg_frames, TrialRecord.User.codes.noResp};

end

% --- INSTANTIATE TONE FEEDBACK, IF ENABLED
if TrialRecord.User.params.toneFeedback
    sc5_tone_feedback = AudioSound(sc5_rewImg);
    if choices.rewardTrial
        sc5_tone_feedback.List = {[TrialRecord.User.params.correctToneDur, TrialRecord.User.params.correctToneFreq], false};
    else
        sc5_tone_feedback.List = {[TrialRecord.User.params.errorToneDur, TrialRecord.User.params.errorToneFreq], false};
    end
    scene5 = create_scene(sc5_tone_feedback, taskObj_fix);

else
    scene5 = create_scene(sc5_rewImg, taskObj_fix);
end

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
dashboard(4, 'SCENE: FEEDBACK (5)', 'FontSize', 8);
% create_scene in switch statement above
scene5_start = run_scene(scene5);

% --- DELIVER REWARDS
if choices.rewardTrial

    if TrialRecord.User.netWins == TrialRecord.User.params.netWin_criterion
        TrialRecord.User.params.dropsThisTrial = TrialRecord.User.params.numDropsBlock;
    else
        TrialRecord.User.params.dropsThisTrial = TrialRecord.User.params.numDropsEach;
    end

    % --- give reward
    goodmonkey(TrialRecord.User.params.dur, 'juiceline', 1, 'numreward', TrialRecord.User.params.dropsThisTrial, 'pausetime',...
        TrialRecord.User.params.pauseTime, 'eventmarker', TrialRecord.User.codes.sc5_joyResp_rewDrop);

end

% --- OUTPUT CHOICE REWARD RESULT TO USER SCREEN
switch TrialRecord.User.params.stimulusType

    case 'bars'
        dashboard(2, choices.respStr, [1 1 1], 'FontSize', 8);
        dashboard(3, choices.resultStr, [1 1 1], 'FontSize', 8);

    case 'curves'
        dashboard(2, respStr, [0 0 0], 'FontSize', 8);

end

% -------------------------------------------------------------------------
% SCENE 6: POST TRIAL

% --- instantiate TimeCounter
sc6_tc = TimeCounter(null_);

if TrialRecord.User.netWins == TrialRecord.User.params.netWin_criterion
    sc6_tc.Duration = times.sc6_postTrial_long_ms;
    dashboard(4, 'SCENE: POST TRIAL LONG (6)', 'FontSize', 8);
    % --- RESET NETWINS BAR TO 0 
    netWinBox_width = 0;
    netWinBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);
    rewBox.List = {netWinBox_edgeColor, netWinBox_faceColor, [netWinBox_width netWinBox_height], [netWinBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width netWinBox_height], [0 TrialRecord.User.params.rewBox_yPos - netWinBox_height]};
else
    sc6_tc.Duration = times.sc6_postTrial_short_ms;
    dashboard(4, 'SCENE: POST TRIAL SHORT (6)', 'FontSize', 8);
end

% --- add reward box
sc6_postTrial = AllContinue(sc6_tc);
sc6_postTrial.add(rewBox);

% --- RUN SCENE
scene6 = create_scene(sc6_postTrial);
run_scene(scene6, TrialRecord.User.codes.sc6_postTrial);


% -------------------------------------------------------------------------
% --- SAVE DATA TO BHV2 FILE
% NOTE!!: Make sure 'File type' dropdown in GUI is set to BHV2.  Matlab
% format (.mat) works but can't figure out how to control which variables
% get saved to matlab outfile

switch TrialRecord.User.params.stimulusType

    case 'bars'
        bhv_variable( ...
            'TrialRecord', TrialRecord, ...
            'choices', choices, ...
            'condArray', TrialRecord.User.condArray, ...
            'params', TrialRecord.User.params, ...
            'movieFrames', TrialRecord.User.movieFrames, ...
            'movieFrameTimes', TrialRecord.User.movieFrameTimes);

    case 'curves'

        bhv_variable( ...
            'TrialRecord', TrialRecord, ...
            'choices', choices, ...
            'condArray', TrialRecord.User.condArray, ...
            'params', TrialRecord.User.params, ...
            'movieFrames', TrialRecord.User.movieFrames, ...
            'movieFrameTimes', TrialRecord.User.movieFrameTimes, ...
            'movieParams', TrialRecord.User.movieParams);
end



