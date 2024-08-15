% TBT is the translational bandit task for the P50
% 3 arm version!

% BLOCK STRUCTURE:
% Block 1: all
% Block 2: A left only
% Block 3: A right only
% Block 4: A up only
% Block 5: no A left
% Block 6: no A right
% Block 7: no A up

% TO-DO: 
% - save a variable for which direction was moved
% - reduce joy radius

% MonkeyLogic:
% Monkey logic is a behavioral control program based in
% Matlab that can present stimuli, monitor eye position, and register
% subject responses at 1 ms resolution.

% For additional support and information on MonkeyLogic, see
% https://monkeylogic.nimh.nih.gov/

% TASK SEQUENCE:
% (Scene 1) Gaze fixation on central fixation dot

% (Scene 2) Present stimuli & make choice
% - Present 2 stimuli, offset from center, for 600 ms
% - Able to respond for up to the entire 1600 ms block

% (Scene 3) Return joy to center
% old: Fixation dot only for rest of response period (up to 1000 ms)
% - Only if no response in first 600 ms with stimuli on screen

% (Scene 4) Feedback - Fixation dot, all stimuli, box around selected
% - Randomized 400-800 ms timing
% end with reward (set amount based on walking probabilities?)

% ITI randomized 500-1500 timing

% In the monkey experiments, MonkeyLogic will generate time-stamped event
% codes that will be sent to data collection computers to align neural
% data with behavioral events

% MonkeyLogic was written in Matlab by Betsy Murray's lab at
% NIH and can be downloaded from the site above.

% Programming in MonkeyLogic:
% See: 'Creating a Task', and 'Running a Task' in the help files at
% https://monkeylogic.nimh.nih.gov/docs.html to get started
% The basics:
% - each task is a sequence of scenes
% - each scene presents stimuli and monitors responses
% - each scene is implemented by 'adaptors'
% - adaptors are chunks of prewritten code
% - ML provides a library of adaptors to use
% - For descriptions of the adaptors available see:
% - https://monkeylogic.nimh.nih.gov/docs_RuntimeFunctions.html
% - scenes are constructed by combining adaptors
% - there are two ways to combine adaptors
% - 1. Logical operators (AND, OR, etc)
% - 2. Chaining
% - To chain adaptors, one adaptor is passed as an argument to the next
% - The topmost adaptor (the 'parent') inherits functionality of all child
% adaptors (examples below)
% - Once scene are created (written to memory), you then run the scenes in
% sequence to run a trial.
% - Each adaptor has SUCCESS and STOP conditions that govern how scenes
% advance in a trial. These can be based on time or subjects responses.
% - Further notes on chaining: many adaptors (SingleTarget, AndAdapter,
% etc) do not have timing properties. These can be passed to a parent
% adapter with timing properties (WaitThenHold), which will check for
% success of the child adapter across all the timing properties,
% essentially giving timing properties to the child adapters.
% - SUCCESS of topmost adaptor (passed to create_scene) stops the scene.

% -------------------------------------------------------------------------
% ---------------------- TASK CONTROL SWITCHES ----------------------------
% -------------------------------------------------------------------------

% --- Display joystick
% This will display the joystick cursor, but for both the experimenter and
% subject screen. Not sure there's a way to only display to experimenter
% screen, but I think the joystick cursor should show in replay.
showcursor(false);

% --- Multiple hits
% require that 2-n correct trials are performed in a row before delivering
% reward drops equal to the number of successive trials on the last trial.
% If multipleHits = 0, then disabled
multipleHits = 0; %3

% --- Randomize isi and iti to match human imaging experiments
rndTiming = false;

% Toggle for fully random reward walk
randRewWalk = false;

% Toggle for pregenerated pseudorandom reward walk
pseuRewWalk = true;

% Toggle for separating reward probabilities to prevent side bias
rewSepPrct = false;
% set the amount we are decreasing the other values by
medPrctDecr = 0.7;
lowPrctDecr = 0.5;

% -------------------------------------------------------------------------
% ------------------- INIT TRIAL FLAGS AND COUNTERS -----------------------
% -------------------------------------------------------------------------
% --- These variables track behavioral events for trial control

% How we're going to do reward walk - a global variable! Update each time,
% diff global var for each stim reward
global ArewProb
global BrewProb
global CrewProb

if randRewWalk
    if TrialRecord.CurrentTrialNumber == 1 % this is where we will initialize - should only go on trial one!
        ArewProb = 0.1;
        BrewProb = 0.2;
        CrewProb = 0.85;
    end
elseif pseuRewWalk
    if TrialRecord.CurrentTrialNumber == 1 % this is where we will initialize - should only go on trial one!
        
% %         [arm1walk, arm2walk, arm3walk] = generateBiasedWalk3(3, 2000, [0.1 0.9]);
%         [arm1walk, arm2walk, arm3walk] = generateWalkForBandit3_SMB(0.3, 1000, 1000, [10 90], 0.2);
%         % [T1,T2,T3] = generateWalkForBandit3(hazard,ntrials,chunk,bounds,stepSize)
%         % output 3 value vectors that match our requirements
%         % 1. bounded at bounds [LB UB], eg [10 90];
%         % 2. evens out every [chunk] trials, E(t1) =ish mean(E(t2),E(t3))
%         % 3. no more than 50 trials in each chunk where all ts < 20
%         % 4. [new!] won't let values be too close for a handful of trials
%         % in a row
%         % step size and hazard 0.1 in humans
% 
%         % change values to decimals
%         arm1walk = arm1walk./100;
%         arm2walk = arm2walk./100;
%         arm3walk = arm3walk./100;
% 
%         % save to .mat outfile for future reference
%         save(['reward walk outfiles\' datestr8601 'rewWalk_orig'], 'arm1walk', 'arm2walk', 'arm3walk');

        % load pregenerated walk
        pregeneratedwalk = load(['pregenerated walks' filesep 'randWalk51.mat']);

        % save to TrialRecord to refer to between trials
        TrialRecord.User.arm1walk = pregeneratedwalk.arm1walk; % allows us to reference with TrialRecord.User.arm1walk(TrialRecord.CurrentTrialNumber)
        bhv_variable('arm1walk', pregeneratedwalk.arm1walk);
        TrialRecord.User.arm2walk = pregeneratedwalk.arm2walk;
        bhv_variable('arm2walk', pregeneratedwalk.arm2walk);
        TrialRecord.User.arm3walk = pregeneratedwalk.arm3walk;
        bhv_variable('arm3walk', pregeneratedwalk.arm3walk);
    end

    if rewSepPrct
        % adjusting current probabilities to separate out the high arm from
        % the other two arms

        % get the reward probabilities for each arm on the current trial number
        origArewProb = TrialRecord.User.arm1walk(TrialRecord.CurrentTrialNumber);
        origBrewProb = TrialRecord.User.arm2walk(TrialRecord.CurrentTrialNumber);
        origCrewProb = TrialRecord.User.arm3walk(TrialRecord.CurrentTrialNumber);

        % sort to establish high/med/low on this trial
        allRews = [origArewProb, origBrewProb, origCrewProb];
        [sortedProbs, sortIndex] = sort(allRews, 'descend');

        % lower the lower two arms by the percentages given earlier
        % reduces the second index in sorted rewards (medium value)
        allRews(sortIndex(2)) = allRews(sortIndex(2)) * medPrctDecr;
        % reduces the last index in sorted rewards (lowest value)
        allRews(sortIndex(3)) = allRews(sortIndex(3)) * lowPrctDecr;

        % now, separate allRews back out into our individual reward values
        ArewProb = allRews(1);
        BrewProb = allRews(2);
        CrewProb = allRews(3);

    else
        % set the reward probabilities for each arm on the current trial number
        ArewProb = TrialRecord.User.arm1walk(TrialRecord.CurrentTrialNumber);
        BrewProb = TrialRecord.User.arm2walk(TrialRecord.CurrentTrialNumber);
        CrewProb = TrialRecord.User.arm3walk(TrialRecord.CurrentTrialNumber);
    end

else % these will be the static reward probabilities across the session
    ArewProb = 0.1;
    BrewProb = 0.85;
    CrewProb = 0.1;
end

% -------------------------------------------------------------------------
% --------------------------- CONSTANTS -----------------------------------
% -------------------------------------------------------------------------
% Task objects. Numbers are column indices in the conditions *.txt file and
% control how ML accesses stimulus information from the conditions file. We
% are using this mostly to control stimulus positions.  Stimuli identities
% are controlled by setting the filenames of *.png files to read from disk
taskObj_fix = 1;

% Change trialerror label
trialerror(5, 'no prob reward', 7, 'A stim chosen', 8, 'B stim chosen', 9, 'C stim chosen');

leftPos = [-4.5, -2];
rightPos = [4.5, -2];
upPos = [0, 4.5];

% Load images
Astim = 'greenpentagon.png'; % 'bluetriangle.png'
Bstim = 'bluetriangle.png'; % 'pinkcircle.png'
Cstim = 'orangerectangle.png';
feedbackBox = 'tbt_selection_box.png';

% Eye and joy fixation window (in degrees)
eye_radius = 3;
joy_radius = 3;

% Reward sizes
rewDur1 = 78;
numDrops1 = 2;

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
fixTargOn_eventCode = 11;
gazeFixAcq_eventCode = 12;
joyFixAcq_eventCode = 13; % Not too informative as self-centering joystick, but no harm
stimOnEventCode = 20;
stimOff_eventCode = 29;
joyOut_eventCode = 30;
AstimChosen_eventCode = 31;
BstimChosen_eventCode = 32;
CstimChosen_eventCode = 33;
retStart_eventCode = 40;
joyBack_eventCode = 49;
feedbackStart_eventCode = 50;
AstimFeedback_eventCode = 51;
BstimFeedback_eventCode = 52;
CstimFeedback_eventCode = 53;
feedbackOff_eventCode = 54;
noRewGiven_eventCode = 60;
rewDrop1_eventCode = 61;
rewDrop2_eventCode = 62;
rewDrop3_eventCode = 63;
rewDrop4_eventCode = 64;
rewDrop5_eventCode = 65;
rewDrop6_eventCode = 66;
brokeGazeFix_eventCode = 90;
brokeJoyFix_eventCode = 91;
brokeBothFix_eventCode = 92;
neverFix_eventCode = 93;
noJoy_eventCode = 94;

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
% --------------------------- SCENE TIMING --------------------------------
% -------------------------------------------------------------------------
pretrial_time = 500;
precue_eyejoy_waitTime = 1000;           % Time allowed to acquire eye and joystick fixation
precue_eyejoy_holdTime = 300;           % Time required to hold center eye and joystick at screen center before cue
stimDur = 2000;                      % Duration stimulus is on the screen in ms
afterStim = 100000;                 % Duration of blank screen after stimulus presentation while waiting for joy; should be very long
stim_joy_waitTime = 5000;          % Time allowed to make post-probe response to one of the stim targets (MultiTarget) % was 2000, increased to get rid of speed causing side bias
stim_joy_holdTime = 75;          % Time required to hold chosen peripheral target
postResp_joy_waitTime = 2000;           % Time to get joy back to center
postResp_joy_holdTime = 75;         % Time required to hold center joystick fixation after probe response and before feedback
beforeFeedback = 200;                   % Time in ms before feedback ring
feedbackTime = 300;                   % Time in ms of feedback ring
afterFeedback = 200;                   % Time in ms after feedback ring
feedback_eyejoy_waitTime = 0;           % waitTime is 0 because eye and joystick are already on central target from prior scene
feedback_eyejoy_holdTime = beforeFeedback + feedbackTime + afterFeedback;         % TOTAL FEEDBACK DURATION: Time required to hold eye and joystick fixation at center while feedback ring appears.

% --- Overwrite default isi and iti times if randomization enabled
if rndTiming
    itiBase = 100;                         % Base time for ITI randomization
    itiTime = itiBase + randi(10)*100;      % ITI: Randomized ITI between 500-1500 ms
else
    itiTime = 500;
end
set_iti(itiTime);                       % Overrides iti value from the main menu

% NOTES ON TIMING:
% In scenes where the monkey makes a joystick reponse, either out and back
% following cue, or out and back following probe, we create two separate
% WaitThenHold adapters one for the eye and one for the joystick, and the
% we run the two adapters at the same time using AllContine.  We set the
% HoldTime for the eye to be larger than the time the animal has to acquire
% and hold the joystick target.  We do this so the scene timing is
% controlled by the joystick behavior.  Namely, the joystick WaitThenHold
% will either terminate successfully (with target acquired) or time out
% before the eye WaitThenHold completes successfully (because the eye
% HoldTime is so long). This is why there are no wait and hold times for
% the eye WaitThenHolds in these periods, they are computed as
% joystick WaitTime + HoldTime + constant.

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
% -------- SELECT CUE AND PROBE BASED ON TRIAL CONDITION NUMBER -----------
% -------------------------------------------------------------------------
% determine the filename of the correct cue image file based on the
% CurrentCondition number. CurrentCondition is the condition number
% drawn at random by MonkeyLogic at trial start corresponding to one of
% the lines in the conditions txt file
switch TrialRecord.CurrentCondition
    case {1}  % A left, B right, C up
        left_pic = Astim;
        leftID = 0;
        leftStr = 'A';
        right_pic = Bstim;
        rightID = 1;
        rightStr = 'B';
        up_pic = Cstim;
        upID = 2;
        upStr = 'C';
        AstimTarg = [-10 0];
        BstimTarg = [10 0];
        CstimTarg = [0 10];
    case {2}  % A left, B up, C right
        left_pic = Astim;
        leftID = 0;
        leftStr = 'A';
        right_pic = Cstim;
        rightID = 2;
        rightStr = 'C';
        up_pic = Bstim;
        upID = 1;
        upStr = 'B';
        AstimTarg = [-10 0];
        BstimTarg = [0 10];
        CstimTarg = [10 0];
    case {3}  % A right, B left, C up
        left_pic = Bstim;
        leftID = 1;
        leftStr = 'B';
        right_pic = Astim;
        rightID = 0;
        rightStr = 'A';
        up_pic = Cstim;
        upID = 2;
        upStr = 'C';
        AstimTarg = [10 0];
        BstimTarg = [-10 0];
        CstimTarg = [0 10];
    case {4}  % A up, B left, C right
        left_pic = Bstim;
        leftID = 1;
        leftStr = 'B';
        right_pic = Cstim;
        rightID = 2;
        rightStr = 'C';
        up_pic = Astim;
        upID = 0;
        upStr = 'A';
        AstimTarg = [0 10];
        BstimTarg = [-10 0];
        CstimTarg = [10 0];
    case {5}  % A right, B up, C left
        left_pic = Cstim;
        leftID = 2;
        leftStr = 'C';
        right_pic = Astim;
        rightID = 0;
        rightStr = 'A';
        up_pic = Bstim;
        upID = 1;
        upStr = 'B';
        AstimTarg = [10 0];
        BstimTarg = [0 10];
        CstimTarg = [-10 0];
    case {6}  % A up, B right, C left
        left_pic = Cstim;
        leftID = 2;
        leftStr = 'C';
        right_pic = Bstim;
        rightID = 1;
        rightStr = 'B';
        up_pic = Astim;
        upID = 0;
        upStr = 'A';
        AstimTarg = [0 10];
        BstimTarg = [10 0];
        CstimTarg = [-10 0];
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
dashboard(2,sprintf('ArewProb: %g, BrewProb: %g, CrewProb: %g', ArewProb, BrewProb, CrewProb));

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
sc1_eyeCenter_oom.OnMarker = gazeFixAcq_eventCode;
sc1_eyeCenter_oom.ChildProperty = 'Success';

% Present fixation target and establish XY position window for joy
sc1_joyCenter = SingleTarget(joy_);
sc1_joyCenter.Target = taskObj_fix;
sc1_joyCenter.Threshold = joy_radius;

% Mark behavioral event: joy fixation
sc1_joyCenter_oom = OnOffMarker(sc1_joyCenter);
sc1_joyCenter_oom.OnMarker = joyFixAcq_eventCode;
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

% Explanation of how this works: the AndAdapter means that we are checking
% for both eye and joy to be in their target locations (not just one or the
% other) and ultimate success is based on both eye and joy being at their
% targets. The SingleTargets and AndAdapter do not have timing properties,
% but we want to both give time for eye and joy to hit their targets and
% also make sure that they are held at their targets (and didn't just enter
% the target fields in passing). To do that, we pass andScene1 to
% WaitThenHold, which will check for eye and joy fixation over both the
% wait time and hold time. This gives several possibilities for a stop or
% success. If the eye, joy, or both do not reach their targets during the
% wait time, wthScene1 will fail and end the scene, passing an error. If
% both eye and joy reach their targets (triggering HoldTime), but one or
% both of them move from their targets before the hold time is up, this
% will also fail wthScene1 and pass an error. Finally, if both eye and joy
% make it to their targets within the wait time and stay in their targets
% throughout the hold time, this is the only success condition, which will
% end the scene but proceed to scene 2 without passing an error. This is
% applied throughout the code, and the important thing to remember is that
% usually the parent adapter is constantly checking for success of the
% child adapter once it is running so long as the parent has timing
% properties (and therefore runs for longer than instantaneously).

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_wtHold,taskObj_fix);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, fixTargOn_eventCode);

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
        dashboard(6, 'sc1_joyCenter: Success');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'preCue';
        idle(0, [], brokeBothFix_eventCode);
    end
end

% bomb trial if error
if abortTrial
     % --- SAVE USER VARS
     bhv_variable(...
         'leftID', leftID, ...
         'rightID', rightID, ...
         'upID', upID, ...
         'leftStr', leftStr, ...
         'rightStr', rightStr, ...
         'upStr', upStr, ...
         'left_pic', left_pic, ...
         'right_pic', right_pic, ...
         'up_pic', up_pic, ...
         'ArewProb', ArewProb, ...
         'BrewProb', BrewProb, ...
         'CrewProb', CrewProb, ...
         'totalTrialSuccess', totalTrialSuccess, ...
         'trialResult', trialResult, ...
         'resultScene', resultScene, ...
         'itiTime', itiTime);
     return;
end

% -------------------------------------------------------------------------
% SCENE 2: STIMULI PRESENTATION & CHOICE
% Present stimuli during central eye fixation for 600 ms. Response allowed.
% Total duration of 1600 ms.

% clear scene output to user screen
dashboard(3,sprintf(''));
dashboard(4,sprintf(''));
dashboard(5,sprintf(''));
dashboard(6,sprintf(''));
dashboard(7,sprintf(''));

dashboard(3, sprintf('Running scene 2: STIMULI & CHOICE'));

% Present fixation target and establish XY position window for eye
sc2_eyeCenter = SingleTarget(eye_);
sc2_eyeCenter.Target = taskObj_fix;
sc2_eyeCenter.Threshold = eye_radius;
% Set up WaitThenHold in relation to eye target
sc2_wtHold_eye = WaitThenHold(sc2_eyeCenter);
sc2_wtHold_eye.WaitTime = 0;  % eye already in window
sc2_wtHold_eye.HoldTime = stim_joy_waitTime + stim_joy_holdTime + 5000;

% MultiTarget()
sc2_mTarg_joy = MultiTarget(joy_);
sc2_mTarg_joy.Target = [AstimTarg; BstimTarg; CstimTarg];
sc2_mTarg_joy.Threshold = joy_radius;
sc2_mTarg_joy.WaitTime = stim_joy_waitTime;
sc2_mTarg_joy.HoldTime = stim_joy_holdTime;

% Mark behavioral event: stimChoice, when MultiTarget choice is acquired
sc2_mTarg_joy_oom = OnOffMarker(sc2_mTarg_joy);
sc2_mTarg_joy_oom.OffMarker = joyOut_eventCode;
% Mark event when waiting goes from true to false, start of joy
% fixation at selected MultiTarget choice
sc2_mTarg_joy_oom.ChildProperty = 'Waiting';

% Combine the eye wtHold and MultiTarget using AllContinue
sc2_resp = AllContinue(sc2_wtHold_eye);
sc2_resp.add(sc2_mTarg_joy);

% use ImageChanger to switch from probe to blank screen after fixed frame
% count
sc2_stimuliImg = ImageChanger(null_);
sc2_stimuliImg.List = { {left_pic, right_pic, up_pic}, ...
    [leftPos; rightPos; upPos], stimDur, [];... % displays stimuli at the same time for the same duration
    [], [], afterStim, stimOff_eventCode; };
sc2_stimuliImg.DurationUnit = 'msec';
% sc2_stimuliImg.Repetition = 0;

sc2_resp_concurrent = Concurrent(sc2_resp);
sc2_resp_concurrent.add(sc2_stimuliImg);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_resp_concurrent, taskObj_fix);
scene2_start = run_scene(scene2, stimOnEventCode);

% --- CHECK BEHAVIORAL OUTCOMES
if sc2_mTarg_joy.Success
    stimRespRT = sc2_mTarg_joy.AcquiredTime;
    if sc2_mTarg_joy.ChosenTarget == 1
        trialResult = 'AstimChosen';
        chosenStimulus = 'Astim';
        resultScene = 'post_stim_resp';
        dashboard(4,sprintf('sc2_mTarg_joy: A stimulus chosen'));
        eventmarker(AstimChosen_eventCode);
    elseif sc2_mTarg_joy.ChosenTarget == 2
        trialResult = 'BstimChosen';
        chosenStimulus = 'Bstim';
        resultScene = 'post_stim_resp';
        dashboard(4,sprintf('sc2_mTarg_joy: B stimulus chosen'));
        eventmarker(BstimChosen_eventCode);
    elseif sc2_mTarg_joy.ChosenTarget == 3
        trialResult = 'CstimChosen';
        chosenStimulus = 'Cstim';
        resultScene = 'post_stim_resp';
        dashboard(4,sprintf('sc2_mTarg_joy: C stimulus chosen'));
        eventmarker(CstimChosen_eventCode);
    end


elseif sc2_mTarg_joy.Waiting
    idle(0, [], noJoy_eventCode);
    trialerror(1);  %'No response'
    abortTrial = true;
    trialResult = 'noResponse';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc2_mTarg_joy: Waiting');
elseif sc2_eyeCenter.Success
    % scene terminated with eye in window. Therefore eye did not cause
    % scene to terminate. The joystick caused the scene to terminate.
    % Joystick not success, not waiting, therefore joystick must have
    % acquired target but not been held for HoldTime
    idle(0, [], brokeJoyFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_joy';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc2_mTarg_joy: Fail');
    dashboard(5, 'sc2_eyeCenter: Success');
elseif ~sc2_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    idle(0, [], brokeGazeFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_eye';
    resultScene = 'post_probe_resp';
    dashboard(4, 'sc2_mTarg_joy: In window, holding');
    dashboard(5, 'sc2_eyeCenter: Fail');
end

% bomb trial if error
if abortTrial
    bhv_variable(...
        'leftID', leftID, ...
        'rightID', rightID, ...
        'upID', upID, ...
        'leftStr', leftStr, ...
        'rightStr', rightStr, ...
        'upStr', upStr, ...
        'left_pic', left_pic, ...
        'right_pic', right_pic, ...
        'up_pic', up_pic, ...
        'ArewProb', ArewProb, ...
        'BrewProb', BrewProb, ...
        'CrewProb', CrewProb, ...
        'totalTrialSuccess', totalTrialSuccess, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'itiTime', itiTime);
    return;
end

% set up reaction time for graph
rt = sc2_mTarg_joy.RT;

% -------------------------------------------------------------------------
% SCENE 3: POST-RESPONSE JOYSTICK RETURN

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(3, sprintf('Running scene 3: POST RESP RETURN'));

% --- CREATE ADAPTOR CHAINS
% Present fixation target and establish XY position window for eye
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = eye_radius;

% Set up WaitThenHold in relation to eye target
sc3_wtHold_eye = WaitThenHold(sc3_eyeCenter);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc3_wtHold_eye.WaitTime = 0; % eye already in-window
sc3_wtHold_eye.HoldTime = postResp_joy_waitTime + postResp_joy_holdTime + 5000;  % big number, joy wtHold will time out first

% Present fixation target and establish XY position window for joy.
sc3_joyCueTarg = SingleTarget(joy_);
sc3_joyCueTarg.Target = [0 0]; % joy back to screen center
sc3_joyCueTarg.Threshold = joy_radius;

% Set up WaitThenHold in relation to joy target
sc3_wtHold_joy = WaitThenHold(sc3_joyCueTarg);  % WaitThenHold will trigger once both the eye and the joystick are in the center and will make sure that they are held there for the duration of this scene
sc3_wtHold_joy.WaitTime = postResp_joy_waitTime;
sc3_wtHold_joy.HoldTime = postResp_joy_holdTime;

% Mark behavioral event: probe return
sc3_wtHold_joy_oom = OnOffMarker(sc3_wtHold_joy);
sc3_wtHold_joy_oom.OffMarker = joyBack_eventCode;
% Mark event when waiting goes from true to false, start of joy
% fixation back at central fixation target after probeReturn
sc3_wtHold_joy_oom.ChildProperty = 'Waiting';

% AllContinue eye wtHold and probeReturn response, with scene timing
% dependent on the joystick response
sc3_postResp = AllContinue(sc3_wtHold_eye);
sc3_postResp.add(sc3_wtHold_joy_oom);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_postResp, taskObj_fix);
scene3_start = run_scene(scene3, retStart_eventCode);

% --- CHECK BEHAVIORAL OUTCOMES
% this scene runs separate eye and joystick WaitThenHolds and runs them
% in parallel using AllContinue, with timing such that joystick wtHold
% controls task timing and scene termination, and eye wtHold will never
% terminate
if sc3_wtHold_joy.Success
    joyReturnRT = sc3_wtHold_joy.AcquiredTime;
    dashboard(4, 'sc3_wtHold_joy: Success');
    trialResult = 'joyReturnSuccess';
    stimRespCompleted = true;

elseif sc3_wtHold_joy.Waiting
    idle(0, [], noJoy_eventCode);
    trialerror(1);  %'No response'
    abortTrial = true;
    trialResult = 'noResponse';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc3_wtHold_joy: Waiting');
elseif sc3_eyeCenter.Success
    % scene terminated with eye in window. Therefore eye did not cause
    % scene to terminate. The joystick caused the scene to terminate.
    % Joystick not success, not waiting, therefore joystick must have
    % acquired target but not been held for HoldTime
    idle(0, [], brokeJoyFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_joy';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc3_wtHold_joy: Fail');
    dashboard(5, 'sc3_eyeCenter: Success');
elseif ~sc3_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    idle(0, [], brokeGazeFix_eventCode);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
    trialResult = 'breakFix_eye';
    resultScene = 'post_probe_return';
    dashboard(4, 'sc3_wtHold_joy: Holding');
    dashboard(5, 'sc3_eyeCenter: Fail');
end

% bomb trial if error
if abortTrial
    bhv_variable(...
        'leftID', leftID, ...
        'rightID', rightID, ...
        'upID', upID, ...
        'leftStr', leftStr, ...
        'rightStr', rightStr, ...
        'upStr', upStr, ...
        'left_pic', left_pic, ...
        'right_pic', right_pic, ...
        'up_pic', up_pic, ...
        'ArewProb', ArewProb, ...
        'BrewProb', BrewProb, ...
        'CrewProb', CrewProb, ...
        'totalTrialSuccess', totalTrialSuccess, ...
        'chosenTarget', sc2_mTarg_joy.ChosenTarget, ...
        'chosenStimulus', chosenStimulus, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'itiTime', itiTime, ...
        'stimRespRT', stimRespRT);
    return;
end

% -------------------------------------------------------------------------
% SCENE 4: FEEDBACK
% Shows all stimuli with a box around the selected stimulus
% Note: skipping response period only scene (scene 2 can just do everything on its own)
% May need rand. 400-800 ms timing?

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(4,sprintf('')); % Scene behavioral outcome
dashboard(5,sprintf('')); % Misc information
dashboard(6,sprintf('')); % Misc information

dashboard(3, sprintf('Running scene 4: FEEDBACK'));

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
sc4_wtHold.WaitTime = feedback_eyejoy_waitTime;
sc4_wtHold.HoldTime = feedback_eyejoy_holdTime;

% Present the feedback stimulus
sc4_feedbackImg = ImageChanger(null_);

if sc2_mTarg_joy.ChosenTarget == 1 && strcmp(left_pic, Astim)
    % A was chosen and presented left
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [leftPos; leftPos; rightPos; upPos], ...
        feedbackTime, AstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 1 && strcmp(right_pic, Astim)
    % A was chosen and presented right
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [rightPos; leftPos; rightPos; upPos], ...
        feedbackTime, AstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 1 && strcmp(up_pic, Astim)
    % A was chosen and presented up
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [upPos; leftPos; rightPos; upPos], ...
        feedbackTime, AstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 2 && strcmp(left_pic, Bstim)
    % B was chosen and presented left
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [leftPos; leftPos; rightPos; upPos], ...
        feedbackTime, BstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 2 && strcmp(right_pic, Bstim)
    % B was chosen and presented right
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [rightPos; leftPos; rightPos; upPos], ...
        feedbackTime, BstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 2 && strcmp(up_pic, Bstim)
    % B was chosen and presented up
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [upPos; leftPos; rightPos; upPos], ...
        feedbackTime, BstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 3 && strcmp(left_pic, Cstim)
    % C was chosen and presented left
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [leftPos; leftPos; rightPos; upPos], ...
        feedbackTime, CstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 3 && strcmp(right_pic, Cstim)
    % C was chosen and presented right
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [rightPos; leftPos; rightPos; upPos], ...
        feedbackTime, CstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
elseif sc2_mTarg_joy.ChosenTarget == 3 && strcmp(up_pic, Cstim)
    % C was chosen and presented up
    sc4_feedbackImg.List = { [], [], beforeFeedback, [];...
        {feedbackBox, left_pic, right_pic, up_pic}, ...
        [upPos; leftPos; rightPos; upPos], ...
        feedbackTime, CstimFeedback_eventCode; ...
        [], [], afterFeedback, feedbackOff_eventCode;};
    sc4_feedbackImg.DurationUnit = 'msec';
end

% Concurrent()
% Success: true when first chain succeeds
% Stop: when the first chain stops
% INTENDED BEHAVIOR: Concurrent() will run wtHold and image at the same
% time but scene timing will depend on wtHold only, if this is the first
% adaptor added.
sc4_concurrent = Concurrent(sc4_wtHold);
sc4_concurrent.add(sc4_feedbackImg);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene4 = create_scene(sc4_concurrent, taskObj_fix);
scene4_start = run_scene(scene4, feedbackStart_eventCode);

% --- CHECK BEHAVIORAL OUTCOMES
if sc4_wtHold.Success
    idle(0);
    dashboard(4, 'sc4_feedback: Success');
    totalTrialSuccess = 1;
elseif sc4_wtHold.Waiting
    idle(0, [], noJoy_eventCode); % turns FIX OFF
    trialerror(4);  %'No fixation'
    abortTrial = true;
    trialResult = 'noEyeJoyFix';
    resultScene = 'feedback';
    dashboard(4, 'sc4_wtHold: Waiting');
else  % fixation acquired but broken
    trialerror(3);  %'Break fixation'
    idle(0);
    abortTrial = true;
    dashboard(4, 'sc4_wtHold: Broken fixation');
    % figure out which fixation was broken, eye or joy
    if sc4_eyeCenter.Success && ~sc4_joyCenter.Success
        idle(0, [], brokeJoyFix_eventCode);
        dashboard(5, 'sc4_eyeCenter: Success');
        dashboard(6, 'sc4_joyCenter: Fail');
        trialResult = 'breakFix_joy';
        resultScene = 'feedback';
    elseif ~sc4_eyeCenter.Success && sc4_joyCenter.Success
        idle(0, [], brokeGazeFix_eventCode);
        dashboard(5, 'sc4_eyeCenter: Fail');
        dashboard(6, 'sc4_joyCenter: Success');
        trialResult = 'breakFix_eye';
        resultScene = 'feedback';
    elseif ~sc4_eyeCenter.Success && ~sc4_joyCenter.Success % not likely, but possible
        idle(0, [], brokeBothFix_eventCode);
        dashboard(5, 'sc4_eyeCenter: Fail');
        dashboard(6, 'sc4_joyCenter: Success');
        trialResult = 'breakFix_eye_joy';
        resultScene = 'feedback';
    end
end

% bomb trial if error
if abortTrial
    bhv_variable(...
        'leftID', leftID, ...
        'rightID', rightID, ...
        'upID', upID, ...
        'leftStr', leftStr, ...
        'rightStr', rightStr, ...
        'upStr', upStr, ...
        'left_pic', left_pic, ...
        'right_pic', right_pic, ...
        'up_pic', up_pic, ...
        'ArewProb', ArewProb, ...
        'BrewProb', BrewProb, ...
        'CrewProb', CrewProb, ...
        'totalTrialSuccess', totalTrialSuccess, ...
        'chosenTarget', sc2_mTarg_joy.ChosenTarget, ...
        'chosenStimulus', chosenStimulus, ...
        'trialResult', trialResult, ...
        'resultScene', resultScene, ...
        'itiTime', itiTime, ...
        'stimRespRT', stimRespRT, ...
        'probeReturnRT', joyReturnRT);
    return;
end

% clear scene output to user screen
dashboard(3,sprintf('')); % clear first
dashboard(4,sprintf('')); % Scene behavioral outcome
dashboard(5,sprintf('')); % Misc information
dashboard(6,sprintf('')); % Misc information
dashboard(7,sprintf('')); % Misc information

% Add in reward
% --- REWARD
if sc2_mTarg_joy.ChosenTarget == 1 && ArewProb >= rand
    goodmonkey(rewDur1, 'juiceline',1, 'numreward', numDrops1, 'pausetime',...
        500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
    dashboard(3,sprintf('sc2_wtHold: Chosen position (x,y) = %d %d', sc2_mTarg_joy.Target(1), sc2_mTarg_joy.Target(2)));
    dashboard(4,sprintf('sc2_wtHold: Chosen target = %d', sc2_mTarg_joy.ChosenTarget));
    dashboard(5,sprintf('sc2_wtHold: A stimulus chosen'));
    trialerror(0);
    %trialerror(7); % 7 marks A stimulus chosen
elseif sc2_mTarg_joy.ChosenTarget == 2 && BrewProb >= rand
    goodmonkey(rewDur1, 'juiceline',1, 'numreward', numDrops1, 'pausetime',...
        500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
    dashboard(3,sprintf('sc2_wtHold: Chosen position (x,y) = %d %d', sc2_mTarg_joy.Target(1), sc2_mTarg_joy.Target(2)));
    dashboard(4,sprintf('sc2_wtHold: Chosen target = %d', sc2_mTarg_joy.ChosenTarget));
    dashboard(5,sprintf('sc2_wtHold: B stimulus chosen'));
    trialerror(0);
    %trialerror(8); % 8 marks B stimulus chosen
elseif sc2_mTarg_joy.ChosenTarget == 3 && CrewProb >= rand
    goodmonkey(rewDur1, 'juiceline',1, 'numreward', numDrops1, 'pausetime',...
        500, 'eventmarker', [rewDrop1_eventCode rewDrop2_eventCode]);
    dashboard(3,sprintf('sc2_wtHold: Chosen position (x,y) = %d %d', sc2_mTarg_joy.Target(1), sc2_mTarg_joy.Target(2)));
    dashboard(4,sprintf('sc2_wtHold: Chosen target = %d', sc2_mTarg_joy.ChosenTarget));
    dashboard(5,sprintf('sc2_wtHold: C stimulus chosen'));
    trialerror(0);
    %trialerror(9); % 9 marks C stimulus chosen
else
    trialerror(5);
    eventmarker(noRewGiven_eventCode);
end

% -------------------------------------------------------------------------
% --- SAVE BEHAVIORAL VARIABLES TO OUTFILE
% This is where we can save variables in the behavioral outfile for later
% reference. Mainly timing variables, including the randomized delay
% times and when the joystick hit certain targets

bhv_variable(...
    'leftID', leftID, ...
    'rightID', rightID, ...
    'upID', upID, ...
    'leftStr', leftStr, ...
    'rightStr', rightStr, ...
    'upStr', upStr, ...
    'left_pic', left_pic, ...
    'right_pic', right_pic, ...
    'up_pic', up_pic, ...
    'ArewProb', ArewProb, ...
    'BrewProb', BrewProb, ...
    'CrewProb', CrewProb, ...
    'totalTrialSuccess', totalTrialSuccess, ...
    'chosenTarget', sc2_mTarg_joy.ChosenTarget, ...
    'chosenStimulus', chosenStimulus, ...
    'trialResult', trialResult, ...
    'resultScene', resultScene, ...
    'itiTime', itiTime, ...
    'stimRespRT', stimRespRT, ...
    'probeReturnRT', joyReturnRT);

% Add in reward walk
if randRewWalk
    % generate random plus or minus for each
    Aplusminus = 2*(randi([0,1]))-1; % say thank you to the matlab help forums
    Bplusminus = 2*(randi([0,1]))-1;
    Cplusminus = 2*(randi([0,1]))-1;

    % new value = original value +/- (uniform random number<hazard)*step size
    ArewProb = ArewProb + Aplusminus*(rand()<0.2)*0.2;
    BrewProb = BrewProb + Bplusminus*(rand()<0.2)*0.2;
    CrewProb = CrewProb + Cplusminus*(rand()<0.2)*0.2;

    % implement min and max to keep probs between 0 and 1
    % new value = max(new value, 0)
    % new value = min(new value, 1)
    ArewProb = max(ArewProb, 0);
    ArewProb = min(ArewProb, 1);
    BrewProb = max(BrewProb, 0);
    BrewProb = min(BrewProb, 1);
    CrewProb = max(CrewProb, 0);
    CrewProb = min(CrewProb, 1);
end


