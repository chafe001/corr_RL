% -----------------------------------------------------------------------
% -------------------------  XPAIRS TASK CODE ----------------------------
% -----------------------------------------------------------------------

% Next iteration of task designed to engage both hebbian and reinforcement
% learning

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
% v4: Removing eye fix for human beta testing. Implementing progress bar to
% illustrate cumulative wins and losses within the block, with threshold
% for payout per block ($5). Checking block control is working.  Checking
% behavioral data output is working.  V3 code seems to have good visual
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
showcursor('on');
taskObj_fix = 1;
eye_radius = 3;
visualFeedback = true;
rew.duration = 200;
rew.numDrops = 1;

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------
times.pretrial_ms = 300;  % in milliseconds
% times below specified in screen refresh units, absolute time depends on
% graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
% in new laptops, etc
% scene 1 is gaze fixation target
times.sc1_frames = 20;
% scene 2 presents choice array and stimulus pairs (movie)
times.sc2_frames = 1000; % make sure long enough for movie to complete
% scene 3 provides feedback on choice
times.sc3_frames = 1000; % duration of scene depends on choice ring timing
times.choiceRing_frames = 15;
times.rewRing_frames = 20;               % screen refresh units

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
codes.startTrial = 10;
codes.preMovie_on = 20;
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
    [condArray, condReps, params] = xPairs_buildTrials_mix_v1();
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

[movieFrames] = xPairs_generateStimMovie_mix_v2(TrialRecord);

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
outStr = ['Reps remaining:', num2str(TrialRecord.User.condRepsRem)];
dashboard(2, outStr);

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
% idle(times.pretrial_ms, [], [TrialRecord.CurrentCondition mult256 mod256]);

% -------------------------------------------------------------------------
% SCENE 1: FIXATION TARGET

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

% --- PRINT SCENE ID USER SCREEN
outstr3 = 'Scene1: fix';
dashboard(3, outstr3);

% --- MAKE ADAPTOR(S)
% just need FrameCounter here, basically a clock, no contingency on eye
% position etc.  Will present the fixation target in the call to
% create_scene
sc1_fix = FrameCounter(null_);
sc1_fix.NumFrame = times.sc1_frames; % 0.5 sec at 60 Hz

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_fix, taskObj_fix);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, codes.startTrial); %'fixOn'

% --- NO BEHAVIORAL SCENE OUTCOMES TO CHECK

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

% --- PRINT SCENE ID USER SCREEN
outstr4 = 'Scene2: stim movie';
dashboard(3, outstr4);

% --- MAKE ADAPTORS
% --- 1. frame counter adaptor
sc2_fc = FrameCounter(null_);
sc2_fc.NumFrame = times.sc2_frames;

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
sc2_fc_key = AllContinue(sc2_fc);
sc2_fc_key.add(sc2_watchKeys);
% add choice image using Concurrent, but add sc2_eye_key first so eye fixation /
% key press controls scene timing
sc2_movie_key = Concurrent(sc2_fc_key);
sc2_movie_key.add(sc2_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_movie_key);
scene2_start = run_scene(scene2);

% --- ANALYZE SCENE OUTCOME
if sc2_key1.Success && ~sc2_key2.Success
    choices.madeValidResp = true;
    choices.responseKey = 1;
    choices.chosenSide = 'left';
    eventmarker(codes.response_key1);
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
    
elseif sc2_key2.Success && ~sc2_key1.Success
    choices.madeValidResp = true;
    choices.responseKey = 2;
    choices.chosenSide = 'right';
    eventmarker(codes.response_key2);
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
    dashboard(4, sprintf('Cond: %d, reps remaining: %d', c, TrialRecord.User.condRepsRem(c)));
elseif ~sc2_key1.Success && ~sc2_key2.Success
    choices.madeValidResp = false;
    trialerror(1);  %'No response'
    choices.responseKey = 0;
    abortTrial = true;
elseif ~sc2_eyeCenter.Success
    % scene terminated with eye outside of window, eye fixation error
    choices.responseKey = 0;
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
% --- 1. frame counter adaptor
sc3_fc = FrameCounter(null_);
sc3_fc.NumFrame = times.sc3_frames;

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
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on; ...
            {choices.rewImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.rewRing_frames, codes.rewRing_on};
    elseif visualFeedback % all other cases,
        sc3_rewImg = ImageChanger(null_);
        sc3_rewImg.List = ...
            {{choices.choiceImg, choices.ch1_fn, choices.ch2_fn }, [choices.chosenX choices.chosenY; choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on};
    end

else  % just the choices

    sc3_rewImg = ImageChanger(null_);
    sc3_rewImg.List = ...
        {{choices.ch1_fn, choices.ch2_fn }, [choices.ch1_x choices.ch1_y; choices.ch2_x choices.ch2_y], times.choiceRing_frames, codes.choiceRing_on};
end
% --- PRINT CHOICE INFO TO USER SCREEN
outstr6 = ['choice: ', num2str(choices.choiceSelected), '   color: ', num2str(choices.chosenColor), '   rew: ', num2str(choices.rewardTrial)];
dashboard(4, outstr6);

% --- COMBINE EYE WTH with FEEDBACK
sc3_probRew = Concurrent(sc3_rewImg);
sc3_probRew.add(sc3_fc);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_probRew, taskObj_fix);
scene3_start = run_scene(scene3);

% --- CHECK BEHAVIORAL OUTCOMES
% erase stimuli from screen
idle(0);

% 
% % bomb trial if error
% if abortTrial
%     % idle(0);
%     return;
% end
% 

% --- SAVE DATA TO BHV2 OUTFILE
bhv_variable('condArray', TrialRecord.User.condArray, 'stimTimes', sc2_movie.Time, 'movieFrames', TrialRecord.User.movieFrames);







