function [movieFrames] = xPairs_generateStimMovie_mix_v2(TrialRecord)
% This function builds a cell array that specifies all stimulus identity,
% location and timing information for the stimulus movie.  Each row
% corresponds to the information needed to specify one image frame in
% imageChanger.  The cell array is passed as an argument to imageChanger to
% build the movie.


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

% --- RETRIEVE CURRENT CONDITION NUMBER (from TrialRecord)
c = TrialRecord.CurrentCondition;

% --- SHORTHAND for PARAMS
params = TrialRecord.User.params;

% --- GENERATE stimSeq and noiseSeq VECTORS, IF NOISE ENABLED
% pairSeq controls which stimulus pairs will be shown in what order during
% movie.  It is a sequence of indicies into stimArray.  buildStimPairs
% produces 4 pairs per block.  Pairs 1 and 2 correspond to rewState 1.
% Pairs 3 and 4 correspond to rewState 2.  Goal is to mix rewState 1 and 2
% pairs in a proportion controlled by params.rewState1Proportions. Option
% to replace a variable proportion of pairs with noise pairs to vary
% associative strength of stimulus, in addition to perceptual strength of
% proportion of pairs instructing rewState 1 and 2.  To add noise, generate
% noiseSeq vector of indices to access noiseArray. Then mix stimSeq and
% noiseSeq to produce pairSeq, which will control movie.

% --- compute number of stim and noise pairs to show, if noise enabled
if params.addNoise
    numNoise = floor(params.moviePairReps * params.noiseProp);
    numStim = params.moviePairReps - numNoise;
else 
    numStim = params.moviePairReps;
end

% --- compute stimSeq

% rewState1 pairs
numRewState1 = floor(TrialRecord.User.condArray(c).rewState1prop * numStim);
numRewState1_pair1 = floor(numRewState1 / 2);
stimPair1s = ones(1, numRewState1_pair1);
numRewState1_pair2 = numRewState1 - numRewState1_pair1;
stimPair2s = ones(1, numRewState1_pair2) + 1;

% rewState2 pairs
numRewState2 = numStim - numRewState1;
numRewState2_pair3 = floor(numRewState2 / 2);
stimPair3s = ones(1, numRewState2_pair3) + 2;
numRewState2_pair4 = numRewState2 - numRewState2_pair3;
stimPair4s = ones(1, numRewState2_pair4) + 3;

% concatenate stimPairs for rewState 1 and 2 in desired proportion
stimSeq = [stimPair1s stimPair2s stimPair3s stimPair4s];

% --- compute noiseSeq, if noise enabled
if params.addNoise
    % add equal proportions of noisePairs 1, 2, 3 and 4, all rewState -1
    noisePair1s = ones(1, floor(numNoise/4));
    noisePair2s = ones(1, floor(numNoise/4)) + 1;
    noisePair3s = ones(1, floor(numNoise/4)) + 2;
    noisePair4s = ones(1, floor(numNoise/4)) + 3;
    % this might be off if numNoise not divisible by 4 but doesn't matter
    noiseSeq = [noisePair1s noisePair2s noisePair3s noisePair4s];
    % shift noiseSeq indices by 10 so distinguishable form stimSeq,
    % subtract 10 when building movie to use noise indices to access
    % noiseArray
    noiseSeq = noiseSeq + 10;
    pairSeq = [stimSeq noiseSeq];
else
    pairSeq = stimSeq;
end

% --- randomize order of pairSeq
pairSeq = pairSeq(randperm(length(pairSeq)));

% --- build seq of pairs, stim and noise, to control movie frame seq
for p = 1 : length(pairSeq)

    if pairSeq(p) < 10 % stimPair
        ind = pairSeq(p);
        pairs(p).pairIndx = ind;
        pairs(p).pairID = TrialRecord.User.condArray(c).stimPairs(ind).stimPairID;
        pairs(p).img1_fn = TrialRecord.User.condArray(c).stimPairs(ind).stim1_fn;
        pairs(p).img1_x = TrialRecord.User.condArray(c).stimPairs(ind).stim1.x;
        pairs(p).img1_y = TrialRecord.User.condArray(c).stimPairs(ind).stim1.y;
        pairs(p).img2_fn = TrialRecord.User.condArray(c).stimPairs(ind).stim2_fn;
        pairs(p).img2_x = TrialRecord.User.condArray(c).stimPairs(ind).stim2.x;
        pairs(p).img2_y = TrialRecord.User.condArray(c).stimPairs(ind).stim2.y;

    elseif pairSeq(p) >= 10 % noisePair
        ind = pairSeq(p) - 10;
        pairs(p).pairIndx = ind;
        pairs(p).pairID = TrialRecord.User.condArray(c).noisePairs(ind).noisePairID;
        pairs(p).img1_fn = TrialRecord.User.condArray(c).noisePairs(ind).noise1_fn;
        pairs(p).img1_x = TrialRecord.User.condArray(c).noisePairs(ind).noise1.x;
        pairs(p).img1_y = TrialRecord.User.condArray(c).noisePairs(ind).noise1.y;
        pairs(p).img2_fn = TrialRecord.User.condArray(c).noisePairs(ind).noise2_fn;
        pairs(p).img2_x = TrialRecord.User.condArray(c).noisePairs(ind).noise2.x;
        pairs(p).img2_y = TrialRecord.User.condArray(c).noisePairs(ind).noise2.y;

    end

end % next i

% --- RETRIEVE CHOICE IMGFILES AND XY
choice1_fn = TrialRecord.User.condArray(c).choice1_fn;
choice1_x = TrialRecord.User.condArray(c).choice1_x;
choice1_y = TrialRecord.User.condArray(c).choice1_y;
choice2_fn = TrialRecord.User.condArray(c).choice2_fn;
choice2_x = TrialRecord.User.condArray(c).choice2_x;
choice2_y = TrialRecord.User.condArray(c).choice2_y;

% --- RETRIEVE EVENT CODES

% codes.startPretrial = 10;
% codes.startFix = 20;
% codes.startMovie = 30;
% codes.imgPair_on = 40;
% codes.imgPair_off = 50;
% codes.img1_on = 60;
% codes.img1_off = 70;
% codes.img2_on = 80;
% codes.img2_off = 90;
% codes.endMovie = 100;
% codes.response_key1 = 110;
% codes.response_key2 = 120;
% codes.choiceRing_on = 130;
% codes.rewRing_on = 140;
% codes.noEye = 150;

startPretrial = TrialRecord.User.codes.startPretrial;
startFix = TrialRecord.User.codes.startFix;
startMovie = TrialRecord.User.codes.startMovie;
imgPair_on = TrialRecord.User.codes.imgPair_on;
imgPair_off = TrialRecord.User.codes.imgPair_off;
img1_on = TrialRecord.User.codes.img1_on;
img1_off = TrialRecord.User.codes.img1_off;
img2_on = TrialRecord.User.codes.img2_on;
img2_off = TrialRecord.User.codes.img2_off;
endMovie = TrialRecord.User.codes.endMovie;
response_key1 = TrialRecord.User.codes.response_key1;
response_key2 = TrialRecord.User.codes.response_key2;
choiceRing_on = TrialRecord.User.codes.choiceRing_on;
rewRing_on = TrialRecord.User.codes.rewRing_on;

% --- DEFINE STANDARD FRAMES
fix_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], params.preMovieDur, []};
preMovie_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], params.preMovieDur, []};  % no event code here, using scene start
soa_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], params.soa, img1_off};
interPair_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], params.interPair, imgPair_off};
postMovie_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], params.postMovieDur, endMovie};

% --- PREALLOCATE FRAME CELL ARRAY
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
pair_frame = {};
img1_frame = {};
img2_frame = {};
frame = {};
thisFrame = {};
movieFrames = {};

% --- SET FIRST FRAME (irrespective of movieMode)
frame{1} = preMovie_frame;

% --- use pair sequence fn, x and y to build movie frame seq
f = 2; % init frame counter for movie
for p = 1 : length(pairs)

    % --- RETRIEVE FILENAMES AND XY POSITIONS FOR 2 IMAGES OF THIS PAIR
    % pairs is a 1 by n cell array, looping over 2nd dimension
    this_img1_fn = pairs(1, p).img1_fn;
    this_img1_x = pairs(1, p).img1_x;
    this_img1_y = pairs(1, p).img1_y;
    this_img2_fn = pairs(1, p).img2_fn;
    this_img2_x = pairs(1, p).img2_x;
    this_img2_y = pairs(1, p).img2_y;

    % --- BUILD SIMULTANEOUS AND SEQUENTIAL STIM FRAMES FOR EACH IMG PAIR
    pair_frame = {{choice1_fn, choice2_fn, this_img1_fn, this_img2_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img1_x this_img1_y; this_img2_x this_img2_y], params.stimDur, imgPair_on};
    img1_frame = {{choice1_fn, choice2_fn, this_img1_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img1_x this_img1_y], params.stimDur, img1_on};
    img2_frame = {{choice1_fn, choice2_fn, this_img2_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img2_x this_img2_y], params.stimDur, img2_on};

    % --- COMBINE FRAMES INTO SEQUENCEg
    switch params.movieMode

        case 'simultaneous'
            % p, indx and frame number looping values:
            % p 1 : indx = 1, pair_frame = 2, interPair_Frame = 3
            % p 2 : indx = 3, pair_frame = 4, interPair_Frame = 5
            % p 3 : indx = 5, pair_frame =  6, interPair_Frame = 7
            % p 4 : indx = 7, pair_frame =  8, interPair_Frame = 9 ...
            indx = ((p - 1) * 2) + 1;
            frame{indx + 1} = pair_frame;
            frame{indx + 2} = interPair_frame;
            
        case 'stdp'
            % pr, indx and frame number looping values:
            % pr 1 : indx = 1, 1on = 2, 1off = 3, 2on = 4, 2off = 5
            % pr 2 : indx = 5, 1on = 6, 1off = 7, 2on = 8, 2off = 9
            % pr 3 : indx = 9, 1on = 10, 1off = 11, 2on = 12, 2off = 13
            % pr 4 : indx = 13, 1on = 14, 1off = 15, 2on = 16, 2off = 17 ...
            indx = ((p - 1) * 4) + 1;
            frame{indx + 1} = img1_frame;
            %             frame{indx + 2} = soa_frame;
            frame{indx + 2} = pair_frame;
            frame{indx + 3} = img2_frame;
            frame{indx + 4} = interPair_frame;

        otherwise
            error('unrecognized movieMode in generateStimMovie');

    end  % switch movieMode
end  % next p

% --- SET LAST FRAME (irrespective of movieMode)
switch params.movieMode
    case 'simultaneous'
        frame{indx + 3} = postMovie_frame;
    case 'stdp'
        frame{indx + 5} = postMovie_frame;

end


% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieFrames
movieFrames = {};
for f = 1 : size(frame, 2)
    thisFrame = frame{1, f};
    movieFrames = [movieFrames; thisFrame]; 
end


bob = 'finished';


end

