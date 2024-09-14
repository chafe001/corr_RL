function [condArray, params] = corr_RL_buildTrials_v3()

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

% v2: implemented one pair per movie, new noise methods.  Bypassing this
% branch for future iterations

% v3: integrating original xPairs design and curves generated by Dave's
% code according to Thomas' algorithm.  Retaining V1 functionality so can
% switch between the two stimulus types (bars and curves).

% -------- SET CONSTANTS
LEFT = 1;
RIGHT = 2;

% -------- SET PARAMS
params = corr_RL_setParams_v3();

switch params.stimulusType

    case 'bars'
        % --- LOOP THROUGH VARIABLES DEFINING TRIAL CONDITIONS
        for bn = 1 : params.numBlocks

            % -- 1. select feature combinations of individual stimuli for this block
            [blockStim] = corr_RL_sampleStimSpace_v1(params);

            % --- 2. map orthogonal stimulus pairs to LEFT and RIGHT responses
            [cuePairs, noisePairs] = corr_RL_pairStimuli_v1(blockStim);

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
            for rs = LEFT:RIGHT
                condArrayTemp(bn, rs).blockNum = bn;
                condArrayTemp(bn, rs).movieRewState = rs;
                condArrayTemp(bn, rs).cuePercent = cuePercent;
                switch rs
                    case LEFT
                        condArrayTemp(bn, rs).cuePairs = [cuePairs(1) cuePairs(4)];
                    case RIGHT
                        condArrayTemp(bn, rs).cuePairs = [cuePairs(2) cuePairs(3)];
                end
                condArrayTemp(bn, rs).noisePairs = noisePairs;
            end

        end


        bob = 1;


    case 'curves'

        % --- open curveParams file specifying how curves were generated,
        % this has blockNum and state information also
        cd blockstim
        load('curveParams.mat');
        cd ..

        % --- update params with curveParams info, OK to do here because
        % buildTrials will return the updated params
        params.numBlocks = curveParams.nBlocks;
        params.numStates = curveParams.nStates;
        params.n_tvals_main = curveParams.n_tvals_main;
        params.n_tvals_ortho = curveParams.n_tvals_ortho;
        params.size_of_knot_grid = curveParams.size_of_knot_grid;
        params.low = curveParams.low;
        params.high = curveParams.high;
        params.max_knot_number = curveParams.max_knot_number;
        params.D = curveParams.D;
        params.K = curveParams.K;
        params.n_knot_points = curveParams.n_knot_points;
        params.encurve_t = curveParams.encurve_t;
        params.orthocurve_t = curveParams.orthocurve_t;

        for b = 1 : params.numBlocks
            for s = 1 : params.numStates
                for d = 1 : 2  % movie directions, forward and back
                    condArrayTemp(b, s, d).blockNum = b;
                    condArrayTemp(b, s, d).state = s;
                    condArrayTemp(b, s, d).curveMovieDir = d;

                    % vary movie params by block to see which if
                    % any influence learning
                    if mod(b, 2) == 1 % odd block
                        condArrayTemp(b, s, d).curveMovieType = 'smooth';
                        condArrayTemp(b, s, d).curveMovieNoise = 'low';
                        condArrayTemp(b, s, d).curveMovieOrder = 'forward';
                        condArrayTemp(b, s, d).curveMovieGeometry = 'oneD';
                    else  % even block
                        condArrayTemp(b, s, d).curveMovieType = 'rough';
                        condArrayTemp(b, s, d).curveMovieNoise = 'high';
                        condArrayTemp(b, s, d).curveMovieOrder = 'forward_reverse';
                        condArrayTemp(b, s, d).curveMovieGeometry = 'twoD';
                    end

                end
            end % for s
        end % for b

        bob = 2;


end

% Convert conditions matrix into a one dimensional struct array
condArray = [];
condNo = 1;
for b = 1 : params.numBlocks
    for s = 1 : params.numStates
        for d = 1 : 2
            thisCond = condArrayTemp(b, s, d);
            thisCond.condNo = condNo;
            condNo = condNo + 1;
            condArray = [condArray; thisCond];
        end
    end
end


bob = 3;


end


