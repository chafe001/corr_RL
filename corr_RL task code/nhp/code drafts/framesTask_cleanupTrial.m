function [] = HebbRL_cleanupTrial(inState, TrialRecord)

switch inState

    case 'sc1'

        bhv_variable(...
            'cuePos', cuePos, ...
            'probePos', probePos, ...
            'cueID', cueID, ...
            'cueStr', cueStr, ...
            'cueFileName', cue_pic, ...
            'probeID', probeID, ...
            'probeStr', probeStr, ...
            'probeFileName', probe_pic, ...
            'trialID', trialTypeID, ...
            'chosenTarget', nan, ...
            'trialResult', trialResult, ...
            'resultScene', resultScene, ...
            'isiTime', isiTime, ...
            'itiTime', itiTime, ...
            'probeRespRT', nan, ...
            'probeReturnRT', nan, ...
            'probeRespChoice', nan, ...
            'probeRespCompleted', probeRespCompleted, ...
            'trialSet', trialSet, ...
            'numConds', TrialRecord.User.numConds, ...
            'condAra', TrialRecord.User.condAra, ...
            'condAraLabel', TrialRecord.User.condAraLabel, ...
            'masterTrialAra', TrialRecord.User.masterTrialAra, ...
            'trialsLeft', TrialRecord.User.trialsLeft);

    case 'sc2'

        bhv_variable(...
            'cuePos', cuePos, ...
            'probePos', probePos, ...
            'cueID', cueID, ...
            'cueStr', cueStr, ...
            'cueFileName', cue_pic, ...
            'probeID', probeID, ...
            'probeStr', probeStr, ...
            'probeFileName', probe_pic, ...
            'trialID', trialTypeID, ...
            'chosenTarget', nan, ...
            'trialResult', trialResult, ...
            'resultScene', resultScene, ...
            'isiTime', isiTime, ...
            'itiTime', itiTime, ...
            'probeRespRT', nan, ...
            'probeReturnRT', nan, ...
            'probeRespChoice', nan, ...
            'probeRespCompleted', probeRespCompleted, ...
            'trialSet', trialSet, ...
            'numConds', TrialRecord.User.numConds, ...
            'condAra', TrialRecord.User.condAra, ...
            'condAraLabel', TrialRecord.User.condAraLabel, ...
            'masterTrialAra', TrialRecord.User.masterTrialAra, ...
            'trialsLeft', TrialRecord.User.trialsLeft);
    case 'sc3'

        bhv_variable(...
            'cuePos', cuePos, ...
            'probePos', probePos, ...
            'cueID', cueID, ...
            'cueStr', cueStr, ...
            'cueFileName', cue_pic, ...
            'probeID', probeID, ...
            'probeStr', probeStr, ...
            'probeFileName', probe_pic, ...
            'trialID', trialTypeID, ...
            'chosenTarget', nan, ...
            'trialResult', trialResult, ...
            'resultScene', resultScene, ...
            'isiTime', isiTime, ...
            'itiTime', itiTime, ...
            'probeRespRT', nan, ...
            'probeReturnRT', nan, ...
            'probeRespChoice', nan, ...
            'probeRespCompleted', probeRespCompleted, ...
            'trialSet', trialSet, ...
            'numConds', TrialRecord.User.numConds, ...
            'condAra', TrialRecord.User.condAra, ...
            'condAraLabel', TrialRecord.User.condAraLabel, ...
            'masterTrialAra', TrialRecord.User.masterTrialAra, ...
            'trialsLeft', TrialRecord.User.trialsLeft);


    case 'sc4'
        % --- SAVE USER VARS
        bhv_variable(...
            'cuePos', cuePos, ...
            'probePos', probePos, ...
            'cueID', cueID, ...
            'cueStr', cueStr, ...
            'cueFileName', cue_pic, ...
            'probeID', probeID, ...
            'probeStr', probeStr, ...
            'probeFileName', probe_pic, ...
            'trialID', trialTypeID, ...
            'chosenTarget', nan, ...
            'trialResult', trialResult, ...
            'resultScene', resultScene, ...
            'isiTime', isiTime, ...
            'itiTime', itiTime, ...
            'probeRespRT', nan, ...
            'probeReturnRT', nan, ...
            'probeRespChoice', nan, ...
            'probeRespCompleted', probeRespCompleted, ...
            'trialSet', trialSet, ...
            'numConds', TrialRecord.User.numConds, ...
            'condAra', TrialRecord.User.condAra, ...
            'condAraLabel', TrialRecord.User.condAraLabel, ...
            'masterTrialAra', TrialRecord.User.masterTrialAra, ...
            'trialsLeft', TrialRecord.User.trialsLeft);



    case 'sc5'
        bhv_variable(...
            'cuePos', cuePos, ...
            'probePos', probePos, ...
            'cueID', cueID, ...
            'cueStr', cueStr, ...
            'cueFileName', cue_pic, ...
            'probeID', probeID, ...
            'probeStr', probeStr, ...
            'probeFileName', probe_pic, ...
            'trialID', trialTypeID, ...
            'chosenTarget', sc4_mTarg_joy.ChosenTarget, ...
            'TrialRecord.User.trialResult', TrialRecord.User.trialResult, ...
            'TrialRecord.User.resultScene', TrialRecord.User.resultScene, ...
            'isiTime', isiTime, ...
            'itiTime', itiTime, ...
            'probeRespRT', probeRespRT, ...
            'probeReturnRT', probeReturnRT, ...
            'probeRespChoice', probeRespChoice, ...
            'probeRespCompleted', probeRespCompleted, ...
            'trialSet', trialSet, ...
            'numConds', TrialRecord.User.numConds, ...
            'condAra', TrialRecord.User.condAra, ...
            'condAraLabel', TrialRecord.User.condAraLabel, ...
            'masterTrialAra', TrialRecord.User.masterTrialAra, ...
            'trialsLeft', TrialRecord.User.trialsLeft);

    case 'sc6'

    otherwise
        error('bad state in cleanupTrial');


end
