function [times] = corr_RL_nhp_setTimes_v1()

% task pace is heavily dependent on refresh rate and hardware
COMPUTER = getenv('COMPUTERNAME');

switch COMPUTER
    case 'MATTWALLIN'
        % video runs at 60 Hz
        
        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_precue_eyejoy_waitTime_ms = 1000;    
        times.sc2_precue_eyejoy_holdTime_ms = 500;      

        % --- s3: stimulus movie
        times.sc3_precue_eyejoy_waitTime_ms = 1000; 
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_precue_eyejoy_holdTime_ms = 10000; 
        times.sc3_preMovie_frames = 20;  
        times.sc3_stim_frames = 4; 
        times.sc3_soa_frames = 4; 
        times.sc3_interPair_frames = 30; 
        times.sc3_curve_frames = 10; 
        times.sc3_postMovie_frames = 20;

        % --- s4: joystick response
        times.sc4_eye_waitTime_ms = 2000;
        times.sc4_eye_holdTime_ms = 75;
        times.sc4_joy_waitTime_ms = 2000;
        times.sc4_joy_holdTime_ms = 75;



        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;




        % stimDur = 2000;                      % Duration stimulus is on the screen in ms
        % afterStim = 100000;                 % Duration of blank screen after stimulus presentation while waiting for joy; should be very long
        times.stim_joy_waitTime_ms = 5000;          % Time allowed to make post-probe response to one of the stim targets (MultiTarget) % was 2000, increased to get rid of speed causing side bias
        times.stim_joy_holdTime_ms = 75;          % Time required to hold chosen peripheral target
        times.postResp_joy_waitTime_ms = 2000;           % Time to get joy back to center
        times.postResp_joy_holdTime_ms = 75;         % Time required to hold center joystick fixation after probe response and before feedback
        % times.beforeFeedback = 200;                   % Time in ms before feedback ring
        % feedbackTime = 300;                   % Time in ms of feedback ring
        % afterFeedback = 200;                   % Time in ms after feedback ring
        % feedback_eyejoy_waitTime = 0;           % waitTime is 0 because eye and joystick are already on central target from prior scene
        % feedback_eyejoy_holdTime = beforeFeedback + feedbackTime + afterFeedback;         % TOTAL FEEDBACK DURATION: Time required to hold eye and joystick fixation at center while feedback ring appears.



    case 'DESKTOP-7CHQEHS'
        % laptop at 120 Hz
        times.stim_frames = 1;
        times.soa_frames = 1;
        times.interPair_frames = 5;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        % times.fixDur_ms = 20;  % fix targ only
        times.preMovie_frames = 20;  % fix targ and choices
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc3_response_ms = 500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;

    case 'MATT_MICRO'
        % laptop at 120 Hz, 8.33 ms per frame
        % durations, frames:ms
        % 2 frames - 17 ms
        % 3 frames - 25 ms
        % 4 frames - 33 ms
        % 5 frames - 42 ms
        % 6 frames - 50 ms
        % 2012 McMahon and Leopold, maximal STDP perceptual shifts with 10
        % ms stimulus duration, and 20 ms SOA, 1 and 3 frames respectively
        % at 120 Hz.
        % Pairing protocol:
        % - 120 trials
        % - Each trial 1 pair of images quickly flashed at screen center
        % - 100 trials of face pairs
        % - 20 trials of nonface pairs
        % - Subjects responded whether face (press) or nonface (withhold)
        % - So they really didn't have movies, one response per pair
        % - one pair every 800-1200 ms.
        % - SOA 10-100 ms
        % - stimulus duration 10 ms
        % - SOA and stimulus order A->B, B->A, held constant in ea sessio

        % --- sc1: preTrial time
        times.sc1_precue_eyejoy_waitTime_ms = 1000;     % Time allowed to acquire eye and joystick fixation
        times.sc1_precue_eyejoy_holdTime_ms = 300;      % Time required to hold center eye and joystick at screen center before cue
        times.sc1_rewBox_ms = 2000;                     % make sure longer than eyejoy_holdTime

        % --- s2: movie
        times.sc2_precue_eyejoy_waitTime_ms = 1000;     % Time allowed to acquire eye and joystick fixation
        times.sc2_precue_eyejoy_holdTime_ms = 300;      % Time required to hold center eye and joystick at screen center before cue
        times.sc2_rewBox_ms = 2000;
        times.sc2_preMovie_frames = 20;  % fix targ and choices
        times.sc2_stim_frames = 4;  % 17 ms
        times.sc2_soa_frames = 4; % 25 ms
        times.sc2_interPair_frames = 30; % 500 ms
        times.sc2_curve_frames = 10; % times for curve stimuli
        times.sc2_postMovie_frames = 20;

        % --- s3: joystick response
        times.joy_waitTime_ms = 3000;
        times.joy_holdTime_ms = 75;
        times.joy_waitTime_ms = 2000;
        times.joy_holdTime_ms = 75;

        % MOVIE DURATION with these parameters
        % Triplet duration (17 + 25 + 17 ms) = 59 ms
        % Triplet + interPair duration = 59 + 100 ms = 159 ms
        % Movie duration (10 pairs) = 1590 ms

        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;




        % stimDur = 2000;                      % Duration stimulus is on the screen in ms
        % afterStim = 100000;                 % Duration of blank screen after stimulus presentation while waiting for joy; should be very long
        times.stim_joy_waitTime_ms = 5000;          % Time allowed to make post-probe response to one of the stim targets (MultiTarget) % was 2000, increased to get rid of speed causing side bias
        times.stim_joy_holdTime_ms = 75;          % Time required to hold chosen peripheral target
        times.postResp_joy_waitTime_ms = 2000;           % Time to get joy back to center
        times.postResp_joy_holdTime_ms = 75;         % Time required to hold center joystick fixation after probe response and before feedback
        % times.beforeFeedback = 200;                   % Time in ms before feedback ring
        % feedbackTime = 300;                   % Time in ms of feedback ring
        % afterFeedback = 200;                   % Time in ms after feedback ring
        % feedback_eyejoy_waitTime = 0;           % waitTime is 0 because eye and joystick are already on central target from prior scene
        % feedback_eyejoy_holdTime = beforeFeedback + feedbackTime + afterFeedback;         % TOTAL FEEDBACK DURATION: Time required to hold eye and joystick fixation at center while feedback ring appears.


    case 'LAPTOP-42DLT8TH'
        % laptop at 120 Hz, 8.33 ms per frame
        % durations, frames:ms
        % 2 frames - 17 ms
        % 3 frames - 25 ms
        % 4 frames - 33 ms
        % 5 frames - 42 ms
        % 6 frames - 50 ms
        % 2012 McMahon and Leopold, maximal STDP perceptual shifts with 10
        % ms stimulus duration, and 20 ms SOA, 1 and 3 frames respectively
        % at 120 Hz.
        % Pairing protocol:
        % - 120 trials
        % - Each trial 1 pair of images quickly flashed at screen center
        % - 100 trials of face pairs
        % - 20 trials of nonface pairs
        % - Subjects responded whether face (press) or nonface (withhold)
        % - So they really didn't have movies, one response per pair
        % - one pair every 800-1200 ms.
        % - SOA 10-100 ms
        % - stimulus duration 10 ms
        % - SOA and stimulus order A->B, B->A, held constant in ea session

        times.stim_frames = 2;  % 17 ms
        times.soa_frames = 3; % 25 ms
        times.interPair_frames = 12; % 100 ms
        % MOVIE DURATION with these parameters
        % Triplet duration (17 + 25 + 17 ms) = 59 ms
        % Triplet + interPair duration = 59 + 100 ms = 159 ms
        % Movie duration (10 pairs) = 1590 ms

        times.preMovie_frames = 20;  % fix targ and choices
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

    case 'DAVIDLAPTOP'
        % laptop at 144 Hz
        times.stim_frames = 3;
        times.soa_frames = 2;
        times.interPair_frames = 12;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        % times.fixDur_ms = 20;  % fix targ only
        times.preMovie_frames = 20;  % fix targ and choices
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

    case '3080Y25-G0Y3FF'
        % augsburg desktop at 60 Hz (copied from DESKTOP-RJQAES2)
        times.stim_frames = 1;
        times.soa_frames = 1;
        times.interPair_frames = 5;

        % times for curve stimuli
        times.curve_frames = 3;

        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        % times.fixDur_ms = 20;  % fix targ only
        times.preMovie_frames = 20;  % fix targ and choices
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

    case 'DESKTOP-RJQAES2'

        % laptop at 120 Hz
        times.stim_frames = 1;
        times.soa_frames = 1;
        times.interPair_frames = 5;

        % times for curve stimuli
        times.curve_frames = 3;

        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        % times.fixDur_ms = 20;  % fix targ only
        times.preMovie_frames = 20;  % fix targ and choices
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;



end

% -------------------------------------------------------------------------
% --------------------------- STATE TIMES ---------------------------------
% -------------------------------------------------------------------------
times.idle_ms = 100;
% times below specified in screen refresh units, absolute time depends on
% graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
% in new laptops, etc
% scene 1 is pretrial

% --- params that control stimulus timing
times.fixDur = 30;  % fix targ only
times.preMovieDur = 30;  % fix targ and choices
times.postMovieDur = 30;
times.sc1_pretrial_frames = 30;
times.sc2_movie_maxFrames = 1000;
times.sc3_feedback_frames = 500; % duration of scene depends on choice ring timing
times.choiceRing_frames = 10;
times.rewRing_frames = 10;               % screen refresh units




end
