function [times] = corr_RL_nhp_setTimes_v3()

% task pace is heavily dependent on refresh rate and hardware
COMPUTER = getenv('COMPUTERNAME');

switch COMPUTER
    case 'MATTWALLIN'
        % desktop at 60 Hz, 8.33 ms per frame
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

        % MOVIE DURATION with these parameters
        % Triplet duration (17 + 25 + 17 ms) = 59 ms
        % Triplet + interPair duration = 59 + 100 ms = 159 ms
        % Movie duration (10 pairs) = 1590 ms

        times.sc1_pretrial_ms = 20;
        times.sc2_preMovie_frames = 20;  % fix targ and choices
        times.sc2_stim_frames = 4;  % 17 ms
        times.sc2_soa_frames = 4; % 25 ms
        times.sc2_interPair_frames = 30; % 500 ms
        times.sc2_postMovie_frames = 20;
        
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

        times.curve_frames = 10;


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
        % - SOA and stimulus order A->B, B->A, held constant in ea session

        times.stim_frames = 4;  % 17 ms
        times.soa_frames = 4; % 25 ms
        times.interPair_frames = 30; % 500 ms
        % MOVIE DURATION with these parameters
        % Triplet duration (17 + 25 + 17 ms) = 59 ms
        % Triplet + interPair duration = 59 + 100 ms = 159 ms
        % Movie duration (10 pairs) = 1590 ms

        % times for curve stimuli
        times.curve_frames = 10;
        times.postMovie_frames = 20;
        times.sc1_pretrial_ms = 20;
        times.sc2_preMovie_frames = 20;  % fix targ and choices
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

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
