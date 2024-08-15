function cond_num = HebbRL_trialPicker_v1(TrialRecord)
% Custom code for selecting which conditions to run next from a predefined
% trial stack

% Versions
% v1, adapted from TOPXtrialPicker. 

% Specify this function name in ML GUI at runtime
% ML sets TrialRecord.ConditionNumber to the value returned by this fx
% ML calls this fx before every trial, e.g. before code in our task script
% is run for each trial

% HebbRL is based on a block structure with new stimuli and varying
% associative strength over blocks.  Each block is associated with a
% different set of condition numbers specifying the stimuli in the block.

thisBlock = TrialRecord.CurrentBlock;
thisBlockConds = TrialRecord.ConditionsThisBlock;

% check if this is the first trial, in which case this function is called
% before we save User defined variables to TrialRecord.
if TrialRecord.CurrentTrialNumber == 1
    % pick a random number within condition range for this block
    randindx = randi(size(thisBlockConds, 2));
    cond_num = thisBlockConds(randindx);
else
    % pick a condition within range for this block at random with reps remaining
    repsLeft = [];
    for c = 1:size(thisBlockConds, 2)
        thisCond = thisBlockConds(c);
        thisCondRepsLeft = TrialRecord.User.trialsLeft(thisBlock,thisCond).condReps;
        repsLeft = [repsLeft thisCondRepsLeft];
    end
    condsWithRepsLeft = find(repsLeft);

    if isempty(condsWithRepsLeft)
        cond_num = -1;
    else
        rndCondIndx = randi(size(condsWithRepsLeft, 2));
        cond_num = condsWithRepsLeft(rndCondIndx);
    end

end







% Versions
% v2, modified to return -1 if no trials left in stack to instruct ML to
% terminate block, and and hopefully quit gracefully
% Specify this function name in ML GUI at runtime
% ML sets TrialRecord.ConditionNumber to the value returned by this fx
% ML calls this fx before every trial, e.g. before code in our task script
% is run for each trial
% if TrialRecord.CurrentTrialNumber == 1
%     % Hardcoded because on 1st iteration TrialPicker will be called by ML
%     % before our task code, so condition number will not be set on first call
%     if contains(TrialRecord.DataFile, 'BXonly')   % we skip conditions for this, which messes everything up
%         cond_num = 1;   % just make it an AX, which exists, I don't feel like making this code better
%     else
%         cond_num = randi(36);
%     end
% elseif ~isempty(TrialRecord.User.trialsLeft) % e.g. there are SOME trials left
%     numTrialsLeft = numel(TrialRecord.User.trialsLeft);
%     rndIndx = randi(numTrialsLeft);
%     cond_num = TrialRecord.User.trialsLeft(rndIndx);
% elseif isempty(TrialRecord.User.trialsLeft) % e.g. there are NO trials left
%     cond_num = -1; % built in ML termination code (we hope)
% end



end