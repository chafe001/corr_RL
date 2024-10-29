function cond_no = xPairs_selectCond_v1(TrialRecord)
% Custom code for selecting which conditions to run next from a predefined
% trial stack

% Versions
% v1, adapted from TOPXtrialPicker. 

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
    % pick a condition within range for this block at random with reps remaining
    blockCondRepsRem = [];
    for c = 1:size(TrialRecord.ConditionsThisBlock, 2)
        condRepsRem = TrialRecord.User.condRepsRem(c);
        blockCondRepsRem = [blockCondRepsRem condRepsRem];
    end
    % k = find(X) returns a vector containing the linear indices of each nonzero element in array X.
    repsRemIndx = find(blockCondRepsRem);
    condRepsRem = TrialRecord.ConditionsThisBlock(repsRemIndx);

    if isempty(condRepsRem)
        cond_no = -1;
    else
        rndCondIndx = randi(size(condRepsRem, 2));
        cond_no = condRepsRem(rndCondIndx);
    end

end

end