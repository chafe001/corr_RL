function [times] = corr_RL_setTimes()

% task pace is heavily dependent on refresh rate and hardware
COMPUTER = getenv('COMPUTERNAME');

switch COMPUTER
    case 'MATTWALLIN'
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
        times.sc3_response_ms = 2500;
        times.sc4_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;
        times.scError_ms = 1000;

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
        % laptop at 120 Hz
        times.stim_frames = 2;
        times.soa_frames = 1;
        times.interPair_frames = 10;
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
