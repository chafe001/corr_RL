function [movieFrames, pairSeq] = corr_RL_generateStimMovie_v2_mockup()
% This function returns a cell array, movieImages, that is used to set the
% 'List' property of a imageChanger() object.  This controls the sequence
% of images presented in the movie, which controls the proportion of cue
% and noise pairs included in each movie.

% VERSION NOTES:
% v1 - first effort for corr_RL
% v2 - after dropping noise pairs, generateStimMovie will implement
% variable stimulus correlation by omitting single stimuli from a subset of
% pairs. Goal if for number of times each stimulus in the pair is shown to
% remain fixed in each movie, what will vary is the number of times the two
% are shown together, in fixed order, in STDP window.  Movies will not vary
% in terms of which stimuli are shown or how many times they are shown.
% They will vary only in correlation between the two stimuli in the pair.

% if real fx, uncomment the following three lines
% condArray = TrialRecord.User.condArray;
% c = TrialRecord.CurrentCondition;
% params = corr_RL_setParams_v2();

% if mockup, uncomment the following two lines
[condArray, params] = corr_RL_buildTrials_v2();
c = 4;


times = corr_RL_setTimes();
codes = corr_RL_setCodes();

% --- define mask stimuli
leftMask.EdgeColor = NaN;
leftMask.FaceColor = NaN;
leftMask.Size = NaN;
leftMask.Position = params.leftPos;
leftMask.Angle = NaN;
leftMask.FileName = 'mask.png';

rightMask.EdgeColor = NaN;
rightMask.FaceColor = NaN;
rightMask.Size = NaN;
rightMask.Position = params.rightPos;
rightMask.Angle = NaN;
rightMask.FileName = 'mask.png';

switch params.noiseMode

    case 'singleton'
        % --- compute number of cue stimulus pairs to display
        pairReps = round(condArray(c).cuePercent * params.movieStimReps);

        % --- compute number of cue stimulus singletons to display
        singletonReps = params.movieStimReps - pairReps;

        % --- build pairSeq vector determinining for each movie pair slot to
        % show both stimuli (1), omit the left stimulus (2), omit the right
        % stimulus (3), or omit both stimuli (4).

        % --- frame triplets showing both stimuli in the pair
        bothStim = ones(1, pairReps);

        % --- frame triplets showing only the left stimulus
        leftStim = ones(1, singletonReps) + 1;

        % --- frame triplets showing only the right stimulus
        rightStim = ones(1, singletonReps) + 2;

        % --- numMoviePairs is total number of frame triplets in movie,
        % computed the remaining number of triplets in which to show
        % neither stimulus
        neitherStim = ones(1, params.moviePairSlots - (pairReps + (2 * singletonReps))) + 3;

        % --- concatenate vectors
        pairSeq = [bothStim leftStim rightStim neitherStim];

        % --- randomize order of pairSeq
        pairSeq = pairSeq(randperm(length(pairSeq)));

        % --- assign stimuli to pairs
        for p = 1 : length(pairSeq)

            switch pairSeq(p)
                case 1 % show both stimuli
                    pairs(p).pairID = condArray(c).cuePair.pairID;
                    pairs(p).leftStim = condArray(c).cuePair.leftStim;
                    pairs(p).rightStim = condArray(c).cuePair.rightStim;

                case 2 % show left stimulus
                    pairs(p).pairID = condArray(c).cuePair.pairID;
                    pairs(p).leftStim = condArray(c).cuePair.leftStim;
                    pairs(p).rightStim = rightMask;


                case 3 % show right stimulus
                    pairs(p).pairID = condArray(c).cuePair.pairID;
                    pairs(p).leftStim = leftMask;
                    pairs(p).rightStim = condArray(c).cuePair.rightStim;

                case 4 % show neither stimulus
                    pairs(p).pairID = condArray(c).cuePair.pairID;
                    pairs(p).leftStim = leftMask;
                    pairs(p).rightStim = rightMask;
            end

        end % next p

    case 'invertedPairs'
        % --- compute number of cue stimulus pairs to display
        pairReps = round(condArray(c).cuePercent * params.moviePairSlots);

        % --- compute noise reps
        noiseReps = params.moviePairSlots - pairReps;

        % --- build pairSeq vector determinining for each movie pair slot to
        % show true cue stimuli (1), or inverted noise pair 1 (11), 2
        % (12), 3 (13) or 4 (14) at random.  Four noise pairs are defined
        % for each block and allocated to each condition.  Select from the
        % 4 noise pairs at random to ensure no relation to state over
        % trials.

        truePairs = ones(1, pairReps);
        repsRemaining = params.moviePairSlots - pairReps;
        noisePairs = [];
        while repsRemaining
            thisNoise = 10 + randi(4); % select one of 4 noise stim at random
            noisePairs = [noisePairs thisNoise];
            repsRemaining = repsRemaining - 1;
        end

        % --- concatenate vectors
        pairSeq = [truePairs noisePairs];

        % --- randomize order of pairSeq
        pairSeq = pairSeq(randperm(length(pairSeq)));


        % --- assign stimuli to pairs
        for p = 1 : length(pairSeq)

            switch pairSeq(p)

                case 1
                    pairs(p).pairID = condArray(c).cuePair.pairID;
                    pairs(p).leftStim = condArray(c).cuePair.leftStim;
                    pairs(p).rightStim = condArray(c).cuePair.rightStim;

                case 11  % noise pair 1
                    pairs(p).pairID = condArray(c).noisePairs(1).pairID;
                    pairs(p).leftStim = condArray(c).noisePairs(1).leftStim;
                    pairs(p).rightStim = condArray(c).noisePairs(1).rightStim;

                case 12  % noise pair 2
                    pairs(p).pairID = condArray(c).noisePairs(2).pairID;
                    pairs(p).leftStim = condArray(c).noisePairs(2).leftStim;
                    pairs(p).rightStim = condArray(c).noisePairs(2).rightStim;


                case 13  % noise pair 3
                    pairs(p).pairID = condArray(c).noisePairs(3).pairID;
                    pairs(p).leftStim = condArray(c).noisePairs(3).leftStim;
                    pairs(p).rightStim = condArray(c).noisePairs(3).rightStim;


                case 14  % noise pair 4
                    pairs(p).pairID = condArray(c).noisePairs(4).pairID;
                    pairs(p).leftStim = condArray(c).noisePairs(4).leftStim;
                    pairs(p).rightStim = condArray(c).noisePairs(4).rightStim;

            end

        end

    otherwise
        error('unknown noise type, generateStimMovie');

end

% --- DEFINE STANDARD IMAGES
preMovie = {[], [], times.preMovie_frames, codes.preMovie};
soa = {[], [], times.soa_frames, codes.img1_off};
interPair = {[], [], times.interPair_frames, codes.imgPair_off};

preMovie_mask = {{'mask.png', 'mask.png'}, [params.leftPos(1), params.leftPos(2); params.rightPos(1), params.rightPos(2)], times.preMovie_frames, codes.preMovie};
soa_mask = {{'mask.png', 'mask.png'}, [params.leftPos(1), params.leftPos(2); params.rightPos(1), params.rightPos(2)], times.soa_frames, codes.img1_off};
interPair_mask = {{'mask.png', 'mask.png'}, [params.leftPos(1), params.leftPos(2); params.rightPos(1), params.rightPos(2)], times.interPair_frames, codes.imgPair_off};

params.leftPos = [-4 0];
params.rightPos = [4 0];

% --- SET STIM PARAMS FOR imageChanger FUNCTION CALL TO CONTROL MOVIE
% FROM ML DOCUMENTATION on imageChanger
% Input Properties:
% List: An n-by-3 or n-by-4 or n-by-5 cell matrix
% 1st column: Image filename(s) or function string(s) (see Remarks)
% 2nd column: Image XY position(s) in visual angles, an n-by-2 matrix ([x1 y1; x2 y2; ...])
% 3rd column: Duration in number of frames (or in milliseconds. See the DurationUnit property below.)
% 4th column: Eventmarker(s); optional
% 5th column: Resize parameter, [Xsize Ysize] in pixels; optional
% create structure from which array will be made

% --- init frame variables
pairFrames = {};
thisFrame = {};
movieFrame = {};

% --- SET FIRST FRAME (irrespective of movieMode)
pairFrames{1} = preMovie_mask;

for p = 1 : length(pairs)

    % --- define left stimulus frame
    leftStim_fn = pairs(p).leftStim.FileName;
    leftStim_x = params.params.leftPos(1);
    leftStim_y = params.params.leftPos(2);
    leftStim = {leftStim_fn, [leftStim_x leftStim_y], times.stim_frames, codes.img1_on};

    % --- define right stimulus frame
    rightStim_fn = pairs(p).rightStim.FileName;
    rightStim_x = params.params.rightPos(1);
    rightStim_y = params.params.rightPos(2);
    rightStim = {rightStim_fn, [rightStim_x rightStim_y], times.stim_frames, codes.img2_on};

    % --- compute frame index counter based on 4 frames per pair
    frameIndx = ((p - 1) * 4) + 2;

    % --- combine with soa and interpair frames
    pairFrames{frameIndx} = leftStim;
    pairFrames{frameIndx + 1} = soa_mask;
    pairFrames{frameIndx + 2} = rightStim;
    pairFrames{frameIndx + 3} = interPair_mask;

end  % next p

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieImages
movieFrames = {};
for f = 1 : size(pairFrames, 2)
    thisFrame = pairFrames{1, f};
    movieFrames = [movieFrames; thisFrame];
end


bob = 'finished';


end


