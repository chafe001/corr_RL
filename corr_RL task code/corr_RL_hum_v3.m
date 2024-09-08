% -----------------------------------------------------------------------
% -----------------------  CORR_RL TASK CODE ----------------------------
% -----------------------------------------------------------------------

% Version history
% v1: first derivative of preceding xPairs task to incorporate
% multidimensional stimuli, enable definition of category manifolds within
% higher dimensional feature space.
% v2: implementing stimulus mask instead of feature-sharing noise stimuli
% to make perceptual discrimination easier.  Also implementing single pair
% per movie option to do the same.
% v3: modified to incorporate Dave's curve drawing code per Thomas'
% algorithm

% ---- notes from preceding xPairs task development

% FUTURE DIRECTIONS:
% 1. Modulate attention: synchrony will depend not only on stimulus
% correlation, but internal neural states, like attention. To modulate
% attention, have 1 pair in the stim movie appear in a color to induce a
% pop-out effect.  Contrast neural activity and performance when popout
% pair is an informative versus noise pair. In the former case, neural
% synchrony should add to stimulus synchrony and learning.  In the latter
% case, it should detract

% 2. Multiplex multiple stimulus dimensions into movie as separate
% 'channels', each of which conveys independent information about reward
% probablity.  Rank this from simple to complex, so that
% increments/decrements in reward probability depend on
% a. retinotopic location or color of stimulus
% b. associations between pairs of stimuli (implemented)
% c. number of stimuli of different color (if 3 red, then rewState = 1)
% d. categorical relationships between stimuli (if most large, then green)
% this will allow us to investigate how learning leads to abstraction, in
% an synaptically informed learning environment.
% e. vary spatial and temporal scales over which information must be
% integrated to learn the mapping between the stim movie and reward state,
% this will invoke working memory, and should require learning effects to
% climb visual hierarchy
% f. extend the above to include sequence learning, so that explicit
% sequences of stimuli, or the same stimuli in different sequences,
% indicate different reward states

% ------------------------------------------------------------------------
% PARAMETER HUNT: This task has a lot of knobs to turn, with a lot of
% unwanted perceptual and even some cognitive effects contaminating the
% computations we hope to recruit and study.  But maybe it just might work.
% Time to get data...

% 1st pass parameters:
% set two falsePairRatios, one of them should be 0 so subjects can get the
% mapping.  The other should be something like 0.3 or thereabouts, middling
% hard. Set pair reps to 100, and make the movie fast (flashy). Makes the
% potential to vary correlation stronger. Repetively drives neurons. stimDur 1
% frame, soa 10 or thereabouts.  Set high and low reward probs to 0.8 and
% 0.2 so get some RPEs going even with stable probabilities.

% 1st pass task performance:
% choppy, all or none, step functions, don't get it, don't get it, OK I got
% it.  This happens at various times within the block depending on
% perceptual difficulty of pairs selected.  No clear learning curve.
% Forgetting red/green mapping, so object bandit a complexity we may not
% need.  Implicit motor learning favors fixed response locations.
% Implementing. Modifying stimulus array to reduce explicit nature of
% process, pop-out of pairs, task weighs on spatial geometry discrimination
% rather than correlation detection (although these are related).  Need to
% add features, reduce spatial variance/cueing.


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
% v6: Implemented falsePairsRatio param to control how incorrect pairs (relative to reward state)
% are mixed to vary correlation strength of movies. Implemented corrStrength_mode param (either
% 'pairMix' or 'noiseMix') to flexibily use either pairs from the incorrect
% reward state (pairMix) or noisePairs (noiseMix) to modulate correlation
% strength. Updated user output.  Corrected bug in buildTrials (pairSeq
% vector was incorrectly set up, scrambling relationship between stim pairs
% and reward state). Discovered (remembered) that code will not work
% properly if when changes are made that vary the dimension of condArray,
% changes are not made to the condition file to reflect the new mapping
% between conditions and blocks.  As it is set up now, any change to the
% dimension of the looping variables (including falsePairsRatio) that
% ulimately change the dimensionality of condArray will introduce problems.

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


% -------------------------------------------------------------------------
% ------------------------- ERROR CODES -----------------------------------
% -------------------------------------------------------------------------
trialerror(0, 'validResp', 1, 'earlyResp', 2, 'noResp');

% -------------------------------------------------------------------------
% -------------------------- PARAMETERS -----------------------------------
% -------------------------------------------------------------------------
dbstop if error;
showcursor('off');
taskObj_fix = 1;

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------

% call fx to set trial timing
times = corr_RL_setTimes();

% save times to TrialRecord
TrialRecord.User.times = times;

% -------------------------------------------------------------------------
% --------------------------- EVENT CODES ---------------------------------
% -------------------------------------------------------------------------

% call fx to set trial event codes
codes = corr_RL_setCodes();

% save event codes to TrialRecord
TrialRecord.User.codes = codes;


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

    % buildTrials version notes:
    % v1 implements xPair design, using cue and noise stim.  Each movie
    % displays the two pairs associated with each reward state
    % v2 implements xPair design, but optionally only shows 1 pair from
    % each state per movie, and also uses a mask rather than feature
    % sharing noise stimuli to modulate stimulus correlation.  Versioning
    % in this way should keep intermediate functionality intact during
    % search for optimal task
    [condArray, params] = corr_RL_buildTrials_v2();

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
    TrialRecord.User.codes = codes;

end

% -------------------------------------------------------------------------
% --------------------- GENERATE STIMULUS MOVIE ---------------------------
% -------------------------------------------------------------------------
[movieFrames, pairSeq] = corr_RL_generateStimMovie_v2(TrialRecord);

% Save movie and pair sequence to TrialRecord
TrialRecord.User.movieFrames = movieFrames;
TrialRecord.User.pairSeq = pairSeq;

% -------------------------------------------------------------------------
% ----------------- INIT WITHIN BLOCK RESULT COUNTERS -----------------------
% -------------------------------------------------------------------------
if TrialRecord.CurrentTrialWithinBlock == 1
    TrialRecord.User.blockWins = 0;
    TrialRecord.User.blockLosses = 0;
    TrialRecord.User.netWins = 0;

    % test call Dave's curve drawing funciton from within ML
    genCurves();
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
choices.choiceImg = 'choiceRing.png';

% init choice variables
choices.chosenSide = [];
choices.responseKey = [];
choices.choseCorrect = []; % selected the choice with the higher reward probability
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

% --- PRINT TRIAL AND CUE MOVIE INFO TO USER SCREEN
switch TrialRecord.User.condArray(c).state
    case 1
        keyStr = 'Correct Key: LEFT';
    case 2
        keyStr = 'Correct Key: RIGHT';
end

trlInfoStr = strcat(keyStr, ...
    '  Trial:', num2str(t), ...
    '  Block:', num2str(b), ...
    '  Cond:', num2str(c), ...
    '  Cue percent:', num2str(TrialRecord.User.condArray(c).cuePercent), ...
    '  Total pairs: ', num2str(TrialRecord.User.params.movieStimReps));

pair_str = strcat('Cue pair L_ang:', num2str(TrialRecord.User.condArray(c).cuePair.leftStim.Angle), ...
    '  L_RGB: ', num2str(TrialRecord.User.condArray(c).cuePair.leftStim.FaceColor), ...
    '  L_FN: ', TrialRecord.User.condArray(c).cuePair.leftStim.FileName, ...
    '  R_ang: ', num2str(TrialRecord.User.condArray(c).cuePair.rightStim.Angle), ...
    '  R_RGB: ', num2str(TrialRecord.User.condArray(c).cuePair.rightStim.FaceColor), ...
    '  R_FN: ', TrialRecord.User.condArray(c).cuePair.rightStim.FileName);


dashboard(1, trlInfoStr);
dashboard(3, pair_str);

% write event codes to store ML condition and trial numbers
mult256 = floor(TrialRecord.CurrentTrialNumber/256) + 1;
mod256 = mod(TrialRecord.CurrentTrialNumber, 256);
% replaced idle() with eventmarker() for the human task code, prevents
% blinking of reward bar when called
eventmarker([TrialRecord.CurrentCondition mult256 mod256]);

% --- reward box for visual feedback
rewBox = BoxGraphic(null_);
netWinBox_height = TrialRecord.User.params.rewBox_height;
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
maxWinBox_width = TrialRecord.User.params.rewBox_width;
% figure out where to print white netWin reward box so it is left aligned
% with left edge of black maxWin reward box.  X position coordinate
% specifies screen coordinates of center of rectangle graphic. The center
% of the white bar is screen center -1/2 black bar width +1/2 white bar
% width
netWindBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);

rewBox.List = {[1 1 1], [1 1 1], [netWinBox_width netWinBox_height], [netWindBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width netWinBox_height], [0 TrialRecord.User.params.rewBox_yPos - netWinBox_height]};

sc1_tc = TimeCounter(rewBox);
sc1_tc.Duration = times.sc1_pretrial_ms;

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene1 = create_scene(sc1_tc);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene1_start = run_scene(scene1, codes.startFix); %'pretrial'

% -------------------------------------------------------------------------
% SCENE 2: PRESENT STIM MOVIE, ERROR IF KEY RESPONSE

% --- MAKE ADAPTOR(S)
% --- 1. key checking adaptor
sc2_key1 = KeyChecker(mouse_);
sc2_key1.KeyNum = 1;  % 1st keycode in GUI
sc2_key2 = KeyChecker(mouse_);
sc2_key2.KeyNum = 2;  % 2nd keycode in GUI
sc2_watchKeys = OrAdapter(sc2_key1);
sc2_watchKeys.add(sc2_key2);

% --- 3. movie adaptor
sc2_movie = ImageChanger(rewBox);
sc2_movie.List = movieFrames;
sc2_movie.Repetition = 1;

% --- COMBINE ADAPTORS
% use AllContinue to combine WaitThenHold and KeyChecker, so adaptor
% terminates if either fixation is broken or key is pressed
% sc2_fc_key = AllContinue(sc2_fc);
% sc2_fc_key.add(sc2_watchKeys);
% add choice image using Concurrent, but add sc2_eye_key first so eye fixation /
% key press controls scene timing
% sc2_movie_key = Concurrent(sc2_watchKeys);
sc2_movie_key = AllContinue(sc2_watchKeys);
sc2_movie_key.add(sc2_movie);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene2 = create_scene(sc2_movie_key, taskObj_fix);
scene2_start = run_scene(scene2);

% --- SAVE FRAME TIMES IN MOVIE
TrialRecord.User.movieFrameTimes = sc2_movie.Time;
% NOTE: each new User VAR has to be explicitly included in bhv_variable fx
% call at end of this script, so essential to include TrialRecord.User.movieFrameTimes
% in the list of variables saved to include it in the bhv2 behavioral
% outfile

% --- TERMINATE TRIAL IF EARLY RESPONSE
if sc2_key1.Success || sc2_key2.Success
    % requiring response AFTER movie
    trialerror('earlyResp');
    choices.madeValidResp = false;


    % --- CREATE AND RUN ERROR SCENE
    scError_tc = TimeCounter(rewBox);
    scError_tc.Duration = times.scError_ms;

    rewText = TextGraphic(null_);
    rewText.Position = [0 TrialRecord.User.params.rewBox_yPos - 10];
    rewText.FontSize = 42;
    rewText.FontColor = [1 1 1];
    rewText.HorizontalAlignment = 'center';
    rewText.VerticalAlignment = 'middle';
    rewText.Text = 'EARLY RESPONSE';

    scError_tc_text = AndAdapter(scError_tc);
    scError_tc_text.add(rewText);

    errorScene = create_scene(scError_tc_text);
    errorStart = run_scene(errorScene);

    % --- SAVE BEHAVIORAL DATA
    bhv_variable( ...
    'TrialRecord', TrialRecord, ...
    'choices', choices, ...
    'condArray', TrialRecord.User.condArray, ...
    'params', TrialRecord.User.params, ...
    'movieFrames', TrialRecord.User.movieFrames, ...
    'movieFrameTimes', TrialRecord.User.movieFrameTimes);

    % --- 'RETURN' CALL TERMINATES TRIAL EARLY
    return;
end



% -------------------------------------------------------------------------
% SCENE 3: RESPONSE WINDOW

% --- MAKE ADAPTOR(S)
% --- 1. timeCounter
sc3_tc = TimeCounter(rewBox);
sc3_tc.Duration = times.sc3_response_ms;

% --- 2. key checking adaptor
sc3_key1 = KeyChecker(mouse_);
sc3_key1.KeyNum = 1;  % 1st keycode in GUI
sc3_key2 = KeyChecker(mouse_);
sc3_key2.KeyNum = 2;  % 2nd keycode in GUI
sc3_watchKeys = OrAdapter(sc3_key1);
sc3_watchKeys.add(sc3_key2);

% combine watchKeys and TimeCounter
sc3_responseWindow = AllContinue(sc3_watchKeys);
sc3_responseWindow.add(sc3_tc);

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene3 = create_scene(sc3_responseWindow, taskObj_fix);
% fliptime is time the trialtime in ms at which the first frame of the
% screen is pressented and is the return value of run_scene.  Logs timing
% of scene transitions
scene3_start = run_scene(scene3, codes.beginRespWindow); %'pretrial'

% --- ANALYZE SCENE OUTCOME
if sc3_key1.Success && ~sc3_key2.Success
    choices.madeValidResp = true;
    choices.responseKey = 1;
    choices.chosenSide = 'left';
    eventmarker(codes.response_key1);
    % --- COMPUTE RT
    rt = sc3_key1.Time - scene3_start;
    % --- LOG CORRECT TRIAL IN TRIALRECORD
    trialerror('validResp');

    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;

elseif sc3_key2.Success && ~sc3_key1.Success
    choices.madeValidResp = true;
    choices.responseKey = 2;
    choices.chosenSide = 'right';
    eventmarker(codes.response_key2);
    % --- See comments above for rt
    rt = sc3_key2.Time - scene3_start;
    % --- LOG CORRECT TRIAL IN TRIALRECORD
    trialerror('validResp')
   
    % DECREMENT REP COUNTER FOR THIS CONDITION, c is condition number in
    % TrialRecord.User.condRepsRem(c) = TrialRecord.User.condRepsRem(c) - 1;

elseif ~sc3_key1.Success && ~sc3_key2.Success
    choices.madeValidResp = false;
    trialerror('noResp');  % no response
    choices.responseKey = 0;
    bhv_variable( ...
    'TrialRecord', TrialRecord, ...
    'choices', choices, ...
    'condArray', TrialRecord.User.condArray, ...
    'params', TrialRecord.User.params, ...
    'movieFrames', TrialRecord.User.movieFrames, ...
    'movieFrameTimes', TrialRecord.User.movieFrameTimes);

    % --- 'RETURN' CALL TERMINATES TRIAL EARLY
    return;
end

% -------------------------------------------------------------------------
% SCENE 4: GIVE PROBABILISTIC REWARD AND DISPLAY FEEDBACK

% --- DETERMINE WHETHER TO REWARD TRIAL
% select random number between 0 and 1 to determine probabilistic reward
choices.randNum_rew = rand();

if choices.madeValidResp
    if choices.responseKey == 1
        choices.respStr = 'KEY HIT: LEFT';
        % determine if correct (high value) choice was selected
        if TrialRecord.User.condArray(c).state == 1
            choices.choseCorrect = true;
            if choices.randNum_rew < TrialRecord.User.params.highRewProb  % --- WIN, HIGH PROB ---
                choices.rewardTrial = true;
                TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  WIN, SELECTED HIGH PROB';
            else  % --- LOSS, HIGH PROB ---
                choices.rewardTrial = false;
                TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  LOSS, SELECTED HIGH PROB';
            end
        elseif TrialRecord.User.condArray(c).state == 2
            choices.choseCorrect = false;
            if choices.randNum_rew < TrialRecord.User.params.lowRewProb  % --- WIN, LOW PROB ---
                choices.rewardTrial = true;
                TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  WIN, SELECTED LOW PROB';
            else  % --- LOSS, LOW PROB ---
                choices.rewardTrial = false;
                TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  LOSS, SELECTED LOW PROB';
            end
        end

    elseif choices.responseKey == 2
        choices.respStr = 'KEY HIT: RIGHT';
        % determine if correct (high value) choice was selected
        if TrialRecord.User.condArray(c).state == 1
            choices.choseCorrect = false;
            if choices.randNum_rew < TrialRecord.User.params.lowRewProb  % --- WIN, LOW PROB ---
                choices.rewardTrial = true;
                TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  WIN, SELECTED LOW PROB';
            else  % --- LOSS, LOW PROB ---
                choices.rewardTrial = false;
                TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  LOSS, SELECTED LOW PROB';
            end
        elseif TrialRecord.User.condArray(c).state == 2
            choices.choseCorrect = true;
            if choices.randNum_rew < TrialRecord.User.params.highRewProb  % --- WIN, HIGH PROB ---
                choices.rewardTrial = true;
                TrialRecord.User.blockWins = TrialRecord.User.blockWins + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  WIN, SELECTED HIGH PROB';
            else  % --- LOSS, HIGH PROB ---
                choices.rewardTrial = false;
                TrialRecord.User.blockLosses = TrialRecord.User.blockLosses + 1;
                TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;
                choices.resultStr = '  LOSS, SELECTED HIGH PROB';
            end
        end

    end

else  % NO VALID RESPONSE
    choices.respStr = ' NO RESP';
    choices.resultStr = ' NO RESULT';
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

% --- OUTPUT CHOICE REWARD RESULT TO USER SCREEN
respResStr = strcat(choices.respStr, '  ---  ', choices.resultStr);
dashboard(2, respResStr)

% --- UPDATE REWARD BOX WITH THIS RESULT
netWinBox_width = TrialRecord.User.netWins * TrialRecord.User.params.rewBox_degPerWin;
netWindBox_center = (netWinBox_width / 2) - (maxWinBox_width / 2);
rewBox.List = {[1 1 1], [1 1 1], [netWinBox_width netWinBox_height], [netWindBox_center TrialRecord.User.params.rewBox_yPos]; [0 0 0], [0 0 0], [maxWinBox_width netWinBox_height], [0 TrialRecord.User.params.rewBox_yPos - netWinBox_height]};

% --- INSTANTIATE IMAGECHANGER OBJ for FEEDBACK MOVIE
sc4_rewImg = ImageChanger(rewBox);

if choices.madeValidResp
    if choices.rewardTrial
        sc4_rewImg.List = ...
            {{choices.choiceImg}, [0 0], times.choiceRing_frames, codes.choiceRing_on; ...
            {choices.rewImg}, [0 0], times.rewRing_frames, codes.rewRing_on};
    else
        sc4_rewImg.List = ...
            {{choices.choiceImg}, [0 0], times.choiceRing_frames, codes.choiceRing_on};
    end
else
    sc4_rewImg.List = ...
        {[choices.errorImg], [0 0], times.choiceRing_frames, codes.noResponse};

end

% --- CREATE AND RUN SCENE USING ADAPTOR CHAINS
scene4 = create_scene(sc4_rewImg, taskObj_fix);
scene4_start = run_scene(scene4);

% --- SAVE DATA TO BHV2 FILE
% NOTE!!: Make sure 'File type' dropdown in GUI is set to BHV2.  Matlab
% format (.mat) works but can't figure out how to control which variables
% get saved to matlab outfile

bhv_variable( ...
    'TrialRecord', TrialRecord, ...
    'choices', choices, ...
    'condArray', TrialRecord.User.condArray, ...
    'params', TrialRecord.User.params, ...
    'movieFrames', TrialRecord.User.movieFrames, ...
    'movieFrameTimes', TrialRecord.User.movieFrameTimes);

