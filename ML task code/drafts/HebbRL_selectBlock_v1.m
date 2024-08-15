function block_no = HebbRL_selectBlock_v1(TrialRecord, MLconfig)
% This function controls which block of trials to execute
% It is called if TrialRecord.BlockChange is set to true by
% HebbRL_changeBlock()

% NOTE:  BLOCK SELECTION FX IS CALLED BEFORE CONDITION SELECTION FX at the start
% of each trial during MonkeyLogic execution

if TrialRecord.CurrentTrialNumber > 1  % user defined functions only specified after 1st trial and timing file is run
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
    
    % if reps remaining is 0 for all conditions within this block increment
    % block number.  Quit if all blocks are done
    if sum(blockCondRepsRem) == 0
        if TrialRecord.CurrentBlock == MLconfig.BlocksToRun(end) % e.g. last block
            block_no = -1;  % end task 
        else
            block_no = TrialRecord.CurrentBlock + 1;
        end
    end

end


