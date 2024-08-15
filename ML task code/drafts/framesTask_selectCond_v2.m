function cond_no = HebbRL_selectCond_v2(TrialRecord)
% Custom code for selecting which conditions to run next from a predefined
% trial stack

% Versions
% v1: adapted from TOPXtrialPicker. 
% v2: trying to fix ML problem by which returning -1 as instructed by the
% documentation when all reps in this block are done and the block should
% change actually crashes ML.  Attempted to debug TrialRecord structure but
% no luck.  Attempting to write a block change function to circumvent the
% problem.  In this version the condition number will never be -1 (which is
% what is causing the crash).

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
    % Check whether all reps completed for conditions in this block
    blockCondRepsRem = [];
    for c = 1:size(TrialRecord.ConditionsThisBlock, 2)
        % TrialRecord.User.CondRepRem(c) is a vector of rep counters, one
        % for each condition (4 conditions per block, to specify crossed
        % A/B stimulus pairing).  Therefore the condition number is the index into
        % the CondRepRem array
        thisCondNum = TrialRecord.ConditionsThisBlock(c);
        condRepsRem = TrialRecord.User.condRepsRem(thisCondNum);
        blockCondRepsRem = [blockCondRepsRem condRepsRem];
    end

    % k = find(X) returns a vector containing the linear indices of each nonzero element in array X.
    repsRemIndx = find(blockCondRepsRem);
    condRepsRem = TrialRecord.ConditionsThisBlock(repsRemIndx);

    if ~isempty(condRepsRem)
        rndCondIndx = randi(size(condRepsRem, 2));
        cond_no = condRepsRem(rndCondIndx);
    else
        cond_no = 1;
    end
end

end