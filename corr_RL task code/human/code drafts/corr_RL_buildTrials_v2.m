function [condArray, params] = corr_RL_buildTrials_v2()

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
% V2 deletes noise pair functionality from V1. Instead, for each movie, we
% will vary correlation strength by omitting one of the two stimuli in each
% pair or replacing it with a mask on a variable subset of movieFrames.
% This will be implemented in generateStimMovie. In addition, we are
% allocating only one stimulus pair per condition and hence per movie.
% Generalization across pairs will occur between trials rather than within
% trials.  This both simplifies the visual information in each movie, and
% also provides behavioral readout as to the degree to which the two pairs
% associated with each state are actually learned to the same or different
% levels.

% -------- SET CONSTANTS
LEFT = 1;
RIGHT = 2;

% -------- SET PARAMS
% set params in a utility function, makes debugging easier as many
% functions can be run independently outside of the ML environment which
% makes debugging easier
params = corr_RL_setParams_v2();

% --- LOOP THROUGH VARIABLES DEFINING TRIAL CONDITIONS
for bn = 1 : params.numBlocks

    % -- 1. select feature combinations of individual stimuli for this block
    % V2 deletes noise pair functionality, will either omit one stimulus of
    % the pair or replace with a mask. So blockStim is cues only
    [blockStim] = corr_RL_sampleStimSpace_v2(params);

    % --- 2. map orthogonal stimulus pairs to LEFT and RIGHT responses
    [cuePairs, noisePairs] = corr_RL_pairStimuli_v2(blockStim);

    % --- 3. select number of cue pairs for this block, and hence degree of
    % visual noise (number of noise pairs) added to the movie
    if params.randCuePercent
        % select random index into the numCuePairs array and retrieve value
        cuePercent = params.cuePercentRange(randi(size(params.cuePercentRange, 2)));
    else
        if mod(bn, 2) == 1 % odd block
            cuePercent = params.cuePercent_easy;
        else  % even block
            cuePercent = params.cuePercent_hard;
        end
    end

    % --- 4. assign each condition, associated with a unique cue movie, to
    % LEFT and RIGHT reward states
    for bc = 1:4  % for block conditions 1 to 4, 1 cue pair per condition
        condArrayTemp(bn, bc).blockNum = bn;
        condArrayTemp(bn, bc).cuePercent = cuePercent;
        % allocate one cue pair to this condition
        condArrayTemp(bn, bc).cuePair = cuePairs(bc);
        % adding these redundant variables to make it easier to see
        % condArray structure in data viewer with clicking down levels of
        % nested structure array
        condArrayTemp(bn, bc).cuePair1_L_ang = cuePairs(bc).leftStim.Angle;
        condArrayTemp(bn, bc).cuePair1_L_color = cuePairs(bc).leftStim.FaceColor;
        condArrayTemp(bn, bc).cuePair1_R_ang = cuePairs(bc).rightStim.Angle;
        condArrayTemp(bn, bc).cuePair1_R_color = cuePairs(bc).rightStim.FaceColor;
        % allocate all noise pairs to each condition
        condArrayTemp(bn, bc).noisePairs = noisePairs;
        condArrayTemp(bn, bc).state = cuePairs(bc).pairState;

    end
end

% Convert conditions matrix into a one dimensional struct array
condArray = [];
condNo = 1;
for b = 1 : params.numBlocks
    for r = 1:4
        thisCond = condArrayTemp(b, r);
        thisCond.condNo = condNo;
        condNo = condNo + 1;
        condArray = [condArray; thisCond];
    end
end

bob = 1;


end


