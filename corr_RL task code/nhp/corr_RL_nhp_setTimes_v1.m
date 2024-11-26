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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;


    case 'DESKTOP-7CHQEHS'
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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;

    case 'MATT_MICRO'
        % video runs at 120 Hz
        
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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;       % TOTAL FEEDBACK DURATION: Time required to hold eye and joystick fixation at center while feedback ring appears.


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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;

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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;

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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;

    case 'DESKTOP-RJQAES2'

        % laptop at 120 Hz
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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;

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
        times.sc3_stim_frames = 18;  % 2
        times.sc3_soa_frames = 2;
        times.sc3_interPair_frames = 10;  % 15
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
        times.sc5_choiceRing_frames = 10;
        times.sc5_rewRing_frames = 10;




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
