function changeBlock = xPairs_changeBlock_v1(TrialRecord)
% This function sets flag in TrialRecord controlling whether to switch
% blocks

% DEFAULT BEHAVIOR
changeBlock = false;

% --- If all reps for all conditions in this block are complete, set
% changeBlock to true

if TrialRecord.CurrentTrialNumber > 1  % user defined functions only specified after 1st trial and timing file is run
    % Check whether all reps completed for conditions in this block
    blockCondRepsRem = [];
    for c = 1:size(TrialRecord.ConditionsThisBlock, 2)
        % TrialRecord.User.CondRepRem(c) is a vector of rep counters, one
        % for each condition.  Therefore the condition number is the index into
        % the CondRepRem array
        thisCondNum = TrialRecord.ConditionsThisBlock(c);
        condRepsRem = TrialRecord.User.condRepsRem(thisCondNum);
        blockCondRepsRem = [blockCondRepsRem condRepsRem];
    end

    % if reps remaining is 0 for all conditions within this block increment
    % block number.  Quit if all blocks are done
    if sum(blockCondRepsRem) == 0
        changeBlock = true;
    end

end

end


