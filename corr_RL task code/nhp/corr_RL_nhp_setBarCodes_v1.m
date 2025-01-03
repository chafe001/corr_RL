function codes = corr_RL_nhp_setBarCodes_v1()

% -------------------------------------------------------------------------
% --------------------------- EVENT CODES ---------------------------------
% -------------------------------------------------------------------------
% Event codes are time stamps for trial events

codes.sc1_preTrialStart = 10;
codes.sc2_fixTargOn = 11;
codes.sc2_gazeFixAcq = 12;
codes.sc2_joyFixAcq = 13; 
codes.sc3_movieStart = 20;
codes.sc3_movFr_preMovie = 21;
codes.sc3_movFr_pairOn = 22;
codes.sc3_movFr_leftOn = 23;
codes.sc3_movFr_rightOn = 24;
codes.sc3_movFr_soa = 25;
codes.sc3_movFr_interPair = 26;
codes.sc3_movFr_singletonOff = 27;
codes.sc4_joyResp_openWindows = 30;
codes.sc4_joyResp_enterWindow = 31;
codes.sc4_joyResp_moveLeft = 32;
codes.sc4_joyResp_moveRight = 33;
codes.sc5_joyResp_correctChoice = 34;
codes.sc5_joyResp_incorrectChoice = 35;
codes.sc5_joyResp_probRew = 36;
codes.sc5_joyResp_probNoRew = 37;
codes.sc5_joyResp_rewDrop = 38;
codes.sc5_joyResp_choiceImgOn = 40;
codes.sc5_joyResp_rewImgOn = 41;
codes.sc5_joyResp_noRewImgOn = 42;
codes.sc6_postTrial = 43;
% error codes
codes.neverFix = 50;
codes.brokeGazeFix = 51;
codes.brokeJoyFix = 52;
codes.noResp = 53;
codes.abortTrial = 100;


end
