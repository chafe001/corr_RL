% -----------------------------------------------------------------------
% ------------------------  HebbRL TASK CODE ---------------------------
% -----------------------------------------------------------------------

% GOAL. To devise a task that can measure synaptic (neural) plasticity in
% humans, animal, and computational models, parsing Hebbian and RPE
% components to investigate their interaction.

% FRAMEWORK. Each trial, a sequence of stimulus pairs is presented.
% A-state and B-state are associated with different pairs.  Subjects learn
% which pairs are associated with each state. Stimulus conditions are
% established that modulate the associative strength of the pairs. States
% imply reward probabilities on two choices.  Selection of choices 
% generates reward prediction errors. This allows us to study the 
% interaction between Hebbian plasticity and RL.

% VERSION HISTORY
% --- v1: 
% Select 4 stimuli consisting of randomly selected positions and stimulus
% images for each block of trials
% Construct stimulus pairs out of the 4 stimuli and associate the pairs
% with A-state and B-state within each block
% Cross images into A and B-state pairs so each individual stimulus is
% associated with A-state and B-state with equal probability, meaning that
% state is defined only by stimulus pairs, not individual sitmuli
% Build conditions array that randonly assigns stimulus pairs to
% condition numbers
% Build trials array that specifies how many times to replicate each
% condition
% Build state engine for trial with the following state sequence,
% preTrial, fix, stim_sequence, delay, choice, reward, posttrial

% *************************************************************************************************
% *************************************************************************************************
% ***************************** SET TASK CONTROLLING PARAMETERS BELOW *****************************
% *************************************************************************************************
% *************************************************************************************************

% -------------------------------------------------------------------------
% -------------------------- PARAMETERS -----------------------------------
% -------------------------------------------------------------------------
dbstop if error;
showcursor(true);
taskObj_fix = 1;
eye_radius = 2;
joy_radius = 2;
visualFeedback = true;
rew.duration = 200;
rew.numDrops = 1;

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------
% Each scene has a combined eye and joystick fixation wait_then_hold (wth) period
times.pretrial = 1000; 
% scene 1 is eye joy wth before the cue movie
times.sc1_wait = 1000;            
times.sc1_hold = 300;
% scene 2 presents the cue movie
times.sc2_wait = 0;                
times.sc2_hold = 4000; 
% scene 3 requires eye and joystick fixation wth
times.sc3_wait = 0;               
times.sc3_hold = 3000;   
% scene 3 timing is controlled by MultiTarget() joystick response
times.sc3_mt_wait = 5000;
times.sc3_mt_hold = 300;
times.sc4_wait = 3000;             % Time allowed to make response to one of two target windows (MultiTarget)
times.sc4_hold = 75;               % Time required to hold response in the chosen target window (MultiTarget)    
times.rewRing = 120;               % screen refresh units, 2 secs at 60 Hz


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
codes.joyFix = 13;
codes.startMovie = 20;
codes.startDelay = 150;
codes.choicesOn = 160;
codes.choiceMade = 170;
codes.chose1 = 171;
codes.chose2 = 172;
codes.ringOn = 180;
codes.reward = 190;
codes.brokeJoy = 200;
codes.brokeEye = 201;
codes.brokeBoth = 202;
codes.noEye = 203;
codes.noJoy = 204;
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
    [conditions, trials, params, stimPos, stimImage] = HebbRL_buildTrials();
    % store output in TrialRecord so variables live (have scope) beyond
    % this trial.  Other variables in script are only defined during the
    % trial.
    TrialRecord.User.conditions = conditions;
    TrialRecord.User.trials = trials;
    TrialRecord.User.params = params;
    TrialRecord.User.stimPos = stimPos;
    TrialRecord.User.stimImage = stimImage;
    % init trialsLeft to full trial array
    TrialRecord.User.trialsLeft = trials;
end

% -------------------------------------------------------------------------
% -------------- SET STIMULUS MOVIE FOR THIS TRIAL BELOW ------------------
% -------------------------------------------------------------------------
[movieFrames] = HebbRL_generateStimMovie(TrialRecord);
% Save movie to TrialRecord
TrialRecord.User.movieFrames = movieFrames;

% -------------------------------------------------------------------------
% ----------------- SET CHOICE ARRAY AND REWARD PROB ----------------------
% -------------------------------------------------------------------------
% Set the properties needed to specify choice target locations using
% MulitTarget()

% Set the choice target locations, left and right
TrialRecord.User.leftTarg = [-4 0];
TrialRecord.User.rightTarg = [4 0];

% set the choice stimulus images, these are fixed, and the feedback image
% choices.stim1.img = 'redChoice.png';
% choices.stim2.img = 'greenChoice.png';
% choices.feedbackImg = 'rewRing.png';

choices.stim1.img = 'redChoice sm.png';
choices.stim2.img = 'greenChoice sm.png';
choices.feedbackImg = 'rewRing sm.png';

% set the choice high and low reward probabilities
choices.highProb = 1.0;
choices.lowProb = 0;

% determine this condition number based on trial record
c = TrialRecord.CurrentCondition;

% assign reward probabilites based on state
% State = 1: stim1 high reward prob
% State = 2: stim2 high reward prob
switch TrialRecord.User.conditions(c).state
    case 1 % A-state, stim1 high reward prob
        choices.stim1.rewProb = choices.highProb;  % RED target
        choices.stim2.rewProb = choices.lowProb;
    case 2 % B-state, stim2 high reward prob
        choices.stim1.rewProb = choices.lowProb;
        choices.stim2.rewProb = choices.highProb; % GREEN TARGET
end

% set locations of high and low reward probability targets
% choices.config = 1: high reward probablity left
% choices.config = 2: high reward probablity right
switch TrialRecord.User.conditions(c).choice.config
    case 1  % high reward prob LEFT
        switch TrialRecord.User.conditions(c).state
            case 1  % stim1 is high reward probability, place stim1 LEFT
                choices.stim1.loc = TrialRecord.User.leftTarg;
                choices.stim2.loc = TrialRecord.User.rightTarg;
            case 2 % stim2 is high reward probability, place stim2 LEFT
                choices.stim1.loc = TrialRecord.User.rightTarg;
                choices.stim2.loc = TrialRecord.User.leftTarg;
        end

    case 2  % high reward prob RIGHT
        switch TrialRecord.User.conditions(c).state
            case 1  % stim1 is high reward probability, place stim1 RIGHT
                choices.stim1.loc = TrialRecord.User.rightTarg;
                choices.stim2.loc = TrialRecord.User.leftTarg;
            case 2 % stim2 is high reward probability, place stim2 RIGHT
                choices.stim1.loc = TrialRecord.User.leftTarg;
                choices.stim2.loc = TrialRecord.User.rightTarg;
        end

end

% Save choices to TrialRecord
TrialRecord.User.choices = choices;

% -------------------------------------------------------------------------
% ----------------- PRINT TRIAL INFO TO USER SCREEN -----------------------
% -------------------------------------------------------------------------
% Output trial info:
b = TrialRecord.CurrentBlock;
c = TrialRecord.CurrentCondition;
s = TrialRecord.User.conditions(c).state;
ch = TrialRecord.User.conditions(b, 1).choice.config;
switch s
    case 1
        hp = 'red targ';
    case 2
        hp = 'green targ';
end

outstr1 = strcat('b:', num2str(b), ' c:', num2str(c), ' s:', num2str(s), ' hp:', hp, ' ch:', num2str(ch));
dashboard(1, outstr1);

% Output stimulus pair info:
% pair ID string
pid = TrialRecord.User.conditions(c).pair.id;
% stim 1
s1pos = num2str(TrialRecord.User.conditions(c).pair.stim1.pos.posXY);
% stim 2
s2pos = num2str(TrialRecord.User.conditions(c).pair.stim2.pos.posXY);
outstr2 = strcat('pid:', pid, '  s1pos:', s1pos, '  s2pos:', s2pos);
dashboard(2, outstr2);

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

% Present fixation target and establish XY position window for joy
sc1_joyCenter = SingleTarget(joy_);
sc1_joyCenter.Target = taskObj_fix;
sc1_joyCenter.Threshold = joy_radius;

% Mark behavioral event: joy fixation
sc1_joyCenter_oom = OnOffMarker(sc1_joyCenter);
sc1_joyCenter_oom.OnMarker = codes.joyFix; %'joyFixAcq'
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
else  % fixation acquired but broken
    trialerror(3);    %'Break fixation'
    abortTrial = true;
    % figure out which fixation was broken, eye or joy, by checking last
    % sampled value of Success property at time that adapter chain
    % terminated
    if sc1_eyeCenter.Success && ~sc1_joyCenter.Success
        idle(0, [], codes.brokeJoy);
    elseif ~sc1_eyeCenter.Success && sc1_joyCenter.Success
        idle(0, [], codes.brokeEye);
    elseif ~sc1_eyeCenter.Success && ~sc1_joyCenter.Success % not likely, but possible
        idle(0, [], codes.brokeBoth);
    end
end

% bomb trial if error
if abortTrial
%     cleanupTrial('sc1', TrialRecord);
    return;
end

% -------------------------------------------------------------------------
% SCENE 2: STIMULUS SEQUENCE
% This scene shows the stimulus movie

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
sc2_wtHold.WaitTime = times.sc2_wait;
sc2_wtHold.HoldTime = times.sc2_hold;

% Generate and present the cue movie
% ImageChanger()
% Success: true when all images presented
% Stop: when Success becomes true
% Input properties: List, n-by-3, n-by-4, or n-by-5 matrix
% 1st column: Image filename(s) or function string(s) (see Remarks)
% 2nd column: Image XY position(s) in visual angles, an n-by-2 matrix ([x1 y1; x2 y2; ...])
% 3rd column: Duration in number of frames (or in milliseconds. See the DurationUnit property below.)
% 4th column: Eventmarker(s); optional
% 5th column: Resize parameter, [Xsize Ysize] in pixels; optional
% Example:
% 
% img = ImageChanger(null_);
% img.List = {
%     {'A.bmp','C.bmp'}, [5 5; -5 -5], 15, 101; ...
%     [], [], 15, []; ...  % 15 frames' blank
%     {'B.bmp','D.bmp'}, [5 5; -5 -5], 15, 102; ...
%     [], [], 15, []; ...
%     {'C.bmp','A.bmp'}, [5 5; -5 -5], 15, 103; ...
%     [], [], 15, []; ...
%     {'D.bmp','B.bmp'}, [5 5; -5 -5], 15, 104; ...
%     [], [], 15, [];
% };   % The images in each row will be shown for 15 frames in turn.
% INTENDED BEHAVIOR: present a movie of rapidly flashed visual stimuli at
% randomly selected sequences indicating A and B-state.
sc2_movie = ImageChanger(null_);
% set ImageChanger object properties according to information stored in
% conditions array based on this condition number
c = TrialRecord.CurrentCondition;

% Build cell array to pass to ImageChanger: determine which frames to 
% present the target pair and which frames to present noise pairs in the 
% movie
% [movieFrames] = HebbRL_generateStimMovie(conditions, stimPos, stimImage, params, TrialRecord);
sc2_movie.List = movieFrames;

% Concurrent()
% Success: true when first chain succeeds
% Stop: when the first chain stops
% INTENDED BEHAVIOR: Concurrent() will run wtHold and image at the same
% time but scene timing will depend on wtHold only, if this is the first
% adaptor added.
sc2_wtHold_movie = Concurrent(sc2_wtHold);
sc2_wtHold_movie.add(sc2_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_wtHold_movie, taskObj_fix);
scene2_start = run_scene(scene2);

% --- CHECK BEHAVIORAL OUTCOMES
if sc2_wtHold.Success
    % no action needed
elseif sc2_wtHold.Waiting
    trialerror(4);  %'No fixation'
    idle(0, [], codes.noEye);
    abortTrial = true;
else  % fixation acquired but broken
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    % figure out which fixation was broken, eye or joy
    if sc2_eyeCenter.Success && ~sc2_joyCenter.Success
        idle(0, [], codes.brokeJoy);
    elseif ~sc2_eyeCenter.Success && sc2_joyCenter.Success
        idle(0, [], codes.brokeEye);
    elseif ~sc2_eyeCenter.Success && ~sc2_joyCenter.Success % not likely, but possible
        idle(0, [], codes.brokeBoth);
    end
end

% bomb trial if error
if abortTrial
%     cleanupTrial('sc2', TrialRecord);
    return;
end

% -------------------------------------------------------------------------
% SCENE 3: CHOICE
% Display choice targets

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = eye_radius;

% pass eye to WaitThenHold
sc3_wtHold = WaitThenHold(sc3_eyeCenter);
sc3_wtHold.WaitTime = times.sc3_wait;
sc3_wtHold.HoldTime = times.sc3_hold; % entire duration of scene

% MultiTarget()
% SUCCESS: true when joystick enters the response window around one target AND is maintained 
% in the window for HoldTime
% STOP: when success becomes true, or when WaitTime expires with entering
% one of the response windows
% INPUT: 
% Target: graphic adapters, or TaskObjects, or an n-by-2 matrix [x1 y1; x2 y2...]
% Threshold: radius of the target window
% WaitTime: maximum time to wait for joystick to enter a window
% HoldTime: time required to maintain joystick in response window
% TurnOffUnchosen: true (by default) or false to turn off unchosen target
% OUTPUT:
% Waiting: true if choice was never made
% AcquiredTime: trialtime when XY tracker crossed the threshold window of
% the chosen target
% RT: Reaction time, difference between time of the first frame of the
% scene and the AcquiredTime
% ChosenTarget: TaskObject#, if used, or the ordinal number of the chosen
% target, if the targets were graphics adaptors or XY coordinates.
% ChoiceHistory: [ChosenTarget1 AcquiredTime1; ChosenTarget2 AcquiredTime2;...]

sc3_img = ImageGraphic(null_);
sc3_img.List = {choices.stim1.img, choices.stim1.loc; choices.stim2.img, choices.stim2.loc};
sc3_mTarg_joy = MultiTarget(joy_);
sc3_mTarg_joy.setTarget(sc3_img);
sc3_mTarg_joy.Threshold = joy_radius;
sc3_mTarg_joy.WaitTime = times.sc3_mt_wait;
sc3_mTarg_joy.HoldTime = times.sc3_mt_hold;
sc3_mTarg_joy.TurnOffUnchosen = false;

% Mark behavioral event: probeResp, when MultiTarget choice is acquired
sc3_mTarg_joy_oom = OnOffMarker(sc3_mTarg_joy);
sc3_mTarg_joy_oom.OffMarker = codes.choiceMade;
% Mark event when waiting goes from true to false, start of joy
% fixation at selected MultiTarget choice
sc3_mTarg_joy_oom.ChildProperty = 'Waiting';

% AllContinue will be used to continue eye fix, probe image changer, and
% joy multitarget. It will stop once any one of these stops (hopefully, joy
% causing multitarget success).
sc3_resp = AllContinue(sc3_mTarg_joy_oom); % this will hopefully end scene when joy moves
sc3_resp.add(sc3_wtHold);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
% scene6 will terminate when gaze hold at center is complete, hold time is
% 250 ms, which corresponds to probe duration
scene3 = create_scene(sc3_resp, taskObj_fix);
scene3_start = run_scene(scene3, codes.choicesOn);

% --- CHECK BEHAVIORAL OUTCOMES
if sc3_mTarg_joy.Success % response made to one of two response windows, not nessarily the correct one
    if sc3_mTarg_joy.ChosenTarget == 1 % red target
        eventmarker(codes.chose1);
    elseif sc3_mTarg_joy.ChosenTarget == 2 % incorrect target
        eventmarker(codes.chose2);
    end
elseif sc3_mTarg_joy.Waiting
    idle(0, [], codes.noJoy);
    trialerror(1);  %'No response'
    abortTrial = true;
elseif sc3_eyeCenter.Success
    % scene terminated with eye in window. Therefore eye did not cause
    % scene to terminate. The joystick caused the scene to terminate.
    % Joystick not success, not waiting, therefore joystick must have
    % acquired target but not been held for HoldTime
    idle(0, [], codes.brokeJoy);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
elseif ~sc3_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
end

% bomb trial if error
if abortTrial
%     cleanupTrial('sc4', TrialRecord);
    return;
end


% -------------------------------------------------------------------------
% SCENE 4: TRIAL REWARD/ FEEDBACK
% Give probabilistic reward and visual feedback if enabled

% --- BUILD ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc4_eyeCenter = SingleTarget(eye_);
sc4_eyeCenter.Target = taskObj_fix;
sc4_eyeCenter.Threshold = eye_radius;

% Present fixation target and establish XY position window for joy
sc4_joyCenter = SingleTarget(joy_);
sc4_joyCenter.Target = taskObj_fix;
sc4_joyCenter.Threshold = joy_radius;

% AND eye and joy
sc4_eyejoy = AndAdapter(sc4_eyeCenter);
sc4_eyejoy.add(sc4_joyCenter);

% pass eye AND joy to WaitThenHold
sc4_wtHold = WaitThenHold(sc4_eyejoy);
sc4_wtHold.WaitTime = times.sc4_wait;
sc4_wtHold.HoldTime = times.sc4_hold;

% replace choice targets in current configuration (copied from scene 3), so
% not erased when scene 4 is run
sc4_img = ImageGraphic(null_);
sc4_img.List = {choices.stim1.img, choices.stim1.loc; choices.stim2.img, choices.stim2.loc};

sc4_allCont = AllContinue(sc4_wtHold);
sc4_allCont.add(sc4_img);


% --- DETERMINE WHETHER TO REWARD TRIAL
% select random number between 0 and 1
randNum = rand();
% initialize reward trial to false
rewardTrial = false;
% set rewardTrial to true if randNum is less than or equal to reward probability
% associated with the selected target
if sc3_mTarg_joy.ChosenTarget == 1 % red target
    if randNum <= choices.stim1.rewProb
        rewardTrial = true;
        rewLoc = choices.stim1.loc;
    end
elseif sc3_mTarg_joy.ChosenTarget == 2 % green target
    if randNum <= choices.stim2.rewProb
        rewardTrial = true;
        rewLoc = choices.stim2.loc;
    end
end

% --- DISPLAY REWARD RING IF ENABLED
if visualFeedback && rewardTrial
    sc4_feedbackImg = ImageChanger(null_);
    sc4_feedbackImg.List = {choices.feedbackImg , rewLoc, times.rewRing, codes.ringOn};
    sc4_resp = Concurrent(sc4_allCont);
    sc4_resp.add(sc4_feedbackImg);
else % all other cases, 
    sc4_resp = sc4_allCont;
end

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene4 = create_scene(sc4_resp, taskObj_fix);
% run_scene here erases choice targets
scene4_start = run_scene(scene4); 

% --- CHECK BEHAVIORAL OUTCOMES
if sc4_wtHold.Success
    idle(0);
elseif sc4_wtHold.Waiting
    idle(0, [], codes.noJoy); % turns FIX OFF
    trialerror(4);  %'No fixation'
    abortTrial = true;
else  % fixation acquired but broken
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    % figure out which fixation was broken, eye or joy
    if sc4_eyeCenter.Success && ~sc4_joyCenter.Success
        idle(0, [], codes.brokeJoy);
    elseif ~sc4_eyeCenter.Success && sc4_joyCenter.Success
        idle(0, [], codes.brokeEye);
    elseif ~sc4_eyeCenter.Success && ~sc4_joyCenter.Success % not likely, but possible
        idle(0, [], codes.brokeBoth);
    end
end

% bomb trial if error
if abortTrial
   % HebbRL_cleanupTrial('sc5', TrialRecord);
    return;
end

% --- REWARD
if rewardTrial
    goodmonkey(rew.duration, 'juiceline',1, 'numreward', rew.numDrops, 'pausetime',500, 'eventmarker', [codes.reward1 codes.reward2]);
    trialerror(0);  %'Correct'
end
   idle(0);



