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
codes.sc5_joyResp_rewDrop = 40;

codes.abortTrial = 100;

codes.beginRespWin = 40;
codes.joyEnterRespWin = 41;
codes.joyLeft = 42;
codes.joyRight = 43;
codes.retStart = 44;
codes.joyBack = 45;
codes.choiceRing_on = 50;
codes.rewRing_on = 50;
codes.noRewRing_on = 51;
codes.incrementRewBar = 60;
codes.decrementRewBar = 61;
codes.rewDrop1 = 71;
codes.rewDrop2 = 72;
codes.rewDrop3 = 73;
codes.rewDrop4 = 74;
codes.rewDrop5 = 75;
codes.rewDrop6 = 76;
codes.brokeGazeFix = 80;
codes.brokeJoyFix = 81;
codes.neverFix = 83;
codes.noJoy = 84;



end
