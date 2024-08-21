% -----------------------------------------------------------------------
% ------------------------  FRAMES TASK CODE ---------------------------
% -----------------------------------------------------------------------

% This is a derivative of HebbRL, focused more on sequence prediction as
% the driving idea. Starting with HebbRL code.

% VERSION HISTORY
% --- v1:


% *************************************************************************************************
% *************************************************************************************************
% ***************************** SET TASK CONTROLLING PARAMETERS BELOW *****************************
% *************************************************************************************************
% *************************************************************************************************

% -------------------------------------------------------------------------
% -------------------------- PARAMETERS -----------------------------------
% -------------------------------------------------------------------------
dbstop if error;
showcursor('on');
taskObj_fix = 1;
eye_radius = 3;
visualFeedback = true;
rew.duration = 200;
rew.numDrops = 1;

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------
% Each scene has a combined eye and joystick fixation wait_then_hold (wth) period
times.pretrial = 100;
% scene 1 is eye fixation
times.sc1_wait = 1000;
times.sc1_hold = 100;
% scene 2 presents the choice movie
times.sc2_wait = 0;
times.sc2_hold = 15000; % entire duration of scene
% scene 3 is feedback
times.sc3_wait = 0;
times.sc3_hold = 15000; % duration of scene depends on choice ring timing
times.choiceRing = 15;
times.rewRing = 20;               % screen refresh units
times.sc4_wait = 0;
times.sc4_hold = ((times.rewRing) * 60);

% save times to TrialRecord
TrialRecord.User.times = times;

% *************************************************************************************************
% *************************************************************************************************
% ******************* SET INFORMATION FOR TASK EVENT TIMESTAMPS BELOW *****************************
% *************************************************************************************************
% *************************************************************************************************

% -------------------------------------------------------------------------
% --------------------------- EVENT CODES ---------------------------------
% -------------------------------------------------------------------------
% Event codes are time stamps used to relate neural data to behavioral
% events

% sending 8 bits to SpikeGadgets so max event code value is 256
codes.fixTargOn = 11;
codes.eyeFix = 12;
codes.startMovie = 20;
codes.choiceMade = 170;
codes.choseKey1 = 171;
codes.choseKey2 = 172;
codes.choseBothKeys = 173;
codes.choiceRingOn = 180;
codes.rewRingOn = 181;
codes.reward = 190;
codes.brokeEye = 200;
codes.noEye = 203;
codes.reward1 = 205;
codes.reward2 = 206;

% save event codes to TrialRecord
TrialRecord.User.eventCodes = codes;


% *************************************************************************************************
% *************************************************************************************************
% *********** PERFORM CPU DEMANDING OVERHEAD BELOW (BEFORE RUNNING TRIAL) *************************
% *************************************************************************************************
% *************************************************************************************************

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
% each trial, which controls the cue movie by constraining the movie
% generating function
if TrialRecord.CurrentTrialNumber == 1
    % [conditions, trials, params, stimPos, stimImage] = framesTask_buildTrials_noChoiceTarg();
    [conditions, condReps, params, stimPos, stimImage] = framesTask_buildTrials_v2();
    % store output in TrialRecord so variables live (have scope) beyond
    % this trial.  Other variables in script are only defined during the
    % trial.
    TrialRecord.User.conditions = conditions;
    TrialRecord.User.condReps = condReps;
    TrialRecord.User.params = params;
    TrialRecord.User.stimPos = stimPos;
    TrialRecord.User.stimImage = stimImage;
    % init condition reps remaining counter (condRepRem) to initial
    % condition rep array
    TrialRecord.User.condRepsRem = condReps;
    TrialRecord.User.times = times;
    TrialRecord.User.eventCodes = codes;
 
end

% -------------------------------------------------------------------------
% -------------- SET STIMULUS MOVIE FOR THIS TRIAL BELOW ------------------
% -------------------------------------------------------------------------
[movieFrames] = framesTask_generateStimMovie_v2(TrialRecord);
% Save movie to TrialRecord
TrialRecord.User.movieFrames = movieFrames;

% -------------------------------------------------------------------------
% ---------------------- SET CHOICE REWARD PROB ---------------------------
% -------------------------------------------------------------------------

% set the choice feebback images
choices.rewImg = 'rewRing.png';
choices.choiceImg = 'choiceRing.png';

% set the choice high and low reward probabilities
choices.highProb = 1.0;
choices.lowProb = 0;

% init choseKey to null to prevent crash when not defined after manually
% quitting program
choices.choseKey = [];

% determine this condition number based on trial record
c = TrialRecord.CurrentCondition;

% assign reward probabilites based on state
% State = 1: KEY1 high reward prob
% State = 2: KEY2 high reward prob
switch TrialRecord.User.conditions(c).state
    case 1 % A-state, KEY1 high reward prob
        choices.key1.rewProb = choices.highProb; 
        choices.key2.rewProb = choices.lowProb;
    case 2 % B-state, KEY2 high reward prob
        choices.key1.rewProb = choices.lowProb;
        choices.key2.rewProb = choices.highProb; 
end

% Save choices to TrialRecord
TrialRecord.User.choices = choices;

% -------------------------------------------------------------------------
% ----------------- PRINT TRIAL INFO TO USER SCREEN -----------------------
% -------------------------------------------------------------------------
% Output trial info:

t = TrialRecord.CurrentTrialNumber;
c = TrialRecord.CurrentCondition;
state = TrialRecord.User.conditions(c).state; 

switch state
    case 1
        hp = ' KEY_1';
    case 2
        hp = ' KEY_2';
end
condRepsRem = TrialRecord.User.condRepsRem(c);

outstr1 = strcat('Trial:', ' ', num2str(t), ' Cond:', ' ', num2str(c), ' trls remaining cond:', ' ', num2str(condRepsRem), ' HighProb:', ' ', hp);
dashboard(1, outstr1);

% Output block control info
b = TrialRecord.CurrentBlock;
trl_b = TrialRecord.CurrentTrialWithinBlock;
conds_b = TrialRecord.ConditionsThisBlock;

outstr2 = strcat('Block:', ' ', num2str(b), ' Trial in block:', ' ', num2str(trl_b), ' Conds in block:', ' ', num2str(conds_b));
dashboard(2, outstr2);

% Output block params
pid = TrialRecord.User.conditions(c).pair.id;
pstr = TrialRecord.User.conditions(c).strength;
outstr3 = strcat('Pair id:', ' ', pid, ' Pair strength:', ' ', pstr);
dashboard(3, outstr3);

% -------------------------------------------------------------------------
% ------------------------ CHECK HARDWARE ---------------------------------
% -------------------------------------------------------------------------

% check eye input is detected
if ~exist('eye_','var'), error('This task requires eye signal input. Please set it up or try the simulation mode.'); end

% set hotkey for exit
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');


% *************************************************************************************************
% *************************************************************************************************
% ************************ BUILD AND RUN SCENES (RUN TRIAL) BELOW *********************************
% *************************************************************************************************
% *************************************************************************************************

% flag to call 'return' to end trial prematurely if error
abortTrial = false;

% write event codes to DAQ to capture ML trial number and condition
% number in SpikeGadgets datafile
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);

% >>> SAVE BEHAVIORAL EVENT
% --- write three eventcodes, each an 8-bit word, to DAQ at trial start that reflect ML condition
% number and trial number
idle(times.pretrial, [], [TrialRecord.CurrentCondition mult256 mod256]);

% -------------------------------------------------------------------------
% PRETRIAL period
% idle(duration, [RGB], eventcodes) changes background color, has timer
% built in, and writes event codes. Empty brackets for screen color leaves
% color unchanged.

% write event codes to DAQ to capture ML trial number and condition
% number in SpikeGadgets datafile
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);

% >>> SAVE BEHAVIORAL EVENT
% --- write three eventcodes, each an 8-bit word, to DAQ at trial start that reflect ML condition
% number and trial number
idle(times.pretrial, [], [TrialRecord.CurrentCondition mult256 mod256]);

% -------------------------------------------------------------------------
% SCENE 1: PRECUE FIX
% Direct eye and joy positions to target at screen center

% --- BUILD ADAPTOR CHAINS
% ML provides a library of 'adapters'.  Each performs a rudimentary
% function (monitor eye position, present stimulus, set timer, etc). We
% concatenate adapters to create functions with complex properties.
% Adaptors are objects.  One object is instantiated then passed as an
% argument to the constructor for the next object (concatenation).
% Thus the 'parent' adaptor inherits the properties of the 'child' adaptor
% (passed to the constructor for the parent).

% see: https://monkeylogic.nimh.nih.gov/docs.html for documentation, in
% particular, see:
% https://monkeylogic.nimh.nih.gov/docs_RuntimeFunctions.html for a
% description of the timing script functions (adapters)

% SingleTarget()
% Success: true while the position of the XY signal is within the window,
% false otherwise
% Stop: When success becomes true
% Input properties: TaskObj# or 2-element vector [X,Y], in degrees
% Output properties: Time (when signal enters window)

% Present fixation target and establish XY position window for eye
sc1_eyeCenter = SingleTarget(eye_); % instantiate object
sc1_eyeCenter.Target = taskObj_fix; % set stimulus for fixation target
sc1_eyeCenter.Threshold = eye_radius; % set tolerance for eye position

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
sc1_eyeCenter_oom.OnMarker = codes.eyeFix; %'eyeFixAcq'
sc1_eyeCenter_oom.ChildProperty = 'Success';

% WaitThenHold()
% Success: true if the Success of the child adapter becomes true within
% WaitTime AND stays true for HoldTime, false, until then.
% Stop: When Success becomes true OR when WaitTime is over without any
% fixation attempt OR when the acquried fixation is broken before HoldTime
% passes
% INTENDED BEHAVIOR: the Success condition of the adaptor chain will become
% true IF eye and joy enter their respective windows in WaitTime AND eye
% and joy remain in their windows for HoldTime.
sc1_wtHold = WaitThenHold(sc1_eyeCenter_oom);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc1_wtHold.WaitTime = times.sc1_wait;
sc1_wtHold.HoldTime = times.sc1_hold;

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_wtHold, taskObj_fix);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, codes.fixTargOn); %'fixOn'

% --- CHECK BEHAVIORAL OUTCOMES
% Note: this status checking structure copied from ML documentation on
% WaitThenHold()
if sc1_wtHold.Success
    % no action needed
elseif sc1_wtHold.Waiting
    idle(0, [], codes.noEye);
    trialerror(4); %'No fixation'
    abortTrial = true;
elseif ~sc1_eyeCenter.Success
    idle(0, [], codes.brokeEye);
end

% bomb trial if error
if abortTrial
    %     cleanupTrial('sc1', TrialRecord);
    return;
end

% -------------------------------------------------------------------------
% SCENE 2: CUE MOVIE
% Using keypress response in this version of the code to collect behavioral
% data in human subjects

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc2_eyeCenter = SingleTarget(eye_);
sc2_eyeCenter.Target = taskObj_fix;
sc2_eyeCenter.Threshold = eye_radius;

% pass eye to WaitThenHold
sc2_wtHold = WaitThenHold(sc2_eyeCenter);
sc2_wtHold.WaitTime = times.sc2_wait;
sc2_wtHold.HoldTime = times.sc2_hold; % entire duration of scene

% instantiate key checkers
sc2_key1 = KeyChecker(mouse_);
sc2_key1.KeyNum = 1;  % 1st keycode in GUI
sc2_key2 = KeyChecker(mouse_);
sc2_key2.KeyNum = 2;  % 2nd keycode in GUI
sc2_watchKeys = OrAdapter(sc2_key1);
sc2_watchKeys.add(sc2_key2);

% Concurrent()
% Success: true when first chain succeeds
% Stop: when the first chain stops
% INTENDED BEHAVIOR: Concurrent() will run MultiTarget and movie at the same
% time but scene timing will depend on joystick response and hold,
% terminating MultiTarget(), bceause joyResp is the first child adaptor passed
% to Concurrent, and the only one monitored therefore to control timing.

% For keyboard response, key strike will terminate scene
sc2_movieResp = Concurrent(sc2_watchKeys);

% add waitThenHold
sc2_movieResp.add(sc2_wtHold)

% Instantiate and add ImageChanger object containing the movie
% (movieFrames) and add to Concurrent() object sc2_movieResp
sc2_movie = ImageChanger(null_);
sc2_movie.List = movieFrames;
sc2_movieResp.add(sc2_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_movieResp, taskObj_fix);
scene2_start = run_scene(scene2);

if sc2_key1.Success && ~sc2_key2.Success
    choices.choseKey = 1;
    eventmarker(codes.choseKey1);
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    dashboard(4, sprintf('Key 1 press time: %d ms', sc2_key1.Time(1)));

elseif sc2_key2.Success && ~sc2_key1.Success
    choices.choseKey = 2;
    eventmarker(codes.choseKey2);
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    dashboard(4, sprintf('Key 2 press time: %d ms', sc2_key2.Time(1)));

elseif sc2_key1.Success && sc2_key2.Success
    error('Both keys hit');
    choices.choseKey = 0;
    eventmarker(codes.choseBothKeys);
    abortTrial = true;

elseif ~sc2_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.choseKey = 0;
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;

end


% -------------------------------------------------------------------------
% SCENE 3: TRIAL REWARD/ FEEDBACK
% Give probabilistic reward and visual feedback if enabled

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = eye_radius;

% pass eye AND joy to WaitThenHold
sc3_wtHold = WaitThenHold(sc3_eyeCenter);
sc3_wtHold.WaitTime = times.sc3_wait;
sc3_wtHold.HoldTime = times.sc3_hold;

% --- DETERMINE WHETHER TO REWARD TRIAL
% select random number between 0 and 1
randNum = rand();
% initialize reward trial to false
choices.rewardTrial = false;
% set rewardTrial to true if randNum is less than or equal to reward probability
% associated with the selected key
if choices.choseKey == 1 
    if randNum <= choices.key1.rewProb
        choices.rewardTrial = true;
    end
elseif choices.choseKey == 2 % green target
    if randNum <= choices.key2.rewProb
        choices.rewardTrial = true;
    end
end

% --- SAVE
% CHOICE INFORMATION
TrialRecord.User.Choices = choices;

% --- DISPLAY CHOICE AND REWARD FEEDBACK
if visualFeedback && choices.rewardTrial
    sc3_rewImg = ImageChanger(null_);
    sc3_rewImg.List = {choices.choiceImg , [0 0], times.choiceRing, codes.choiceRingOn;...
        choices.rewImg , [0 0], times.rewRing, codes.rewRingOn};
elseif visualFeedback % all other cases,
    sc3_rewImg = ImageChanger(null_);
    sc3_rewImg.List = {choices.choiceImg , [0 0], (times.rewRing + times.choiceRing), codes.choiceRingOn};
end

% --- COMBINE EYE WTH with FEEDBACK
sc3_probRew = Concurrent(sc3_rewImg);
sc3_probRew.add(sc3_wtHold);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_probRew, taskObj_fix);
scene3_start = run_scene(scene3);

% --- CHECK BEHAVIORAL OUTCOMES
if sc3_wtHold.Success
    idle(0);
elseif sc3_wtHold.Waiting
    idle(0, [], codes.noEye);
    trialerror(4);
    abortTrial = true;
else  % fixation acquired but broken
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
end

% bomb trial if error
if abortTrial
    % framesTask_cleanupTrial('sc5', TrialRecord);
    return;
end


% --- SAVE DATA TO BHV2 OUTFILE
bhv_variable('conditions', TrialRecord.User.conditions, 'stimTimes', sc2_movie.Time, 'movieFrames', TrialRecord.User.movieFrames);

% --- REWARD
if choices.rewardTrial
    goodmonkey(rew.duration, 'juiceline',1, 'numreward', rew.numDrops, 'pausetime',500, 'eventmarker', [codes.reward1 codes.reward2]);
    trialerror(0);  %'Correct'
end
idle(0);




