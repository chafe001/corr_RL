function codes = corr_RL_nhp_setBarCodes_v1()

% -------------------------------------------------------------------------
% --------------------------- EVENT CODES ---------------------------------
% -------------------------------------------------------------------------
% Event codes are time stamps for trial events

codes.fixTargOn = 11;
codes.gazeFixAcq = 12;
codes.joyFixAcq = 13; 
codes.preMovie = 20;
codes.pair_img_on = 21;
codes.left_img_on = 23;
codes.right_img_on = 25;
codes.img_off = 26;
codes.endMovie = 30;
codes.beginRespWindow = 40;
codes.joyOut = 41;
codes.retStart = 42;
codes.joyBack = 43;
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
codes.brokeBothFix = 82;
codes.neverFix = 83;
codes.noJoy = 84;

end
