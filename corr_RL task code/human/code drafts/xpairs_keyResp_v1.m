% -----------------------------------------------------------------------
% -------------------------  XPAIRS TASK CODE ----------------------------
% -----------------------------------------------------------------------

% Next iteration of task designed to engage both hebbian and reinforcement
% learning

% Subjects learn association between pairs of stimuli and
% reward probabilities.  This embeds hebbian learning inside a bandit-style
% RL task.  Goal is to isolate neural synchrony and RPE components of
% synaptic plasticity, fit hybrid RL models to behavior, quantify
% interaction between these two forms of synaptic learning, while subjects
% learn.

% Task design features:

% 1. CROSS-PAIR DESIGN.  Four stimuli (peripheral dots or gabors) are
% variously combined to indicate whether red or green choice target is
% associated with high (80%) or low (20%) reward probability at the end of
% the trial. Crossing is done such that each stimulus location is
% associated with R and G choices with each probability.  This ensures that
% the decision cannot be based on any individual stimulus at outset.
% Association between two stimuli must be learned to consistently select
% high value target. Given 4 stimuli, the crossing would be as follows:

% 1-2 : Green (80%)
% 3-4 : Green (80%)
% 1-3 : Red (80%)
% 2-4 : Red (80%)

% Notice each single stimulus is associated with Red and Green with equal
% probability.  Information about whether Red or Green choice stimulus is
% high reward probability is conveyed by pair (learned association) only

% 2. DIRECTIONAL ASSOCIATIONS. Pairs are presented in fixed order with STDP
% interstimulus intervals. Stimulus 1 consistently just before stimulus 2
% strengthens 1 to 2 synapses.  Stimulus 1 implies stimulus 2, but not the
% converse.

% Extanding the cross-pair design with ordinal information produces

% 1 -> 2 : Green
% 3 -> 4 : Green
% 3 -> 1 : Red
% 2 -> 4 : Red

% with the arrow indicating the order of presentation and the direction of
% the learned association.  Note further that orders are arranged such that
% any single stimulus implies only 1 other stimulus as its partner.  This
% could be manipulated in some conditions where stimulus 1 implies both 2
% and 3, to contrast neural coding and behavioral read-outs between
% unambiguous and ambiguous pairings.

% 3. SINGLETON PROBES.  If the directional association manipulation works,
% choices in response to a singleton stimulu would provide a behavioral 
% read-out of learning. For example, after learning that:
% Stimulus 1 -> 2 : Green
% presentation of stimulus 1 alone should be associated with a Green 
% choice, whereas presentation of stimulus 2 alone would be associated 
% with Red and Green choices with equal probability.

% 4. VARIABLE ASSOCIATIVE STRENGTH.  Introduce variable numbers of noise
% pairs that modulate the correlation strength between each stimulus in 
% informative pairs with its partner.  So if subjects learn that:
% Stimulus 1 -> 2 : Green
% have stimulus 1 appear with stimulus 2 on 50% of trials, and stimulus 1
% appear with stimulus 5 on 50% of trials.  Have 1->5 indicate Green and 
% Red with equal probability

% 5. REPETITIVE STIMULI.  To amplify visually driven synchrony, and
% incorporate varying amounts of noise into single trials, present a movie
% in which successive frames show pair - blank - pair - blank ... Moduluate
% the proporation of informative and noise pairs shown.

% 6. ATTENTION. Attention is associated with neural synchrony (by some
% accounts). Adding orienting probes before pair presentation might amplify
% neural synchrony, modulate learning.

% 7. SEQUENCE LEARNING.  Expansion of ISI beyond time constant of synaptic
% eligibility trace will recruit working memory to bridge the gap between
% the two stimuli.  Thus xPairs morphs seamlessly into a sequence learning
% task.

% NOTES ON STIMULUS TIMING FOR LEARNING EFFECTS 
% McMahon and Leopold (2010) tested effect of stimulus timing and order on
% plasticity of face perception. Two faces, variable morph levels between
% them, task to identify morphs as face A or B. Obtain psychophysical
% thresolds before and after image pairing.  Image pairing paradigm:
% - each trial, an image pair was presented (face or nonface) at fovea
% - 120 trials, 100 face pairs, 20 nonface pairs
% - each image in pair visible for 1 screen refresh (10 ms at 100 Hz)
% - SOA 10-100 ms
% - After 1 pair, press button if face, withhold if nonface (attention)
% - Interpair interval 800-1200 ms (ITI)
% - Trial length, fix (500 ms), pair (max 120 ms), 1200 ms ITI = ~ 2 s
% - Plasticity effect peaked at SOA = 20 ms, 100 pairs sufficient

% TRIAL STRUCTURE for xPAIRS PROTOTYPE
% - fixation
% - Single target pair flashed
% - Red and Green choice targets appear at left/right (randomized)
% - Press left/right response key
% - Probabilitic reward based on image pair shown
% - To vary associative strength, hold SOA and image order constant within
%   block, vary SOA and image order BETWEEN BLOCKS, compare neurons and 
%   behavior between blocks

% Algorithmic steps to build trial stack:

% 1. Establish STIMULUS ARRAY.  Allow for greater than 4 stimulus locations
% to enable introduction of noise pairs

% 2. Build TRIAL STACK for blocks of trials.  Within each block:
% a. Select 4 stimulus locations at random from array
% b. Establish 4 cross-pairs (see above) among 4 selected stimuli
% c. Assign 2 pairs each to Green (80% rew prob)and Red (80% rew prob)
% c. Set stimulus order for each pair (1->2 or 2->1 etc).
% d. Set interstimulus interval
% e. Define noise pairs, if enabled.
% f. Insert noise pairs at variable proportion, if enabled.

% 3. Present CHOICE ARRAY, Red(Left) green(right), or reverse at random.
% Can add second choice pair color to dissociate neural representation of
% state from predictions of choice color. So choice array might be
% Red-Green on some trials, and Yellow-Purple on others.  Find neurons that
% generalize over xPairs coding same state and generalize over choice
% colors.  These are abstract category neurons (as a bonus).

% 4. Monitor BUTTON PRESS (left, right)

% 5. Deliver PROBABILISITC REWARD (Bandit-style)

% VERSION HISTORY
% --- v1:
% - Start with 1 pair shown per trial using design above.
% - Incorporate singleton probes.
% - Incorporate noise pairs, still only 1 pair per trial.
% - Have people run this.  Compare performance +/- noise. Fit RL models.


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
times.pretrial = 300;
% scene 1 is eye fixation
times.sc1_wait = 1000;
times.sc1_hold = 500;
% scene 2 presents choice array
times.sc2_wait = 0;
times.sc2_hold = 500; % entire duration of scene
% scene 3 runs stimulus movie (pairs) with choice array visible
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
codes.choices_on = 20;
% stim codes, refer to the stimulus number within the randomly chosen pair
codes.stim1_on = 30;
codes.stim1_off = 31;
codes.stim2_on = 32;
codes.stim2_off = 33;
codes.stim3_on = 34;
codes.stim3_off = 35;
codes.stim4_on = 36;
codes.stim4_off = 37;
% stim pair codes
codes.stimPair_on = 38;
codes.stimPair_off = 39;
% noise codes, refer to the noise number within the randomly chosen pair
codes.noise1_on = 40;
codes.noise1_off = 41;
codes.noise2_on = 42;
codes.noise2_off = 43;
codes.noise3_on = 44;
codes.noise3_off = 45;
codes.noise4_on = 46;
codes.noise4_off = 47;
% noise pair codes
codes.noisePair_on = 48;
codes.noisePair_off = 49;

% choice codes
chodes.choicesOff = 50;
codes.choiceMade = 51;
codes.choseKey1 = 52;
codes.choseKey2 = 53;
codes.choseBothKeys = 54;
codes.choiceRing_on = 55;
codes.choiceRing_off = 56;
codes.rewRing_on = 57;
codes.rewRing_off = 58;
codes.brokeEye = 60;
codes.noEye = 61;

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
% each trial
if TrialRecord.CurrentTrialNumber == 1
    [condArray, condReps, stimArray, params] = xPairs_buildTrials_v2(); 
    % store output in TrialRecord so variables live (have scope) beyond
    % this trial.  Other variables in script are only defined during the
    % trial.
    TrialRecord.User.condArray = condArray;
    TrialRecord.User.condReps = condReps;
    TrialRecord.User.params = params;
    TrialRecord.User.stimArray = stimArray;
    % init condition reps remaining counter (condRepRem) to initial
    % condition rep array
    TrialRecord.User.condRepsRem = condReps;
    TrialRecord.User.times = times;
    TrialRecord.User.eventCodes = codes;
end

% -------------------------------------------------------------------------
% --------------------- GENERATE STIMULUS MOVIE ---------------------------
% -------------------------------------------------------------------------
% Condition array specifies xPair stimulus locations for reward state
% informative stimuli.  Stimulus presentation is controlled by
% xPairs_generateStimMovie, which can present stimuli in several modes:

% 1. simultaneous: present the two stimuli in each pair in a single frame.
% This may be useful for training, possibly recording

% 2. stdp: present the two stimuli in each pair sequentially, in STDP
% window

% 3. repeat: present two stimuli in each pair in several rapid frames
% interspersed with blank screens

% 4. repeatNoise: same as 3 above except introducing variable proportion
% of noise pairs to reduce correlation between stimuli in each pair.  No
% need to specify noise stimuli at the level of the conditions files, can
% randomly generate noise stimuli on each trial and record locations to
% outfiles

% 5. sequential: stimuli presented at longer SOAs to engage sequence
% prediction error learning mechanisms

[movieFrames] = xPairs_generateStimMovie_v1(TrialRecord);

% Save movie to TrialRecord
TrialRecord.User.movieFrames = movieFrames;

% -------------------------------------------------------------------------
% ---------------------- SET CHOICE REWARD PROB ---------------------------
% -------------------------------------------------------------------------

% set the choice feebback images
choices.rewImg = 'rewRing.png';
choices.choiceImg = 'choiceRing.png';

% init choseKey to null to prevent crash when not defined after manually
% quitting program
choices.choseKey = [];

% -------------------------------------------------------------------------
% ----------------- PRINT TRIAL INFO TO USER SCREEN -----------------------
% -------------------------------------------------------------------------
% Output trial info:

t = TrialRecord.CurrentTrialNumber;
c = TrialRecord.CurrentCondition;

condRepsRem = TrialRecord.User.condRepsRem(c);

outstr1 = strcat('Trial:', ' ', num2str(t), ' Cond:', ' ', num2str(c), ' trls remaining cond:', ' ', num2str(condRepsRem));
dashboard(1, outstr1);

% Output block control info
b = TrialRecord.CurrentBlock;
trl_b = TrialRecord.CurrentTrialWithinBlock;
conds_b = TrialRecord.ConditionsThisBlock;

outstr2 = strcat('Block:', ' ', num2str(b), ' Trial in block:', ' ', num2str(trl_b), ' Conds in block:', ' ', num2str(conds_b));
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

% --- ML notes
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

% --- MAKE ADAPTORS
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
% SCENE 2: PRESESNT CHOICE ARRAY, BEFORE STIM MOVIE
% Present gaze fixation target, require fixation, and present choice
% targets using ImageGraphic. Instantiate KeyChecker to detect premature
% keypress

% --- MAKE ADAPTORS
% --- Present gaze fixation target and require fixation for duration of this scene
sc2_eyeCenter = SingleTarget(eye_); % instantiate object
sc2_eyeCenter.Target = taskObj_fix; % set stimulus for fixation target
sc2_eyeCenter.Threshold = eye_radius; % set tolerance for eye position
sc2_wtHold = WaitThenHold(sc2_eyeCenter);  
sc2_wtHold.WaitTime = times.sc2_wait;
sc2_wtHold.HoldTime = times.sc2_hold;

%  --- Instantiate key checkers
% KeyChecker stops when a keypress is detected (success)
sc2_key1 = KeyChecker(mouse_);
sc2_key1.KeyNum = 1;  % 1st keycode in GUI
sc2_key2 = KeyChecker(mouse_);
sc2_key2.KeyNum = 2;  % 2nd keycode in GUI
% OrAdaptor stops if any included adaptor's state becomes success, so 
% s2_watchKeys will stop if either key 1 or 2 is pressed 
sc2_watchKeys = OrAdapter(sc2_key1);
sc2_watchKeys.add(sc2_key2);

% --- Instantiate choice array
% ImageGraphic Input properties (from ML documentation)
% List: An n-by-2, n-by-3 or n-by-4 cell matrix. Use this property to create multiple image objects. Their Position, Scale and Angle properties can be changed afterward.
% 1st column: Image filename, function string (see Remarks) or image matrix (Y-by-X-by-3 or Y-by-X-by-4)
% 2nd column: Image XY position in visual angles, an n-by-2 matrix ([x1 y1; x2 y2; ...])
% 3rd column (optional): Colorkey, [R G B] that should look transparent
% 4th column (optional): Resize parameter. [Xsize Ysize] in pixels or a scalar (scale).
% 5th column (optional): Angle. In degrees.

% choice stimulus information in condArray to use:
% condArrayTemp(b, c, p).choice1.x = choicePos(choices(1).posIndx).x;
% condArrayTemp(b, c, p).choice1.y = choicePos(choices(1).posIndx).y;
% condArrayTemp(b, c, p).choice1.fileName = choices(1).fileName;
% condArrayTemp(b, c, p).choice1.rewProb = choices(1).rewProb;

s2_choiceImg = ImageGraphic(null_);
ch1_x = TrialRecord.User.condArray(c).choices(1).x;
ch1_y = TrialRecord.User.condArray(c).choices(1).y;
ch1_fn = TrialRecord.User.condArray(c).choices(1).fileName;
ch2_x = TrialRecord.User.condArray(c).choices(2).x;
ch2_y = TrialRecord.User.condArray(c).choices(2).y;
ch2_fn = TrialRecord.User.condArray(c).choices(2).fileName;
% image list template from ML documentation, filename, followed by x and y
% for each stimulus displayed
% img.List = { 'A.bmp', [-3 0]; 'B.bmp', [3 0] };  % put only one image in each row
s2_choiceImg.List = {ch1_fn, [ch1_x ch1_y]; ch2_fn, [ch2_x ch2_y]};

% --- COMBINE ADAPTORS
% use AllContinue to combine WaitThenHold and KeyChecker, so adaptor
% terminates if either fixation is broken or key is pressed
sc2_eye_key = AllContinue(sc2_wtHold);
sc2_eye_key.add(sc2_watchKeys);
% add choice image using Concurrent, but add sc2_eye_key first it controls 
% scene timing.  Scene will run until a key is hit (error) or WaitThenHold 
sc2_eye_key_choices = Concurrent(sc2_eye_key);
sc2_eye_key_choices.add(s2_choiceImg);

% --- create and run scene
scene2 = create_scene(sc2_eye_key_choices);
scene2_start = run_scene(scene2);

% --- check outcomes (error states).  If none, just advance to next state
% (don't do anything)
if sc2_key1.Success && ~sc2_key2.Success
    choices.choseKey = 1;
    eventmarker(codes.choseKey1);
    dashboard(4, sprintf('Early Key 1 press time: %d ms', sc2_key1.Time(1)));
    trialerror(5);  %'Early response'
    abortTrial = true;

elseif sc2_key2.Success && ~sc2_key1.Success
    choices.choseKey = 2;
    eventmarker(codes.choseKey2);
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    dashboard(4, sprintf('Early Key 2 press time: %d ms', sc2_key2.Time(1)));
    trialerror(5);  %'Early response'
    abortTrial = true;

elseif sc2_key1.Success && sc2_key2.Success
    choices.choseKey = 0;
    eventmarker(codes.choseBothKeys);
    dashboard(4, sprintf('Early response, both keys'));
    trialerror(5);  %'Early response'
    abortTrial = true;

elseif ~sc2_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.choseKey = 0;
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
end

% -------------------------------------------------------------------------
% SCENE 3: PRESENT STIM MOVIE, WATCH FOR KEY RESPONSE
% Initiate stimulus movie to instruct reward state
% Scene timing will be terminated by either by keypress or breaking fixation.  
% Keypress can occur either during or after movie.  
% Movie can contain 1 stimulus pair, or several, depending on movieMode and 
% as specified by generateStimMovie.  First 

% --- MAKE ADAPTORS
% --- 1. eye fix adaptor
sc3_eyeCenter = SingleTarget(eye_);
sc3_eyeCenter.Target = taskObj_fix;
sc3_eyeCenter.Threshold = eye_radius;
sc3_wtHold = WaitThenHold(sc2_eyeCenter);
sc3_wtHold.WaitTime = times.sc2_wait;
sc3_wtHold.HoldTime = times.sc2_hold; % entire duration of scene

% --- 2. key checking adaptor
sc3_key1 = KeyChecker(mouse_);
sc3_key1.KeyNum = 1;  % 1st keycode in GUI
sc3_key2 = KeyChecker(mouse_);
sc3_key2.KeyNum = 2;  % 2nd keycode in GUI
sc3_watchKeys = OrAdapter(sc3_key1);
sc3_watchKeys.add(sc3_key2);

% --- 3. show movie adaptor
sc3_movie = ImageChanger(null_);
sc3_movie.List = movieFrames;

% --- COMBINE ADAPTORS
% scene will be terminated either by key press or broken gaze fixation
% use AllContinue to combine WaitThenHold and KeyChecker, so adaptor
% terminates if either fixation is broken or key is pressed
sc3_eye_key = AllContinue(sc3_wtHold);
sc3_eye_key.add(sc3_watchKeys);
% add choice image using Concurrent, but add sc2_eye_key first so eye fixation /
% key press controls scene timing
sc3_eye_key_movie = Concurrent(sc3_eye_key);
sc3_eye_key_movie.add(sc3_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_eye_key_movie);
scene3_start = run_scene(scene3);

% --- ANALYZE SCENE OUTCOME
if sc3_key1.Success && ~sc3_key2.Success
    choices.choseKey = 1;
    eventmarker(codes.choseKey1);
    % pressed the left key, determine which choice was presented at 
    % left position in display (red or green)
    if TrialRecord.User.Condition(c).choice1.x < 0 % choice1, green, was left
        choices.choiceSelected = 1; % green
    elseif TrialRecord.User.Condition(c).choice2.x < 0 % choice2, red, was left
        choices.selectedChoice = 2; % red
    else
        error('error in scene 4 determining selectedChoice');
    end
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    dashboard(4, sprintf('Key 1 press time: %d ms', sc3_key1.Time(1)));
elseif sc3_key2.Success && ~sc3_key1.Success
    choices.choseKey = 2;
    eventmarker(codes.choseKey2);
    % pressed the right key, determine which choice was presented at 
    % right position in display (red or green)
    if TrialRecord.User.Condition(c).choice1.x > 0 % choice1, green, was left
        choices.choiceSelected = 1; %green
    elseif TrialRecord.User.Condition(c).choice2.x > 0 % choice2, red, was left
        choices.selectedChoice = 2; %red
    else
        error('error in scene 4 determining selectedChoice');
    end
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    dashboard(4, sprintf('Key 2 press time: %d ms', sc3_key2.Time(1)));
elseif sc3_key1.Success && sc3_key2.Success
    error('Both keys hit');
    choices.choseKey = 0;
    eventmarker(codes.choseBothKeys);
    abortTrial = true;
elseif ~sc3_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.choseKey = 0;
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;

end

% -------------------------------------------------------------------------
% SCENE 4: PRESESNT CHOICE ARRAY AFTER STIM MOVIE, SHOW FEEDBACK
% (reward/no reward)
% Choice array stays on after keypress. Black ring appears around selected 
% choice.  Turns to blue ring if rewarded. 

% --- MAKE ADAPTORS
% --- Present gaze fixation target and require fixation for duration of this scene
sc4_eyeCenter = SingleTarget(eye_); % instantiate object
sc4_eyeCenter.Target = taskObj_fix; % set stimulus for fixation target
sc4_eyeCenter.Threshold = eye_radius; % set tolerance for eye position
sc4_wtHold = WaitThenHold(sc4_eyeCenter);  
sc4_wtHold.WaitTime = times.sc4_wait;
sc4_wtHold.HoldTime = times.sc4_hold;

% --- Instantiate choice array
s4_choiceImg = ImageGraphic(null_);
ch1_x = TrialRecord.User.condArray(c).choices(1).x;
ch1_y = TrialRecord.User.condArray(c).choices(1).y;
ch1_fn = TrialRecord.User.condArray(c).choices(1).fileName;
ch2_x = TrialRecord.User.condArray(c).choices(2).x;
ch2_y = TrialRecord.User.condArray(c).choices(2).y;
ch2_fn = TrialRecord.User.condArray(c).choices(2).fileName;
% image list template from ML documentation, filename, followed by x and y
% for each stimulus displayed
% img.List = { 'A.bmp', [-3 0]; 'B.bmp', [3 0] };  % put only one image in each row
s4_choiceImg.List = {ch1_fn, [ch1_x ch1_y]; ch2_fn, [ch2_x ch2_y]};

% --- COMBINE ADAPTORS
% Run sc4_wtHold and choice image using Concurrent, but add sc4_wtHold first so eye fixation
% controls scene timing.  No other constraint, just displaying feedback to
% participant
sc4_eye_choices = Concurrent(sc4_wtHold);
sc4_eye_choices.add(s2_choiceImg);

% --- create and run scene
scene4 = create_scene(sc4_eye_choices);
scene4_start = run_scene(scene4);

% --- ANALYZE SCENE OUTCOME

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




