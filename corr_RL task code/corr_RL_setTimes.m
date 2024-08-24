function [times] = corr_RL_setTimes()

% task pace is heavily dependent on refresh rate and hardware
COMPUTER = getenv('COMPUTERNAME');

switch COMPUTER
    case 'MATTWALLIN'
        % desktop at 60 Hz
        times.idle_ms = 100;
        times.stimDur = 1;
        times.soa = 1;
        times.interPair = 5;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        times.fixDur = 30;  % fix targ only
        times.preMovieDur = 30;  % fix targ and choices
        times.postMovieDur = 30;
        times.sc1_pretrial_frames = 30;
        times.sc2_movie_maxFrames = 1000;
        times.sc3_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;

    case 'DESKTOP-7CHQEHS'
        % desktop at 60 Hz
        times.stimDur = 1;
        times.soa = 1;
        times.interPair = 5;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        times.fixDur = 5;  % fix targ only
        times.preMovieDur = 5;  % fix targ and choices
        times.postMovieDur = 5;
        times.sc1_pretrial_frames = 5;
        times.sc2_movie_maxFrames = 1000;
        times.sc3_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 5;
        times.rewRing_frames = 5;

    case 'MATT_MICRO'
        % laptop at 120 Hz
        times.stimDur = 4;
        times.soa = 4;
        times.interPair = 30;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        times.fixDur = 20;  % fix targ only
        times.preMovieDur = 20;  % fix targ and choices
        times.postMovieDur = 20;
        times.sc1_pretrial_frames = 20;
        times.sc2_movie_maxFrames = 1000;
        times.sc3_feedback_frames = 20; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;

    case 'DAVIDLAPTOP'
        % laptop at 144 Hz
        times.stimDur = 2;
        times.soa = 2;
        times.interPair = 10;
        % times below specified in screen refresh units, absolute time depends on
        % graphics refresh rate, 60 Hz in desktop workstations (typically), 120 Hz
        % in new laptops, etc
        % scene 1 is pretrial
        times.fixDur = 30;  % fix targ only
        times.preMovieDur = 30;  % fix targ and choices
        times.postMovieDur = 30;
        times.sc1_pretrial_frames = 30;
        times.sc2_movie_maxFrames = 1000;
        times.sc3_feedback_frames = 500; % duration of scene depends on choice ring timing
        times.choiceRing_frames = 10;
        times.rewRing_frames = 10;

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
