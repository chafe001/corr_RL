function cond_no = corr_RL_selectCond_v1(TrialRecord)
% Custom code for selecting which conditions to run next from a predefined
% trial stack

% Block changes when function returns -1 per MonkeyLogic control logic

% Want block to change when subject hits netWins criterion (netWins =
% maxWis) criteria.  Here is the line from main task code that counts
% netWins
% TrialRecord.User.netWins = TrialRecord.User.blockWins - TrialRecord.User.blockLosses;

% Specify this function name in ML GUI at runtime
% ML sets TrialRecord.ConditionNumber to the value returned by this fx
% ML calls this fx before every trial, e.g. before code in our task script
% is run for each trial.

% NOTE (important): ML will implement a new block if this function returns (-1)
% This is what advances the program through the block/condition structure
% defined in the conditions file.

% check if this is the first trial, in which case this function is called
% before we save User defined variables to TrialRecord.
if TrialRecord.CurrentTrialNumber == 1
    % pick a random number within condition range for this block
    randindx = randi(size(TrialRecord.ConditionsThisBlock, 2));
    cond_no = TrialRecord.ConditionsThisBlock(randindx);
else
    if TrialRecord.User.netWins == TrialRecord.User.params.netWin_criterion
        cond_no = -1;
        TrialRecord.User.netWins = 0;
        % set within block win/loss counters to 0
        TrialRecord.User.blockWins = 0;
        TrialRecord.User.blockLosses = 0;
        TrialRecord.User.totalWins = 0;
    else
        % select a condition number at random from conditions in
        % this block
        rndCondIndx = randi(length(TrialRecord.ConditionsThisBlock));
        cond_no = TrialRecord.ConditionsThisBlock(rndCondIndx);
    end
end

end




