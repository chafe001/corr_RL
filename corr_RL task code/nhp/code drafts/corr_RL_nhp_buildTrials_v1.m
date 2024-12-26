function [condArray, params] = corr_RL_nhp_buildTrials_v1()

% This utility function builds the condition and condition rep arrays.
% These supercede the conditions .txt file MonkeyLogic normally reads to specify
% experimental conditions to specify stimulus, choice, and reward
% information necessary to generate and run one trial of the task.

% --- VERSION HISTORY

% v1: pairing bars in bars task to keep the individual bars
% shown constant across trials and states, only changing the pairing
% relatinoship (replaces cross-pairs)

% -------- SET CONSTANTS
LEFT = 1;
RIGHT = 2;

% -------- SET PARAMS
params = corr_RL_nhp_setParams_v1();  % setParams_v4 updated for corr_RL v5

switch params.stimulusType

    case 'bars'

        switch params.pairMode

            case 'randList'
                % in randList pairMode, a fixed vector of bars is presented
                % at left and right positions each movie, so that low level
                % (single stimulus) features do not vary either over trials
                % or between states.  Rather, state is indicated by a
                % correlation pattern between left and right images (which
                % stimuli appear together in pairs).  This allows us to
                % vary correlation pattern without varying feature
                % information.

                % If constantPairs, select this once before building blocks
                % and hold pairs constant across all blocks, otherwise, call
                % sampleStimSpace and pairStimuli once at the beginning of
                % each block to create new stimuli to learn
                if params.constantPairs
                    % --- 1. select feature combinations of individual stimuli for this block
                    [blockStim] = corr_RL_nhp_sampleStimSpace_v1(params);  % new for corr_RL v5
                    % --- 2. map unique stimulus pairs to LEFT and RIGHT responses
                    [stateA_pairs, stateB_pairs] = corr_RL_nhp_pairStimuli_v2(blockStim, params); % new for corr_RL v5
                    % --- 3. recolor stateA or stateB pairs if color cue enabled
                    if params.colorCue
                        [stateA_pairs] = recolorStim(stateA_pairs);

                    end
                end

                for bn = 1 : params.numBlocks

                    % -- 1. select feature combinations of individual stimuli for this block
                    if ~params.constantPairs
                        [blockStim] = corr_RL_nhp_sampleStimSpace_v1(params);  % new for corr_RL v5
                        % --- 2. map orthogonal stimulus pairs to LEFT and RIGHT responses
                        [stateA_pairs, stateB_pairs] = corr_RL_nhp_pairStimuli_v2(blockStim, params); % new for corr_RL v5
                    end

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
                        condArrayTemp(bn, rs).state = rs;
                        condArrayTemp(bn, rs).cuePercent = cuePercent;
                        switch rs
                            case LEFT
                                condArrayTemp(bn, rs).cuePairs = stateA_pairs;
                            case RIGHT
                                condArrayTemp(bn, rs).cuePairs = stateB_pairs;
                        end
                    end

                end  % for bn

                % Convert conditions matrix into a one dimensional struct array
                condArray = [];
                condNo = 1;
                for bs = 1 : params.numBlocks
                    for rs = 1 : params.numStates
                        thisCond = condArrayTemp(bs, rs);
                        thisCond.condNo = condNo;
                        condNo = condNo + 1;
                        condArray = [condArray; thisCond];
                    end
                end

                bob = 1;


            case 'xPairs'
                % in xPairs pairMode, program selects 4 bar stimuli and
                % organizes them into 4 orthogonal pairs, mapping 2 pairs
                % to state A, and the remaining 2 pairs to state N.  The
                % objective is that each individual stimulus is associated
                % with states A and B with equal frequency, the state is
                % only indicated by the pair.  This was the first method
                % implemented

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
                        condArrayTemp(bn, rs).state = rs;
                        condArrayTemp(bn, rs).cuePercent = cuePercent;
                        switch rs
                            case LEFT
                                condArrayTemp(bn, rs).cuePairs = [cuePairs(1) cuePairs(4)];
                            case RIGHT
                                condArrayTemp(bn, rs).cuePairs = [cuePairs(2) cuePairs(3)];
                        end
                        condArrayTemp(bn, rs).noisePairs = noisePairs;
                    end

                end  % for bn

                % Convert conditions matrix into a one dimensional struct array
                condArray = [];
                condNo = 1;
                for bs = 1 : params.numBlocks
                    for rs = 1 : params.numStates
                        thisCond = condArrayTemp(bs, rs);
                        thisCond.condNo = condNo;
                        condNo = condNo + 1;
                        condArray = [condArray; thisCond];
                    end
                end

                bob = 2;

        end


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
        params.endcurve_t = curveParams.endcurve_t;
        params.orthocurve_t = curveParams.orthocurve_t;

        for b = 1 : params.numBlocks
            for s = 1 : params.numStates
                for d = 1 : 2  % movie directions, forward and back

                    condArrayTemp(b, s, d).blockNum = b;
                    condArrayTemp(b, s, d).state = s;
                    condArrayTemp(b, s, d).curveMovieDir = d;

                    % --- SET BLOCK-LEVEL VARIABLES to control curve movies
                    % keeping switches from prior version. To lock these
                    % variables at a desired value, set to SAME VALUE for
                    % both even and odd blocks below
                    if mod(b, 2) ~= 0 % odd block
                        condArrayTemp(b, s, d).snr = 1;
                        condArrayTemp(b, s, d).curveMovieOrientation = 'horizontal';
                        condArrayTemp(b, s, d).curveMovieType = 'smooth';
                    else  % even block
                        condArrayTemp(b, s, d).snr = 2;
                        condArrayTemp(b, s, d).curveMovieOrientation = 'horizontal';
                        condArrayTemp(b, s, d).curveMovieType = 'smooth';
                    end

                end
            end % for s
        end % for b

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

end

bob = 3;


end

% --- UTILITY FUNCTIONS

function [outPairs] = recolorStim(inPairs)
% provide color cue for stateA (left resp) and stateB (right resp) pairs

% suffix = '100.png';
% suffix = '100_dim_150.png';
% suffix = '100_dim_125.png';
suffix = '100_dim_100.png';
% suffix = '100_dim_50.png';

% initialize outpairs to inpairs
outPairs = inPairs;

% change stimulus color for outpairs
for p = 1 : size(outPairs, 2)

    % overwrite filename for LEFT stim of pair with new color
    oldLeftFN = inPairs(p).leftStim.FileName;
    indx = strfind(oldLeftFN, 'rgb_') + 3;
    newLeftFN = strcat(oldLeftFN(1:indx), suffix);
    outPairs(p).leftStim.FileName = newLeftFN;

    % overwrite filename for RIGHT stim of pair with new color
    oldRightFN = inPairs(p).rightStim.FileName;
    indx = strfind(oldRightFN, 'rgb_') + 3;
    newRightFN = strcat(oldRightFN(1:indx), suffix);
    outPairs(p).rightStim.FileName = newRightFN;

end


end

