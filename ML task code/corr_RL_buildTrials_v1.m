function [condArray, params] = corr_RL_buildTrials_v1()

% This utility function builds the condition and condition rep arrays.
% These supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions to specify stimulus, choice, and reward
% information necessary to generate and run one trial of the task.

% --- VERSION HISTORY

% V1 derived from xPairs_buildTrials.  Extending to multidimensional
% feature spaces including dimensions other than spatial location to define
% stimuli in the task.  Incorporating Thomas' manifold idea.  Stimuli will
% have orientation, color, location. Categories corresponding to reward
% states will be random subspaces defined by ranges of feature
% combinations.  Maintaining xPairs design so features in pairs of stimuli
% instruct state.

% -------- SET CONSTANTS
LEFT = 1;
RIGHT = 2;

% -------- SET PARAMS
% set params in a utility function, makes debugging easier as many
% functions can be run independently outside of the ML environment which
% makes debugging easier
params = setParams();

% --- LOOP THROUGH VARIABLES DEFINING TRIAL CONDITIONS
for bn = 1 : params.numBlocks

    % -- 1. select feature combinations of individual stimuli for this block
    [blockStim] = corr_RL_sampleStimSpace_v1(params);

    % --- 2. map orthogonal stimulus pairs to LEFT and RIGHT responses
    [cuePairs_leftResp, cuePairs_rightResp, noisePairs] = corr_RL_pairStimuli_v1(blockStim, params);

    % --- 3. select number of cue pairs for this block, and hence degree of
    % visual noise (number of noise pairs) added to the movie
    if params.randCuePairNum
        % select random index into the numCuePairs array and retrieve value
        numCuePairs = params.numCuePairs(randi(size(params.numCuePairs, 2)));
    else
        if mod(bn, 2) == 1 % odd block
            numCuePairs = params.numCuePairs_easy;
        else  % even block
            numCuePairs = params.numCuePairs_hard;
        end
    end

    for rs = LEFT:RIGHT
        condArrayTemp(bn, rs).blockNum = bn;
        condArrayTemp(bn, rs).rewSide = rs;
        condArrayTemp(bn, rs).numCuePairs = numCuePairs;
        switch rs
            case LEFT
                condArrayTemp(bn, rs).cuePairs = cuePairs_rightResp;
            case RIGHT
                condArrayTemp(bn, rs).cuePairs = cuePairs_leftResp;
        end
        condArrayTemp(bn, rs).noisePairs = noisePairs;
    end

end

% Convert conditions matrix into a one dimensional struct array
condArray = [];
condNo = 1;
for b = 1 : params.numBlocks
    for r = LEFT:RIGHT
        thisCond = condArrayTemp(b, r);
        thisCond.condNo = condNo;
        condNo = condNo + 1;
        condArray = [condArray; thisCond];
    end
end

bob = 1;


end


