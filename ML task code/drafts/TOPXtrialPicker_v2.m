function cond_num = TOPXtrialPicker_v2(TrialRecord)
% Custom code for selecting which conditions to run next from a predefined
% trial stack

% Versions
% v2, modified to return -1 if no trials left in stack to instruct ML to
% terminate block, and and hopefully quit gracefully
% Specify this function name in ML GUI at runtime
% ML sets TrialRecord.ConditionNumber to the value returned by this fx
% ML calls this fx before every trial, e.g. before code in our task script
% is run for each trial
if TrialRecord.CurrentTrialNumber == 1
    % Hardcoded because on 1st iteration TrialPicker will be called by ML
    % before our task code, so condition number will not be set on first call
    if contains(TrialRecord.DataFile, 'BXonly')   % we skip conditions for this, which messes everything up
        cond_num = 1;   % just make it an AX, which exists, I don't feel like making this code better
    else
        cond_num = randi(36);
    end
elseif ~isempty(TrialRecord.User.trialsLeft) % e.g. there are SOME trials left
    numTrialsLeft = numel(TrialRecord.User.trialsLeft);
    rndIndx = randi(numTrialsLeft);
    cond_num = TrialRecord.User.trialsLeft(rndIndx);
elseif isempty(TrialRecord.User.trialsLeft) % e.g. there are NO trials left
    cond_num = -1; % built in ML termination code (we hope)
end