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

% VERSION HISTORY
% v1 : initial effort, adapted from frames_task prototype, refining xPairs
% design
% v2 : refined state sequence, compiles, runs.  movieModes implemented:
% simultaneous, STDP, repeat, noise
% v3: 

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

% ALTERNATIVE DESIGN: on some trials, only a single stimulus is shown, on
% others pairs of stimuli are shown. The implication about reward state of
% the pair can be determined by comparison of choices to the pair and
% choices to the individual stimuli. In some pairs, inclusion of only 1
% stimulus informs reward state.  In other pairs, it is the combination.
% Optionally, and single stimulus instructs 50/50 reward state (choices
% should be random).  This might be simpler design 1 pair - 1 reward state
% mapping, rather than 2 pairs -> 1 reward state mapping

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
% scene 2 presents choice array and stimulus pairs (movie)
times.sc2_wait = 0;
times.sc2_hold = 10000; % make sure long enough for movie to complete
times.sc2_prePairs = 500;
times.sc2_postPairs = 15000;
% scene 3 provides feedback on choice
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
codes.choices_off = 50;
codes.choiceMade = 51;
codes.chosenKey1 = 52;
codes.chosenKey2 = 53;
codes.choseBothKeys = 54;
codes.choiceRing_on = 55;
codes.choiceRing_off = 56;
codes.rewRing_on = 57;
codes.rewRing_off = 58;
codes.brokeEye = 60;
codes.noEye = 61;

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
    [condArray, condReps, params] = xPairs_buildTrials_v2();
    % store output in TrialRecord so variables live (have scope) beyond
    % this trial.  Other variables in script are only defined during the
    % trial.
    TrialRecord.User.condArray = condArray;
    TrialRecord.User.condReps = condReps;
    TrialRecord.User.params = params;
    % init condition reps remaining counter (condRepRem) to initial
    % condition rep array
    TrialRecord.User.condRepsRem = condReps;
    TrialRecord.User.times = times;
    TrialRecord.User.codes = codes;
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
% ---------------- EXTRACT TRIAL INFO FROM TrialRecord --------------------
% -------------------------------------------------------------------------
t = TrialRecord.CurrentTrialNumber;
c = TrialRecord.CurrentCondition;

% -------------------------------------------------------------------------
% ---------------- SET CHOICE AND REWARD PARAMETERS -----------------------
% -------------------------------------------------------------------------

% set the choice feebback images
choices.rewImg = 'rewRing.png';
choices.choiceImg = 'choiceRing.png';
% extract reward state
choices.rewState = TrialRecord.User.condArray(c).rewState;
% extract choice 1 (green) parameters
choices.ch1_side = TrialRecord.User.condArray(c).choice1.side;
choices.ch1_fn = TrialRecord.User.condArray(c).choice1.fileName;
choices.ch1_x = TrialRecord.User.condArray(c).choice1.x;
choices.ch1_y = TrialRecord.User.condArray(c).choice1.y;
choices.ch1_rewProb = TrialRecord.User.condArray(c).choice1.rewProb;
% extract choice 2 (red) parameters
choices.ch2_side = TrialRecord.User.condArray(c).choice2.side;
choices.ch2_fn = TrialRecord.User.condArray(c).choice2.fileName;
choices.ch2_x = TrialRecord.User.condArray(c).choice2.x;
choices.ch2_y = TrialRecord.User.condArray(c).choice2.y;
choices.ch2_rewProb = TrialRecord.User.condArray(c).choice2.rewProb;
% init choices (outcome) variables reflecting subject response
choices.chosenSide = [];
choices.chosenKey = [];
choices.choiceSelected = [];  % ch1 or ch2, green or red respectively
choices.chosenColor = [];
choices.chosenX = [];
choices.chosenY = [];
choices.madeValidResp = [];

% -------------------------------------------------------------------------
% -------------- EXTRACT INFO FOR USER SCREEN DISPLAY ---------------------
% -------------------------------------------------------------------------
b = TrialRecord.CurrentBlock;
trl_b = TrialRecord.CurrentTrialWithinBlock;
conds_b = TrialRecord.ConditionsThisBlock;
condRepsRem = TrialRecord.User.condRepsRem(c);
outstr1 = ['Block: ',  num2str(b),'  cond: ', num2str(c), '  rewState: ', num2str(choices.rewState)];
dashboard(1, outstr1);
outstr2 = ['ch1:', choices.ch1_side, '   ', num2str(choices.ch1_rewProb), '   ', '   ch2: ', choices.ch2_side, '  ', num2str(choices.ch2_rewProb)];
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
% SCENE 1: INITIAL GAZE FIXATION

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

% --- PRINT SCENE ID USER SCREEN
outstr3 = 'Scene1: fix';
dashboard(3, outstr3);


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

sc1_wtHold = WaitThenHold(sc1_eyeCenter_oom);  
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
% SCENE 2: PRESENT STIM MOVIE, WATCH FOR KEY RESPONSE
% Depending on how the frame sequence is constructed, present the choice array
% by itself first.  Then present the stimulus pairs, according to movieMode -
% either as a simultaneous pair, a sequential pair, or repetitions thereof.
% Stimulus pairs instruct reward state.  After pairs are presented,
% subjects respond by hitting a left or right response key to select left
% or right choice stimuli, which are red and green circles presented to
% left and right randomly over trials.  Reward state is the reward
% probabiltiy associated with the choice array (one high, 80%, one low
% 20%).

% Timing strategy:
% Have scene start with just choice array, present movie, than continue
% wiht choice array.  Movie is 'overlaid' onto choice array, keeps timing
% between movie, response, and reward tight.
% Scene continues until the eye gaze WaitThenHold times out, or a key is
% pressed.  Arrange durations of last movie frame (choices only) so that
% this will be longer than total duration of WaitThenHold, so clocking out
% movie does not terminate the scene.

% --- PRINT SCENE ID USER SCREEN
outstr4 = 'Scene2: stim movie';
dashboard(3, outstr4);

% --- MAKE ADAPTORS
% --- 1. eye fix adaptor
sc2_eyeCenter = SingleTarget(eye_);
sc2_eyeCenter.Target = taskObj_fix;
sc2_eyeCenter.Threshold = eye_radius;
sc2_wtHold = WaitThenHold(sc2_eyeCenter);
sc2_wtHold.WaitTime = times.sc2_wait;
sc2_wtHold.HoldTime = times.sc2_hold; % entire duration of scene

% --- 2. key checking adaptor
sc2_key1 = KeyChecker(mouse_);
sc2_key1.KeyNum = 1;  % 1st keycode in GUI
sc2_key2 = KeyChecker(mouse_);
sc2_key2.KeyNum = 2;  % 2nd keycode in GUI
sc2_watchKeys = OrAdapter(sc2_key1);
sc2_watchKeys.add(sc2_key2);

% --- 3. movie adaptor
sc2_movie = ImageChanger(null_);
sc2_movie.List = movieFrames;

% --- COMBINE ADAPTORS
% use AllContinue to combine WaitThenHold and KeyChecker, so adaptor
% terminates if either fixation is broken or key is pressed
sc2_eye_key = AllContinue(sc2_wtHold);
sc2_eye_key.add(sc2_watchKeys);
% add choice image using Concurrent, but add sc2_eye_key first so eye fixation /
% key press controls scene timing
sc2_eye_key_movie = Concurrent(sc2_eye_key);
sc2_eye_key_movie.add(sc2_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_eye_key_movie);
scene2_start = run_scene(scene2);

% --- ANALYZE SCENE OUTCOME
if sc2_key1.Success && ~sc2_key2.Success
    choices.madeValidResp = true;
    choices.chosenKey = 1;
    choices.chosenSide = 'left';
    eventmarker(codes.chosenKey1);
    if strcmp(choices.ch1_side, 'left') % choice1, green
        choices.choiceSelected = 1; % green
        choices.chosenColor = 'green';
        choices.chosenX = choices.ch1_x;
        choices.chosenY = choices.ch1_y;
    elseif strcmp(choices.ch2_side, 'left') % choice2, red
        choices.choiceSelected = 2; % red
        choices.chosenColor = 'red';
        choices.chosenX = choices.ch2_x;
        choices.chosenY = choices.ch2_y;
    end
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    % dashboard(3, sprintf('Key 1 press time: %d ms', sc2_key1.Time(1)));
elseif sc2_key2.Success && ~sc2_key1.Success
    choices.madeValidResp = true;
    choices.chosenKey = 2;
    choices.chosenSide = 'right';
    eventmarker(codes.chosenKey2);
    if strcmp(choices.ch1_side, 'right') % choice1, green
        choices.choiceSelected = 1; % green
        choices.chosenColor = 'green';
        choices.chosenX = choices.ch1_x;
        choices.chosenY = choices.ch1_y;
    elseif strcmp(choices.ch2_side, 'right') % choice2, red
        choices.choiceSelected = 2; % red
        choices.chosenColor = 'red';
        choices.chosenX = choices.ch2_x;
        choices.chosenY = choices.ch2_y;
    end
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord as saved above
    TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;
    % dashboard(3, sprintf('Key 2 press time: %d ms', sc2_key2.Time(1)));
elseif ~sc2_key1.Success && ~sc2_key2.Success
    choices.madeValidResp = false;
    trialerror(1);  %'No response'
    choices.chosenKey = 0;
    abortTrial = true;
elseif sc2_key1.Success && sc2_key2.Success
    choices.madeValidResp = false;
    error('Both keys hit');
    choices.chosenKey = 0;
    eventmarker(codes.choseBothKeys);
    abortTrial = true;
elseif ~sc2_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.chosenKey = 0;
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
end

% -------------------------------------------------------------------------
% SCENE 3: GIVE PROBABILISTIC REWARD AND DISPLAY FEEDBACK

% --- PRINT SCENE ID USER SCREEN
outstr5 = 'Scene3: Feedback';
dashboard(3, outstr5);

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
if choices.choiceSelected == 1
    if randNum <= choices.ch1_rewProb
        choices.rewardTrial = true;
    end
elseif choices.choiceSelected == 2
    if randNum <= choices.ch2_rewProb
        choices.rewardTrial = true;
    end
end

% --- SAVE
% CHOICE INFORMATION
TrialRecord.User.Choices = choices;

% --- DISPLAY CHOICE AND REWARD FEEDBACK
if choices.madeValidResp
    if visualFeedback && choices.rewardTrial
        sc3_rewImg = ImageChanger(null_);
        sc3_rewImg.List = ...
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing, codes.choiceRing_on; ...
            {choices.rewImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.rewRing, codes.rewRing_on};
    elseif visualFeedback % all other cases,
        sc3_rewImg = ImageChanger(null_);
        sc3_rewImg.List = ...
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing, codes.choiceRing_on};
    end

else  % just the choices

    sc3_rewImg = ImageChanger(null_);
    sc3_rewImg.List = ...
        {{choices.ch1_fn, choices.ch2_fn }, [choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing, codes.choiceRing_on};
end
% --- PRINT CHOICE INFO TO USER SCREEN
outstr6 = ['choice: ', num2str(choices.choiceSelected), '   color: ', num2str(choices.chosenColor), '   rew: ', num2str(choices.rewardTrial)];
dashboard(4, outstr6);

% --- COMBINE EYE WTH with FEEDBACK
sc3_probRew = Concurrent(sc3_rewImg);
sc3_probRew.add(sc3_wtHold);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_probRew, taskObj_fix);
scene3_start = run_scene(scene3);

% --- CHECK BEHAVIORAL OUTCOMES
if sc3_wtHold.Success
    idle(0);
    TrialError(0); % correct trial
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
    % idle(0);
    return;
end


% --- SAVE DATA TO BHV2 OUTFILE
bhv_variable('condArray', TrialRecord.User.condArray, 'stimTimes', sc2_movie.Time, 'movieFrames', TrialRecord.User.movieFrames);







