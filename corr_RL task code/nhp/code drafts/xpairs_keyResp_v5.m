% -----------------------------------------------------------------------
% -------------------------  XPAIRS TASK CODE ----------------------------
% -----------------------------------------------------------------------

% Next iteration of task designed to engage both hebbian and reinforcement
% learning

% NOTE ON GRAPHICS: adjust screen diagonal and distance in MonkeyLogic gui
% so combination produces about 20 pixels per degree.  Graphics more or
% less work across platforms at that resolution.

% DESIGN ALTERNATIVE: incorporate correlation directly into the choice
% stimuli themselves, pattern of correlation, sequence, order of changes in
% the two choice stimuli.  Visually simpler, removes spatial confounds.
% Information could be embedded in simlutanous states of the two choices
% while they are changing color, orientation, blinking on and off.

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
% simultaneous, STDP, repeat, noise. xPairs implemented.
% v3: New way to implement xPairs.  Idea is to mix the two pairs that map
% to one reward state in each movie.  Also to mix the four pairs that map
% to the two reward states in different proportion. This makes it
% newsome/shadlen-esque, in the sense that we can have 60/40 red/green
% combinations of pairs in each movie. But the key thing is that the
% variable manipulated is degree of correlation within each movie, or maybe
% degree of correlation that implies reward state A vs B.
% v4: Removing eye fix for human beta testing.  Modified user-defined
% condition selection function xPairs_selectCond_v1.  Seems to be working.
% v5: Implementing progress bar to illustrate cumulative wins and losses
% within the block, with threshold for payout per block.

% V3 code seems to have good visual
% flexibility to break apparent motion illusion, control timing, noise
% level, other perceptually relevant manipulations.  Need to find a sweet
% spot minimizing perceptual/conscious/model based processing of task.
% Maybe brief and masked stimuli with added noise so there is not so much
% shape (spatial) pop-out of stimuli.  What is supposed to be a correlation
% task looks like a shape task (but shape is spatial correlation so maybe
% OK).  Maybe explore correlation in other domains.  For example, make the
% choice stimuli mutli-dimensional (color, orientation, spatial frequency of gabor
% for example). See if finding feature correlations holding location
% constant has different perceptual appearance.

% This should be good for psychophysics, can compute thresholds, etc.
% Links also to David Leopold's experiment, we can look for biases in
% STDP pairs shifting thresholds. That is, if A->B with greater frequency,
% does this shift psychophyscial performance of any pairs with B.  Will
% need to fit psychometric functions to performance to detect this most
% likely, small effects, need sensitive measures.

% So imagining a couple of modes:
% 1. Proportional xPairs. Mix reward state A and B pairs (all 4 pairs
% randomly selected by buildStimPairs) in varying proportion.
% 2. Proportional xPairs with noise. Like above but varying number of noise
% pairs included.  This generally weakens correlation strength between
% individual stimuli.

% Thinking to vary association strength on a trial-by-trial basis (rather
% than blocks).  This keeps association strength and RPE varying at the
% trial level, and evaluation of association strength and RPE on choice
% probability also at the trial rather than block levels.

% Algorithm:
% Main difference is in how stim pairs are allocated to conditions.  In
% this case, each condition will be associated with all 4 stimuli and all
% 4 pairs between the stimuli, the only difference being the proportion of
% pairs implicating each state and the degree of noise (if implemented).

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
% showcursor('off');
taskObj_fix = 1;
eye_radius = 3;
visualFeedback = true;
rew.duration = 200;
rew.numDrops = 1;


% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------
times.idle_ms = 100;
% times below specified in screen refresh units, absolute time depends on
% graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
% in new laptops, etc
% scene 1 is pretrial
times.sc1_frames = 30;
% scene 2 is gaze fixation target
times.sc2_frames = 5;
% scene 3 presents choice array and stimulus pairs (movie)
times.sc3_frames = 1000; % make sure long enough for movie to complete
% scene 4 provides feedback on choice
times.sc4_frames = 500; % duration of scene depends on choice ring timing
times.choiceRing_frames = 10;
times.rewRing_frames = 10;               % screen refresh units

% save times to TrialRecord
TrialRecord.User.times = times;

% -------------------------------------------------------------------------
% --------------------------- EVENT CODES ---------------------------------
% -------------------------------------------------------------------------
% Event codes are time stamps for trial events
codes.startPretrial = 10;
codes.startFix = 20;
codes.startMovie = 30;
codes.imgPair_on = 40;
codes.imgPair_off = 50;
codes.img1_on = 60;
codes.img1_off = 70;
codes.img2_on = 80;
codes.img2_off = 90;
codes.endMovie = 100;
codes.response_key1 = 110;
codes.response_key2 = 120;
codes.choiceRing_on = 130;
codes.rewRing_on = 140;
codes.noEye = 150;
codes.brokeEye = 160;


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

    % --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
    outStr1 ='Trial stage: Building trials';
    dashboard(1, outStr1);

    [condArray, condReps, params] = xPairs_buildTrials_mix_v2();
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

% --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
outStr1 ='Trial stage: Generating movie';
dashboard(1, outStr1);

[movieFrames] = xPairs_generateStimMovie_mix_v2(TrialRecord);

% Save movie to TrialRecord
TrialRecord.User.movieFrames = movieFrames;

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

% -------------------------------------------------------------------------
% ---------------- SET CHOICE AND REWARD PARAMETERS -----------------------
% -------------------------------------------------------------------------

% set the choice feebback images
choices.rewImg = 'rewRing.png';
choices.choiceImg = 'choiceRing.png';
% set the reward box image parameters

% extract reward state
choices.rewState = TrialRecord.User.condArray(c).rewState;
% extract choice 1 (green) parameters
choices.ch1_side = TrialRecord.User.condArray(c).choice1_side;
choices.ch1_fn = TrialRecord.User.condArray(c).choice1_fn;
choices.ch1_x = TrialRecord.User.condArray(c).choice1_x;
choices.ch1_y = TrialRecord.User.condArray(c).choice1_y;
choices.ch1_rewProb = TrialRecord.User.condArray(c).choice1_rewProb;
% extract choice 2 (red) parameters
choices.ch2_side = TrialRecord.User.condArray(c).choice2_side;
choices.ch2_fn = TrialRecord.User.condArray(c).choice2_fn;
choices.ch2_x = TrialRecord.User.condArray(c).choice2_x;
choices.ch2_y = TrialRecord.User.condArray(c).choice2_y;
choices.ch2_rewProb = TrialRecord.User.condArray(c).choice2_rewProb;
% init choices (outcome) variables reflecting subject response
choices.chosenSide = [];
choices.responseKey = [];
choices.choiceSelected = [];  % ch1 or ch2, green or red respectively
choices.selectedHighProb = []; % selected the choice with the higher reward probability
choices.chosenColor = [];
choices.chosenX = [];
choices.chosenY = [];
choices.madeValidResp = [];


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

% -------------------------------------------------------------------------
% SCENE 1: PRETRIAL
% idle(duration, [RGB], eventcodes) changes background color, has timer
% built in, and writes event codes. Empty brackets for screen color leaves
% color unchanged.

% --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
outStr1 ='Trial stage: Pretrial';
dashboard(1, outStr1);

% write event codes to DAQ to capture ML trial number and condition
% number in SpikeGadgets datafile
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);

% >>> SAVE BEHAVIORAL EVENT
% --- write three eventcodes, each an 8-bit word, to DAQ at trial start that reflect ML condition
% number and trial number
idle(times.idle_ms, [], [TrialRecord.CurrentCondition mult256 mod256]);

sc1_pt = FrameCounter(null_);
sc1_pt.NumFrame = times.sc1_frames;

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_pt);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, codes.startPretrial); %'pretrial'

% -------------------------------------------------------------------------
% SCENE 2: FIXATION TARGET

% --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
b = TrialRecord.CurrentBlock;
trl_b = TrialRecord.CurrentTrialWithinBlock;
conds_b = TrialRecord.ConditionsThisBlock;
condRepsRem = TrialRecord.User.condRepsRem(c);
outStr1 ='Trial stage: Start fixation';
dashboard(1, outStr1);
outStr2 = ['Block: ',  num2str(b),'  cond: ', num2str(c), '  rewState: ', num2str(choices.rewState)];
dashboard(2, outStr2);
outStr3 = ['Reps remaining:', num2str(TrialRecord.User.condRepsRem)];
dashboard(3, outStr3);

% --- MAKE ADAPTOR(S)
% --- reward box for visual feedback
rewBox = BoxGraphic(null_);
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
maxWinBox_width = TrialRecord.User.params.rewBox_width;
% --- have to make sure netWinBox_width is not less than 0 or list
% assignment for BoxGraphic crashes.  0 works. If netWins goes below 0
% graphics still work to print a white netWinBox of 0 length to screen (so
% no net reward bar).  Also make sure netWinBox is not greater than
% maxWinBox. If it is, set nettWinBox to maxWinBox.  This prevents white
% netWin bar from extending beyond black maxWinBox.
if netWinBox_width < 0
    netWinBox_width = 0;
elseif netWinBox_width > maxWinBox_width
    netWinBox_width = maxWinBox_width;
end

% figure out where to print white netWin reward box so it is left aligned
% with left edge of black maxWin reward box.  X position coordinate
% specifies screen coordinates of center of rectangle graphic. The center
% of the white bar is screen center -1/2 black bar width +1/2 white bar
% width
netWindBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);

rewBox.List = {[1 1 1], [1 1 1], [netWinBox_width 1], [netWindBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width 1], [0 TrialRecord.User.params.rewBox_yPos - 1]};

% --- frame counter to control scene duration
sc2_fc = FrameCounter(rewBox);
sc2_fc.NumFrame = times.sc2_frames; % 0.5 sec at 60 Hz

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_fc, taskObj_fix);
scene2_start = run_scene(scene2, codes.startFix); %'fixOn'

% --- NO BEHAVIORAL SCENE OUTCOMES TO CHECK

% -------------------------------------------------------------------------
% SCENE 3: PRESENT STIM MOVIE, WATCH FOR KEY RESPONSE

% --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
outStr1 ='Trial stage: Run stim movie';
dashboard(1, outStr1);

% Depending on how the frame sequence is constructed, present the choice array
% by itself first.  Then present the stimulus pairs, according to movieMode -
% either as a simultaneous pair, a sequential pair, or repetitions thereof.
% Stimulus pairs instruct reward state.  After pairs are presented,
% subjects respond by hitting a left or right response key to select left
% or right choice stimuli, which are red and green circles presented to
% left and right randomly over trials.  Reward state is the reward
% probabiltiy associated with the choice array (one high, 80%, one low
% 20%).

% --- MAKE ADAPTORS



% --- MAKE ADAPTOR(S)
% --- reward box for visual feedback
rewBox = BoxGraphic(null_);
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
maxWinBox_width = TrialRecord.User.params.rewBox_width;
% --- have to make sure netWinBox_width is not less than 0 or list
% assignment for BoxGraphic crashes.  0 works. If netWins goes below 0
% graphics still work to print a white netWinBox of 0 length to screen (so
% no net reward bar).  Also make sure netWinBox is not greater than
% maxWinBox. If it is, set nettWinBox to maxWinBox.  This prevents white
% netWin bar from extending beyond black maxWinBox.
if netWinBox_width < 0
    netWinBox_width = 0;
elseif netWinBox_width > maxWinBox_width
    netWinBox_width = maxWinBox_width;
end

% figure out where to print white netWin reward box so it is left aligned
% with left edge of black maxWin reward box.  X position coordinate
% specifies screen coordinates of center of rectangle graphic. The center
% of the white bar is screen center -1/2 black bar width +1/2 white bar
% width
netWindBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);

rewBox.List = {[1 1 1], [1 1 1], [netWinBox_width 1], [netWindBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width 1], [0 TrialRecord.User.params.rewBox_yPos - 1]};





% --- 1. frame counter adaptor
sc3_fc = FrameCounter(null_);
sc3_fc.NumFrame = times.sc3_frames;

% --- 2. key checking adaptor
sc3_key1 = KeyChecker(mouse_);
sc3_key1.KeyNum = 1;  % 1st keycode in GUI
sc3_key2 = KeyChecker(mouse_);
sc3_key2.KeyNum = 2;  % 2nd keycode in GUI
sc3_watchKeys = OrAdapter(sc3_key1);
sc3_watchKeys.add(sc3_key2);

% --- 3. movie adaptor
sc3_movie = ImageChanger(rewBox);
sc3_movie.List = movieFrames;

% --- COMBINE ADAPTORS
% use AllContinue to combine WaitThenHold and KeyChecker, so adaptor
% terminates if either fixation is broken or key is pressed
sc3_fc_key = AllContinue(sc3_fc);
sc3_fc_key.add(sc3_watchKeys);
% add choice image using Concurrent, but add sc3_eye_key first so eye fixation /
% key press controls scene timing
sc3_movie_key = Concurrent(sc3_fc_key);
sc3_movie_key.add(sc3_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_movie_key, taskObj_fix);
scene3_start = run_scene(scene3, codes.startMovie);

% --- ANALYZE SCENE OUTCOME
if sc3_key1.Success && ~sc3_key2.Success
    choices.madeValidResp = true;
    choices.responseKey = 1;
    choices.chosenSide = 'left';
    eventmarker(codes.response_key1);
    % set rt
    rt = sc3_key1.Time;
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

elseif sc3_key2.Success && ~sc3_key1.Success
    choices.madeValidResp = true;
    choices.responseKey = 2;
    choices.chosenSide = 'right';
    eventmarker(codes.response_key2);
    % set rt
    rt = sc3_key2.Time;
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
elseif ~sc3_key1.Success && ~sc3_key2.Success
    choices.madeValidResp = false;
    trialerror(1);  %'No response'
    choices.responseKey = 0;
    abortTrial = true;
elseif ~sc3_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.responseKey = 0;
    idle(0, [], codes.brokeEye);
    trialerror(3);  %'Break fixation'
    abortTrial = true;
end


% -------------------------------------------------------------------------
% SCENE 4: GIVE PROBABILISTIC REWARD AND DISPLAY FEEDBACK

% --- BUILD ADAPTOR CHAINS
% --- 1. frame counter adaptor
sc4_fc = FrameCounter(null_);
sc4_fc.NumFrame = times.sc4_frames;


% --- DETERMINE WHETHER TO REWARD TRIAL
% select random number between 0 and 1
choices.randNum_rew = rand();
% initialize reward trial to false
choices.rewardTrial = false;
% set rewardTrial to true if randNum is less than or equal to reward probability
% associated with the selected key
if choices.choiceSelected == 1

    % determine if subj selected the higher value choice
    if choices.ch1_rewProb > choices.ch2_rewProb
        choices.selectedHighProb = true;
    elseif choices.ch1_rewProb < choices.ch2_rewProb
        choices.selectedHighProb = false;
    elseif choices.ch1_rewProb == choices.ch2_rewProb
        choices.selectedHighProb = NaN;
    end

    % randomly reward choice 1
    if choices.randNum_rew <= choices.ch1_rewProb
        choices.rewardTrial = true;
        TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
    else
        TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
    end

elseif choices.choiceSelected == 2

    % determine if subj selected the higher value choice
    if choices.ch2_rewProb > choices.ch1_rewProb
        choices.selectedHighProb = true;
    elseif choices.ch2_rewProb < choices.ch1_rewProb
        choices.selectedHighProb = false;
    elseif choices.ch2_rewProb == choices.ch1_rewProb
        choices.selectedHighProb = NaN;
    end

    % randomly reward choice 1
    if choices.randNum_rew <= choices.ch2_rewProb
        choices.rewardTrial = true;
        TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
    else
        TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
        TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;

    end
end

% --- if blockLosses > blockWins, reset counters to 0 to prevent
% accumulation of a deficit, don't want a hole subj has to dig out of
% before display shows accumulation of additional wins
if TrialRecord.User.netWins < 0
    TrialRecord.User.blockWins = 0;
    TrialRecord.User.blockLosses = 0;
    TrialRecord.User.netWins = 0;
end


% --- SAVE
% CHOICE INFORMATION
TrialRecord.User.Choices = choices;

% --- DISPLAY CHOICE AND REWARD FEEDBACK

% --- update rewBox size to reflect this outcome
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
% --- have to make sure netWinBox_width is not less than 0 or list
% assignment for BoxGraphic crashes.  0 works. If netWins goes below 0
% graphics still work to print a white netWinBox of 0 length to screen (so
% no net reward bar).  Also make sure netWinBox is not greater than
% maxWinBox. If it is, set nettWinBox to maxWinBox.  This prevents white
% netWin bar from extending beyond black maxWinBox.
if netWinBox_width < 0
    netWinBox_width = 0;
elseif netWinBox_width > maxWinBox_width
    netWinBox_width = maxWinBox_width;
end

% figure out where to print white netWin reward box so it is left aligned
% with left edge of black maxWin reward box.  X position coordinate
% specifies screen coordinates of center of rectangle graphic. The center
% of the white bar is screen center -1/2 black bar width +1/2 white bar
% width
netWindBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);


rewBox.List = {[1 1 1], [1 1 1], [netWinBox_width 1], [netWindBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width 1], [0 TrialRecord.User.params.rewBox_yPos - 1]};

if TrialRecord.User.params.printOutcome
    rewText = TextGraphic(null_);
    rewText.Position = [0 TrialRecord.User.params.rewText_yPos];
    rewText.FontSize = 42;
    rewText.FontColor = [1 1 1];
    rewText.HorizontalAlignment = 'center';
    rewText.VerticalAlignment = 'middle';
    rewText.Text = '';
end

if choices.madeValidResp

    if visualFeedback && choices.rewardTrial
        sc4_rewImg = ImageChanger(rewBox);
        sc4_rewImg.List = ...
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on; ...
            {choices.rewImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.rewRing_frames, codes.rewRing_on};

        if TrialRecord.User.params.printOutcome
            rewText.Text = 'WIN';
        end

    elseif visualFeedback % all other cases,
        sc4_rewImg = ImageChanger(rewBox);
        sc4_rewImg.List = ...
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on};

        if TrialRecord.User.params.printOutcome
            rewText.Text = 'LOSS';
        end

    end

else  % just the choices

    sc4_rewImg = ImageChanger(rewBox);
    sc4_rewImg.List = ...
        {{choices.ch1_fn, choices.ch2_fn }, [choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on};
end
% --- PRINT CHOICE INFO TO USER SCREEN
outstr3 = ['blockWins: ', num2str(TrialRecord.User.blockWins), '   blockLosses: ', num2str(TrialRecord.User.blockLosses), '   netWins: ', num2str(TrialRecord.User.netWins)];
dashboard(4, outstr3);

% --- COMBINE REW IMG WTH with FEEDBACK
sc4_probRew = Concurrent(sc4_rewImg);
sc4_probRew.add(sc4_fc);
% --- update rewBox width so changes with text feedback
% netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
% sc4_probRew.add(rewBox);
if TrialRecord.User.params.printOutcome
    sc4_probRew.add(rewText);
end

% --- PRINT TRIAL STAGE AND INFO TO USER SCREEN
outStr1 ='Trial stage: Reward and feedback';
dashboard(1, outStr1);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene4 = create_scene(sc4_probRew, taskObj_fix);
scene4_start = run_scene(scene4);

% --- SAVE DATA TO BHV2 OUTFILE
bhv_variable('choices', choices, 'condArray', TrialRecord.User.condArray, 'stimTimes', sc3_movie.Time, 'movieFrames', TrialRecord.User.movieFrames);







