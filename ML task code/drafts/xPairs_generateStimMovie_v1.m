function [movieFrames] = xPairs_generateStimMovie_v1(TrialRecord)

% This function builds a cell array that specifies all stimulus identity,
% location and timing information for the stimulus movie.  Each row
% corresponds to the information needed to specify one image frame in
% imageChanger.  The cell array is passed as an argument to imageChanger to
% build the movie.

% --- RETRIEVE CURRENT CONDITION NUMBER (from TrialRecord)
c = TrialRecord.CurrentCondition;

% --- RETRIEVE PARAMS (from TrialRecord Condition Array)
params = TrialRecord.User.params;

% --- RETRIEVE STIM PAIR IMGFILES AND XY (from TrialRecord Condition Array)
stim1_fn = TrialRecord.User.condArray(c).stim1_fn;
stim1_x = TrialRecord.User.condArray(c).stim1.x;
stim1_y = TrialRecord.User.condArray(c).stim1.y;
stim2_fn = TrialRecord.User.condArray(c).stim2_fn;
stim2_x = TrialRecord.User.condArray(c).stim2.x;
stim2_y = TrialRecord.User.condArray(c).stim2.y;

% --- RETRIEVE NOISE PAIR1 IMGFILES AND XY
noisePair1_noise1_fn = TrialRecord.User.condArray(c).noisePairs(1).noise1_fn;
noisePair1_noise1_x = TrialRecord.User.condArray(c).noisePairs(1).noise1.x;
noisePair1_noise1_y = TrialRecord.User.condArray(c).noisePairs(1).noise1.y;
noisePair1_noise2_fn = TrialRecord.User.condArray(c).noisePairs(1).noise2_fn;
noisePair1_noise2_x = TrialRecord.User.condArray(c).noisePairs(1).noise2.x;
noisePair1_noise2_y = TrialRecord.User.condArray(c).noisePairs(1).noise2.y;

% --- RETRIEVE NOISE PAIR2 IMGFILES AND XY 
noisePair2_noise1_fn = TrialRecord.User.condArray(c).noisePairs(2).noise1_fn;
noisePair2_noise1_x = TrialRecord.User.condArray(c).noisePairs(2).noise1.x;
noisePair2_noise1_y = TrialRecord.User.condArray(c).noisePairs(2).noise1.y;
noisePair2_noise2_fn = TrialRecord.User.condArray(c).noisePairs(2).noise2_fn;
noisePair2_noise2_x = TrialRecord.User.condArray(c).noisePairs(2).noise2.x;
noisePair2_noise2_y = TrialRecord.User.condArray(c).noisePairs(2).noise2.y;

% --- RETRIEVE NOISE PAIR3 IMGFILES AND XY
noisePair3_noise1_fn = TrialRecord.User.condArray(c).noisePairs(3).noise1_fn;
noisePair3_noise1_x = TrialRecord.User.condArray(c).noisePairs(3).noise1.x;
noisePair3_noise1_y = TrialRecord.User.condArray(c).noisePairs(3).noise1.y;
noisePair3_noise2_fn = TrialRecord.User.condArray(c).noisePairs(3).noise2_fn;
noisePair3_noise2_x = TrialRecord.User.condArray(c).noisePairs(3).noise2.x;
noisePair3_noise2_y = TrialRecord.User.condArray(c).noisePairs(3).noise2.y;

% --- RETRIEVE NOISE PAIR4 IMGFILES AND XY
noisePair4_noise1_fn = TrialRecord.User.condArray(c).noisePairs(4).noise1_fn;
noisePair4_noise1_x = TrialRecord.User.condArray(c).noisePairs(4).noise1.x;
noisePair4_noise1_y = TrialRecord.User.condArray(c).noisePairs(4).noise1.y;
noisePair4_noise2_fn = TrialRecord.User.condArray(c).noisePairs(4).noise2_fn;
noisePair4_noise2_x = TrialRecord.User.condArray(c).noisePairs(4).noise2.x;
noisePair4_noise2_y = TrialRecord.User.condArray(c).noisePairs(4).noise2.y;

% --- RETRIEVE CHOICE IMGFILES AND XY
choice1_fn = TrialRecord.User.condArray(c).choice1.fileName;
choice1_x = TrialRecord.User.condArray(c).choice1.x;
choice1_y = TrialRecord.User.condArray(c).choice1.y;
choice2_fn = TrialRecord.User.condArray(c).choice2.fileName;
choice2_x = TrialRecord.User.condArray(c).choice2.x;
choice2_y = TrialRecord.User.condArray(c).choice2.y;

% --- RETRIEVE STIM AND CHOICE EVENT CODES
% Stimulus order in task is choice array onset, then stim
% movie with choices visible, then response, then reward.

% PROS: places neural activity reflecting rewState derived from stim movie
% as close to response/reward in time as possible. Should maximize STDP
% driven learning. Somehow, seems best to have the stim movie embedded
% in the middle of a bandit-style trial, rather than have a cue epoch
% followed by a bandit-choice epoch.  This is trending to Shadlen's weather
% prediction task, adds associative learning and stimulus timing
% components, but close. That might OK...

% CONS: Neural signals reflecting reward state may be contaminated by
% neural signals reflecting directional choice as they will be concurrent
% and not separated into sequential task epochs, but may be possible to
% disentangle state vers choice signals analytically posthoc.
% An empirical question, hard to guess without data.
% Maybe record with both...

% --- choice on code
choices_on = TrialRecord.User.codes.choices_on;

% --- stim codes
% Numbers refer to the number of the stimulus within the 4
% randomly selected in each condition to build xPairs
stim1_on = TrialRecord.User.codes.stim1_on;
stim1_off = TrialRecord.User.codes.stim1_off;
stim2_on = TrialRecord.User.codes.stim2_on;
stim2_off = TrialRecord.User.codes.stim2_off;
stim3_on = TrialRecord.User.codes.stim3_on;
stim3_off = TrialRecord.User.codes.stim3_off;
stim4_on = TrialRecord.User.codes.stim4_on;
stim4_off = TrialRecord.User.codes.stim4_off;
% stim pair codes
stimPair_on = TrialRecord.User.codes.stimPair_on;
stimPair_off = TrialRecord.User.codes.stimPair_off;

% --- noise codes
% Numbers refer to the number of the stimulus within the 4
% randomly selected in each condition to build noise pairs
noise1_on = TrialRecord.User.codes.noise1_on;
noise1_off = TrialRecord.User.codes.noise1_off;
noise2_on = TrialRecord.User.codes.noise2_on;
noise2_off = TrialRecord.User.codes.noise2_off;
noise3_on = TrialRecord.User.codes.noise3_on;
noise3_off = TrialRecord.User.codes.noise3_off;
noise4_on = TrialRecord.User.codes.noise4_on;
noise4_off = TrialRecord.User.codes.noise4_off;
% noise pair codes
noisePair_on = TrialRecord.User.codes.noisePair_on;
noisePair_off = TrialRecord.User.codes.noisePair_off;

% --- choice off code
choices_off = TrialRecord.User.codes.choices_off;

% --- RETRIEVE STIM TIMING AND ORDER VARIABLES
preMovieDur = TrialRecord.User.condArray(c).preMovieDur;
postMovieDur = TrialRecord.User.condArray(c).postMovieDur;
stimDur = TrialRecord.User.condArray(c).stimDur;
soa = TrialRecord.User.condArray(c).soa;
stimOrder = TrialRecord.User.condArray(c).stimOrder;
% times from condArray for reference
% condArrayTemp(b, c, p).stimDur = params.stimDur;
% condArrayTemp(b, c, p).preMovieDur = params.preMovieDur;
% condArrayTemp(b, c, p).soa = 3;
% condArrayTemp(b, c, p).stimOrder = 1;

% --- RETRIEVE MOVIE MODE
movieMode = TrialRecord.User.condArray(c).movieMode;

% --- SET STIM PARAMS FOR imageChanger FUNCTION CALL TO CONTROL MOVIE
% FROM ML DOCUMENTATION on imageChanger
% Input Properties:
% List: An n-by-3 or n-by-4 or n-by-5 cell matrix
% 1st column: Image filename(s) or function string(s) (see Remarks)
% 2nd column: Image XY position(s) in visual angles, an n-by-2 matrix ([x1 y1; x2 y2; ...])
% 3rd column: Duration in number of frames (or in milliseconds. See the DurationUnit property below.)
% 4th column: Eventmarker(s); optional
% 5th column: Resize parameter, [Xsize Ysize] in pixels; optional

% STIMULUS PRESENTATION STRATEGY
% present choice array, red and green targets, left and right at random
% first.  This will elicit neural signals relating to the array onset, and
% any initial response bias.  Then present the cue movie overlayed
% (concurrent with) the choice array.  Scene timing will be controlled by
% key press or joystick response, subjects can respond as soon as they
% like. Once cue movie begins, neural signals reflecting reward state
% should emerge.  Reward prediction errors generated by response should
% modify all current neural activity patterns, including reward state. This
% places the neural signals encoding reward state and dopamine
% reinforcement signals as close together in time as possible, which should
% maximize synaptic plasticity.  To implement, incorporate choice targets
% into the frames of the cue movie.

% ----------------------- SPECIFY FRAME TYPES -----------------------------
% implement different movieModes by recombining the basic frame types
% below. This is essentially shorthand to make code more compact for
% building different combinations of frames for different movieModes, with
% option to include noise pairs in movies.

% --- CHOICES PRESTIM
% before pair movie
frame_choices_preStim = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], preMovieDur, choices_on};

% --- CHOICES POSTSTIM
% after movie
frame_choices_postStim = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], postMovieDur, choices_on};

% --- STIMULUS PAIR
% --- both stimuli simultaneously presented
frame_choices_stimPair_on = {{choice1_fn, choice2_fn, stim1_fn, stim2_fn}, [choice1_x choice1_y; choice2_x choice2_y; stim1_x stim1_y; stim2_x stim2_y], stimDur, stimPair_on};
frame_choices_stimPair_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, stimPair_off};
% --- stim1 only
frame_choices_stim1_on = {{choice1_fn, choice2_fn, stim1_fn}, [choice1_x choice1_y; choice2_x choice2_y; stim1_x stim1_y], stimDur, stim1_on};
frame_choices_stim1_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, stim1_off};
% --- stim2 only
frame_choices_stim2_on = {{choice1_fn, choice2_fn, stim2_fn}, [choice1_x choice1_y; choice2_x choice2_y; stim2_x stim2_y], stimDur, stim2_on};
frame_choices_stim2_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, stim2_off};

% --- NOISE PAIR1
% --- both noise stimuli (noisePair1) simultaneously presented
frame_choices_noisePair1_pairOn = {{choice1_fn, choice2_fn, noisePair1_noise1_fn, noisePair1_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair1_noise1_x  noisePair1_noise1_y; noisePair1_noise2_x  noisePair1_noise2_y], stimDur, noisePair_on};
frame_choices_noisePair1_pairOff = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noisePair_off};
% --- noise1 (noisePair1) only
frame_choices_noisePair1_noise1_on = {{choice1_fn, choice2_fn, noisePair1_noise1_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair1_noise1_x  noisePair1_noise1_y], stimDur, noise1_on};
frame_choices_noisePair1_noise1_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise1_off};
% --- noise2 (noisePair1) only
frame_choices_noisePair1_noise2_on = {{choice1_fn, choice2_fn, noisePair1_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair1_noise2_x  noisePair1_noise2_y], stimDur, noise2_on};
frame_choices_noisePair1_noise2_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise2_off};

% --- NOISE PAIR 2
% --- both stimuli (noisePair2) simultaneously presented
frame_choices_noisePair2_pairOn = {{choice1_fn, choice2_fn, noisePair2_noise1_fn, noisePair2_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair2_noise1_x  noisePair2_noise1_y; noisePair2_noise2_x  noisePair2_noise2_y], stimDur, noisePair_on};
frame_choices_noisePair2_pairOff = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noisePair_off};
% --- noise1 (noisePair2) only
frame_choices_noisePair2_noise1_on = {{choice1_fn, choice2_fn, noisePair2_noise1_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair2_noise1_x  noisePair2_noise1_y], stimDur, noise1_on};
frame_choices_noisePair2_noise1_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise1_off};
% --- noise2 (noisePair2) only
frame_choices_noisePair2_noise2_on = {{choice1_fn, choice2_fn, noisePair2_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair2_noise2_x  noisePair2_noise2_y], stimDur, noise2_on};
frame_choices_noisePair2_noise2_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise2_off};

% --- NOISE PAIR 3
% --- both stimuli (noisePair3) simultaneously presented
frame_choices_noisePair3_pairOn = {{choice1_fn, choice2_fn, noisePair3_noise1_fn, noisePair3_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair3_noise1_x  noisePair3_noise1_y; noisePair3_noise2_x  noisePair3_noise2_y], stimDur, noisePair_on};
frame_choices_noisePair3_pairOff = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noisePair_off};
% --- noise1 (noisePair3) only
frame_choices_noisePair3_noise1_on = {{choice1_fn, choice2_fn, noisePair3_noise1_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair3_noise1_x  noisePair3_noise1_y], stimDur, noise1_on};
frame_choices_noisePair3_noise1_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise1_off};
% --- noise2 ((noisePair3) only
frame_choices_noisePair3_noise2_on = {{choice1_fn, choice2_fn, noisePair3_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair3_noise2_x  noisePair3_noise2_y], stimDur, noise2_on};
frame_choices_noisePair3_noise2_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise2_off};

% --- NOISE PAIR 4
% --- both stimuli (noisePair4) simultaneously presented
frame_choices_noisePair4_pairOn = {{choice1_fn, choice2_fn, noisePair4_noise1_fn, noisePair4_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair4_noise1_x  noisePair4_noise1_y; noisePair4_noise2_x  noisePair4_noise2_y], stimDur, noisePair_on};
frame_choices_noisePair4_pairOff = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noisePair_off};
% --- noise1 (noisePair4) only
frame_choices_noisePair4_noise1_on = {{choice1_fn, choice2_fn, noisePair4_noise1_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair4_noise1_x  noisePair4_noise1_y], stimDur, noise1_on};
frame_choices_noisePair4_noise1_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise1_off};
% --- noise2 ((noisePair4) only
frame_choices_noisePair4_noise2_on = {{choice1_fn, choice2_fn, noisePair4_noise2_fn}, ...
    [choice1_x choice1_y; choice2_x choice2_y; noisePair4_noise2_x  noisePair4_noise2_y], stimDur, noise2_on};
frame_choices_noisePair4_noise2_off = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], soa, noise2_off};

% --- ESTABLISH FRAME SEQUENCE ACCORDING TO movieMode
% --- init frame variables
movieFrames = {};
frame = {};
thisFrame = {};

% --- build vector to control which frames contain noise stimuli
noiseSequence = zeros(params.moviePairReps);
% --- compute number of noise stimuli
numNoise = floor(params.movieNoiseLevel * params.moviePairReps);
% --- insert noise stimuli at random locations (indices) within sequence
noiseIndx = randperm(params.moviePairReps,numNoise);
% --- noise flags at these indices to 1
noiseSequence(noiseIndx) = 1;

switch movieMode
    % in each mode, bracket the stimulus movie with frames showing just the
    % choice array before and after (first and last frames)
    case 'simultaneous'
        frame{1} = frame_choices_preStim;
        frame{2} = frame_choices_stimPair_on;
        % frame{3} = frame_choices_stimPair_off;
        frame{3} = frame_choices_postStim;

    case 'simultaneous_repeat'
        frame{1} = frame_choices_preStim;
        % pr, indx and frame number looping values:
        % pr 1 : indx = 1, on = 2, off = 3
        % pr 2 : indx = 3, on = 4, off = 5
        % pr 3 : indx = 5, on = 6, off = 7
        % pr 4 : indx = 7, on = 8, off = 9 ...
        for pr = 1 : params.moviePairReps
            indx = ((pr - 1) * 2) + 1;
            frame{indx + 1} = frame_choices_stimPair_on;
            frame{indx + 2} = frame_choices_stimPair_off;
        end
        % last frame number should be final value of indx + 3, one more
        % than pair off frame
        frame{indx + 3} = frame_choices_postStim;

    case 'simultaneous_noise'
        frame{1} = frame_choices_preStim;
        for pr = 1 : params.moviePairReps
            indx = ((pr - 1) * 2) + 1;
            if noiseSequence(pr) == 1
                % select one of 4 noise pairs at random
                thisNoisePair = randi(4);
                switch thisNoisePair
                    case 1
                        frame{indx + 1} = frame_choices_noisePair1_pairOn;
                        frame{indx + 2} = frame_choices_noisePair1_pairOff;
                    case 2
                        frame{indx + 1} = frame_choices_noisePair2_pairOn;
                        frame{indx + 2} = frame_choices_noisePair2_pairOff;
                    case 3
                        frame{indx + 1} = frame_choices_noisePair3_pairOn;
                        frame{indx + 2} = frame_choices_noisePair3_pairOff;
                    case 4
                        frame{indx + 1} = frame_choices_noisePair4_pairOn;
                        frame{indx + 2} = frame_choices_noisePair4_pairOff;
                end
            else
                frame{indx + 1} = frame_choices_stimPair_on;
                frame{indx + 2} = frame_choices_stimPair_off;
            end
        end
        frame{indx + 3} = frame_choices_postStim;

    case 'stdp'
        frame{1} = frame_choices_preStim;
        frame{2} = frame_choices_stim1_on;
        frame{3} = frame_choices_stim1_off;
        frame{4} = frame_choices_stim2_on;
        frame{5} = frame_choices_stim2_off;
        frame{6} = frame_choices_postStim;

    case 'stdp_repeat'
        frame{1} = frame_choices_preStim;
        % pr, indx and frame number looping values:
        % pr 1 : indx = 1, 1on = 2, 1off = 3, 2on = 4, 2off = 5
        % pr 2 : indx = 5, 1on = 6, 1off = 7, 2on = 8, 2off = 9
        % pr 3 : indx = 9, 1on = 10, 1off = 11, 2on = 12, 2off = 13
        % pr 4 : indx = 13, 1on = 14, 1off = 15, 2on = 16, 2off = 17 ...
        for pr = 1 : params.moviePairReps
            indx = ((pr - 1) * 4) + 1;
            frame{indx + 1} = frame_choices_stim1_on;
            frame{indx + 2} = frame_choices_stim1_off;
            frame{indx + 3} = frame_choices_stim2_on;
            frame{indx + 4} = frame_choices_stim2_off;
        end
        % last frame, 5 more than final indx value, one more than stim2_off
        frame{indx + 5} = frame_choices_postStim;

    case 'stdp_noise'            
        frame{1} = frame_choices_preStim;
        for pr = 1 : params.moviePairReps
            indx = ((pr - 1) * 4) + 1;
            if noiseSequence(pr) == 1
                % select one of 4 noise pairs at random
                thisNoisePair = randi(4);
                switch thisNoisePair
                    case 1
                        frame{indx + 1} = frame_choices_noisePair1_noise1_on;
                        frame{indx + 2} = frame_choices_noisePair1_noise1_off;
                        frame{indx + 3} = frame_choices_noisePair1_noise2_on;
                        frame{indx + 4} = frame_choices_noisePair1_noise2_off;
                    case 2
                        frame{indx + 1} = frame_choices_noisePair2_noise1_on;
                        frame{indx + 2} = frame_choices_noisePair2_noise1_off;
                        frame{indx + 3} = frame_choices_noisePair2_noise2_on;
                        frame{indx + 4} = frame_choices_noisePair2_noise2_off;
                    case 3
                        frame{indx + 1} = frame_choices_noisePair3_noise1_on;
                        frame{indx + 2} = frame_choices_noisePair3_noise1_off;
                        frame{indx + 3} = frame_choices_noisePair3_noise2_on;
                        frame{indx + 4} = frame_choices_noisePair3_noise2_off;
                    case 4
                        frame{indx + 1} = frame_choices_noisePair4_noise1_on;
                        frame{indx + 2} = frame_choices_noisePair4_noise1_off;
                        frame{indx + 3} = frame_choices_noisePair4_noise2_on;
                        frame{indx + 4} = frame_choices_noisePair4_noise2_off;
                end
            else
                frame{indx + 1} = frame_choices_stim1_on;
                frame{indx + 2} = frame_choices_stim1_off;
                frame{indx + 3} = frame_choices_stim2_on;
                frame{indx + 4} = frame_choices_stim2_off;
            end
        end
        frame{indx + 5} = frame_choices_postStim;

    case 'sequential'
        % tbd, once basic pairs paradigm validated with behavior

end

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieFrames
for f = 1 : size(frame, 2)
    thisFrame = frame{1, f};
    movieFrames = [movieFrames; thisFrame]; 
end

bob = 'finished';

% movieFrames = squeeze(movieFrames);

end


