function [times] = corr_RL_nhp_setTimes_v1()

% task pace is heavily dependent on refresh rate and hardware
COMPUTER = getenv('COMPUTERNAME');

switch COMPUTER
    case 'MATTWALLIN'
        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 20;
        times.sc3_soa_frames = 10;
        times.sc3_interPair_frames = 20;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;


    case 'DESKTOP-7CHQEHS'
        % HOME OFFICE @ 60 Hz refresh

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 2;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 15;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case 'MATT_MICRO'
        % new Dell laptop @ 120 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 20;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 40;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case 'LAPTOP-42DLT8TH'
        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 2;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 15;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case 'DAVIDLAPTOP'
        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 2;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 15;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case '3080Y25-G0Y3FF'
        % augsburg desktop at 60 Hz (copied from DESKTOP-RJQAES2)
        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 2;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 15;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case 'DESKTOP-RJQAES2'
        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 1000;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 500;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 20;
        times.sc3_stim_frames = 2;
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 15;
        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;

    case 'DESKTOP-RV80PF6'  % lab monkeyLogic computer

        % video runs at 60 Hz

        % --- sc1: preTrial
        times.sc1_preTrial_ms = 500;

        % --- sc2: fix
        times.sc2_fix_eyejoy_waitTime_ms = 1000;
        times.sc2_fix_eyejoy_holdTime_ms = 150;

        % --- sc3: stimulus movie
        times.sc3_movie_eyejoy_waitTime_ms = 1000;
        % holdTime has to be >> movie duration so
        % movie can complete and end scene
        times.sc3_movie_eyejoy_holdTime_ms = 5000;
        times.sc3_preMovie_frames = 10;

        times.sc3_stim_frames = 18; % *** EASY ***
        times.sc3_interPair_frames = 10; % *** EASY ***

        times.sc3_soa_frames = 2;

        times.sc3_curve_frames = 10;
        times.sc3_postMovie_frames = 20;

        % --- sc4: joystick response
        % NOTE: imporatant that joy holdtime is the rate limiting step, that
        % extra time is provided for eye holdtime, as given adaptor chain
        % structure, clocking out on eye holdtime will terminate state
        % before joystick response
        times.sc4_eye_waitTime_ms = 6000;
        times.sc4_eye_holdTime_ms = 6000;
        times.sc4_joy_waitTime_ms = 6000;
        times.sc4_joy_holdTime_ms = 75;

        % --- sc5: feedback
        times.sc5_choiceImg_frames = 10;
        times.sc5_rewImg_frames = 10;
        times.sc5_noRewImg_frames = 10;

        % --- sc6: post trial
        times.sc6_postTrial_short_ms = 500;
        times.sc6_postTrial_long_ms = 2000;




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
times.choiceImg_frames = 10;
times.rewImg_frames = 10;               % screen refresh units




end
