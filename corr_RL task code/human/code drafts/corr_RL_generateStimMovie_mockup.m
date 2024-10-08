function [movieFrames, pairSeq] = corr_RL_generateStimMovie_mockup()
% This function returns a cell array, movieFrames, that is used to set the
% 'List' property of a imageChanger() object.  This controls the sequence
% of images presented in the movie, which controls the proportion of cue
% and noise pairs included in each movie.

% MOCKUP ---
% run the function in debugger OUTSIDE of ML task context. Should simplify
% debugging
mockup = true;

if mockup
    [condArray, params] = corr_RL_buildTrials_v1();
    c = 12; % set mock condition number, normally set by random draw at runtime
else
    condArray = TrialRecord.User.condArray;
    c = TrialRecord.CurrentCondition;
    params = setParams();
end

times = setTimes();
codes = setCodes();

% --- BUILD PAIRSEQ VECTOR which is a sequence of indicies to access and retrieve 
% stimulus information from condArray.  Each row of condArray, corresponding to a
% single trial condition (c), includes an array of cuePairs and noisePairs. The
% stimulus movie constructed for trials of this condition will be a sequence of pair
% images selected from these arrays.  To specify specific stimuli in each pair, we
% need a vector of indices that specify which cue pair to use (1 of 2 pairs for each
% condition), and which noise pair to use (1 of 8 pairs for each condition).

% Note: new method of introducing visual noise.  Noise pairs include one
% cue stimuli (one of the initial 4 cue stimuli specified at the beggining of each 
% block) and one noise stimulus, which is a stimulus with feature
% combinations other than those of cue stimuli.  This precludes, for now,
% mixing cue pairs for reward state 1 and 2 in dfferent combinations in the
% same movie, Newsome/Shadlen-style, which seems a different question about
% perceptual discrimination than statistical learning which is our current
% focus

% --- retrive number of cue pairs for this movie
numCuePairs = condArray(c).numCuePairs;
% --- build vector of 1s and 2s indicating which of the two cue pairs
% associated with each condition to show each frame of the movie. (Note:
% setParams() checks that numCuePairs is divisible by 2).
cue1Vect = ones(1, numCuePairs/2);
cue2Vect = ones(1, numCuePairs/2) + 1;
cueVect = [cue1Vect cue2Vect];

% build vector of elements equal to 1-8 controlling whether to include
% noise pair 1-8 in each movie frame.  Add 10 to each element to indicate
% this is an index into the noisePair array.
numNoisePairs = params.numMoviePairs - numCuePairs;

% divide noise pairs equally between pairs that are cue left/noise right
% (ind 1-4) and pairs that are noise left/cue right (ind 5-8)
numNoiseRight = floor(numNoisePairs/2);
numNoiseLeft = numNoisePairs - numNoiseRight;

noiseRightVect = [];
for n = 1 : numNoiseRight
    randNoiseInd = randi(4);
    noiseRightVect = [noiseRightVect randNoiseInd];
end

noiseLeftVect = [];
for n = 1 : numNoiseRight
    randNoiseInd = randi(4) + 4;
    noiseLeftVect = [noiseLeftVect randNoiseInd];
end
% aggregate noise indices
noiseVect = [noiseRightVect noiseLeftVect];
noiseVect = noiseVect + 10;

% concatenate cue and noise vectors into pairSeq
pairSeq = [cueVect noiseVect];
% --- randomize order of pairSeq
pairSeq = pairSeq(randperm(length(pairSeq)));

% --- build seq of pairs, stim and noise, to control movie frames
for p = 1 : length(pairSeq)

    if pairSeq(p) < 10 % stimPair
        ind = pairSeq(p);
        pairs(p).pairIndx = ind;
        pairs(p).pairID = condArray(c).cuePairs(ind).pairID;
        pairs(p).leftStim = condArray(c).cuePairs(ind).leftStim;
        pairs(p).rightStim = condArray(c).cuePairs(ind).rightStim;
    elseif pairSeq(p) >= 10 % noisePair
        ind = pairSeq(p) - 10;
        pairs(p).pairIndx = ind;
        pairs(p).pairID = condArray(c).noisePairs(ind).pairID;
        pairs(p).leftStim = condArray(c).noisePairs(ind).leftStim;
        pairs(p).rightStim = condArray(c).noisePairs(ind).rightStim;

    end

end % next p

% --- RETRIEVE EVENT CODES
startPretrial = codes.startPretrial;
fix_on = codes.fix_on;
choices_on = codes.choices_on;
imgPair_on = codes.imgPair_on;
imgPair_off = codes.imgPair_off;
img1_on = codes.img1_on;
img1_off = codes.img1_off;
img2_on = codes.img2_on;
img2_off = codes.img2_off;
endMovie = codes.endMovie;
response_key1 = codes.response_key1;
response_key2 = codes.response_key2;
choiceRing_on = codes.choiceRing_on;
rewRing_on = codes.rewRing_on;

bob = 'foggy';

% --- DEFINE STANDARD FRAMES
fix_frame = {[], [], times.fixDur, fix_on};
soa_frame = {[], [], times.soa, img1_off};
interPair_frame = {[], [], times.interPair, imgPair_off};
postMovie_frame = {[], [], times.postMovieDur, endMovie};

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
frame{1} = fix_frame;

% --- use pair sequence fn, x and y to build movie frame seq

for p = 1 : length(pairs)

    % --- RETRIEVE FILENAMES AND XY POSITIONS FOR 2 IMAGES OF THIS PAIR
    % pairs is a 1 by n cell array, looping over 2nd dimension
    leftImg_fn = pairs(p).leftStim.FileName;
    leftImg_x = pairs(p).leftStim.Position(1);
    leftImg_y = pairs(p).leftStim.Position(2);
    rightImg_fn = pairs(p).rightStim.FileName;
    rightImg_x = pairs(p).rightStim.Position(1);
    rightImg_y = pairs(p).rightStim.Position(2);

    % --- BUILD SIMULTANEOUS AND SEQUENTIAL STIM FRAMES FOR EACH IMG PAIR
    pair_frame = {{leftImg_fn, rightImg_fn}, [leftImg_x leftImg_y; rightImg_x rightImg_y], times.stimDur, imgPair_on};
    leftImg_frame = {{leftImg_fn}, [leftImg_x leftImg_y], times.stimDur, img1_on};
    rightImg_frame = {{rightImg_fn}, [rightImg_x rightImg_y], times.stimDur, img2_on};

    % --- COMBINE FRAMES INTO SEQUENCEg
    switch params.movieMode

        case 'simultaneous'
            % p, indx and frame number looping values:
            % p 1 : indx = 1, pair_frame = 2, interPair_Frame = 3
            % p 2 : indx = 3, pair_frame = 4, interPair_Frame = 5
            % p 3 : indx = 5, pair_frame =  6, interPair_Frame = 7
            % p 4 : indx = 7, pair_frame =  8, interPair_Frame = 9 ...
            indx = ((p - 1) * 2) + 2;
            frame{indx + 1} = pair_frame;
            frame{indx + 2} = interPair_frame;
            
        case 'stdp'
            % pr, indx and frame number looping values:
            % pr 1 : indx = 1, 1on = 2, 1off = 3, 2on = 4, 2off = 5
            % pr 2 : indx = 5, 1on = 6, 1off = 7, 2on = 8, 2off = 9
            % pr 3 : indx = 9, 1on = 10, 1off = 11, 2on = 12, 2off = 13
            % pr 4 : indx = 13, 1on = 14, 1off = 15, 2on = 16, 2off = 17 ...
            indx = ((p - 1) * 4) + 2;
            frame{indx + 1} = leftImg_frame;
            % frame{indx + 2} = soa_frame;
            frame{indx + 2} = pair_frame;
            frame{indx + 3} = rightImg_frame;
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


