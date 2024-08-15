function cond_no = xPairs_selectCond_v1(TrialRecord)
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


    switch TrialRecord.User.params.blockChange
        case 'netWinsMode'
            % if block criterion met, i.e. netWins == maxWins, change block
            % by returning cond_no -1
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

        case 'condRepsMode'

            % pick a condition within range for this block at random with reps remaining

            % find reps remaining among the conditions in this block.
            % TrialRecord.User.condRepsRem has length equal to total number of
            % conditions in conditions file.  So index of element (reps remaining)
            % in this array is equal to condition number.
            blockCondRepsRem = TrialRecord.User.condRepsRem(TrialRecord.ConditionsThisBlock);

            % if there are no reps remaining among the conditions of this block,
            % set cond_no to -1 to initiate a new block, otherwise, select a random
            % index from among those with reps remaining
            if sum(blockCondRepsRem) == 0
                cond_no = -1;

                % set within block win/loss counters to 0
                TrialRecord.User.blockWins = 0;
                TrialRecord.User.blockLosses = 0;
                TrialRecord.User.totalWins = 0;

            else
                % find all indices in blockCondRepsRem with nonzero elements
                withRepsLeft = find(blockCondRepsRem);
                % pick an indx among these at random
                rndRepsLeft = withRepsLeft(randi(length(withRepsLeft)));
                % use rand index to select a condition with reps remaining
                cond_no = TrialRecord.ConditionsThisBlock(rndRepsLeft);
            end





    end








end

end




