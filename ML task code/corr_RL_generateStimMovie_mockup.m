function [movieFrames, pairSeq] = corr_RL_generateStimMovie_mockup()
% This function generates the frames of a stimulus movie based on condition
% number and stimulus parameters specified in condArray

% MOCKUP ---
[condArray, params] = corr_RL_buildTrials_v1();
c = 12;
times.idle_ms = 100;  % in ms
times.fixDur = 30;  % in screen refresh cycles
times.preMovieDur = 30;  % fix targ and choices
times.postMovieDur = 30;
times.sc1_pretrial_frames = 30;
times.sc2_movie_maxFrames = 1000;
times.sc3_feedback_frames = 500; % duration of scene depends on choice ring timing
times.choiceRing_frames = 10;
times.rewRing_frames = 10;               % screen refresh units
codes.startPretrial = 10;
codes.fix_on = 20;
codes.choices_on = 30;
codes.imgPair_on = 40;
codes.imgPair_off = 50;
codes.img1_on = 60;
codes.img1_off = 70;
codes.img2_on = 80;
codes.img2_off = 90;
codes.endMovie = 100;
codes.response_key1 = 110;
codes.response_key2 = 120;
codes.choiceRing_on = 130;
codes.rewRing_on = 140;
codes.noEye = 150;
codes.brokeEye = 160;

% --- GENERATE stimSeq and noiseSeq VECTORS
% vectors are a sequence of indices into condArray to retrieve stimulus
% pair information for each movie frame.  Each stimulus pair defines 
% one left and and one right stimulus. 
% 
% Each condition has 2 cue stim pairs, 
% and 8 noise pairs available.



% params.corrStrength_mode = 'pairMix' or 'noiseMix'

% --- compute number of false and true stimulus pairs
numNoisePairs = floor(params.moviePairReps * condArray(c).noiseLevel);
numCuePairs= params.moviePairReps - numNoisePairs;

% --- build vector of integers corresponding to pair indices to control 
% which stimulus or noise pairs are displayed each frame.  Indices are 
% used to access stimPairs() and noisePairs() arrays that are stored in 
% condArray. This vector controls which stimui are shown each frame

switch condArray(c).rewState
    case 1
        % reward state 1 corresponds to pairs 1 and 2 in each xPair set
        num1 = floor(numTrue/2);
        num2 = numTrue - num1;
        num3 = floor(numFalse/2);
        num4 = numFalse - num3;
        vect1 = ones(1, num1);
        vect2 = ones(1, num2) + 1;
        if strcmp(params.corrStrength_mode, 'noiseMix')
            % add 10 to indices to indicate noisePair
            vect3 = ones(1, num3) + 12;
            vect4 = ones(1, num4) + 13;
        else
            % stimPair
            vect3 = ones(1, num3) + 2;
            vect4 = ones(1, num4) + 3;
        end

    case 2
        % reward state 2 corresponds to pairs 3 and 4 in each xPair set
        num1 = floor(numFalse/2);
        num2 = numFalse - num1;
        num3 = floor(numTrue/2);
        num4 = numTrue - num3;
        vect3 = ones(1, num3) + 2;
        vect4 = ones(1, num4) + 3;
        if strcmp(params.corrStrength_mode, 'noiseMix')
            % add 10 to indices to indicate noisePair
            vect1 = ones(1, num1) + 10;
            vect2 = ones(1, num2) + 11;
        else
            % stimPair
            vect1 = ones(1, num1);
            vect2 = ones(1, num2) + 1;
        end
end

% --- concatenate vect1-4 into pairSeq
pairSeq = [vect1 vect2 vect3 vect4];
% --- randomize order of pairSeq
pairSeq = pairSeq(randperm(length(pairSeq)));

% --- build seq of pairs, stim and noise, to control movie frames
for p = 1 : length(pairSeq)

    if pairSeq(p) < 10 % stimPair
        ind = pairSeq(p);
        pairs(p).pairIndx = ind;
        pairs(p).pairID = condArray(c).stimPairs(ind).stimPairID;
        pairs(p).img1_fn = condArray(c).stimPairs(ind).stim1_fn;
        pairs(p).img1_x = condArray(c).stimPairs(ind).stim1.x;
        pairs(p).img1_y = condArray(c).stimPairs(ind).stim1.y;
        pairs(p).img2_fn = condArray(c).stimPairs(ind).stim2_fn;
        pairs(p).img2_x = condArray(c).stimPairs(ind).stim2.x;
        pairs(p).img2_y = condArray(c).stimPairs(ind).stim2.y;

    elseif pairSeq(p) >= 10 % noisePair
        ind = pairSeq(p) - 10;
        pairs(p).pairIndx = ind;
        pairs(p).pairID = condArray(c).noisePairs(ind).noisePairID;
        pairs(p).img1_fn = condArray(c).noisePairs(ind).noise1_fn;
        pairs(p).img1_x = condArray(c).noisePairs(ind).noise1.x;
        pairs(p).img1_y = condArray(c).noisePairs(ind).noise1.y;
        pairs(p).img2_fn = condArray(c).noisePairs(ind).noise2_fn;
        pairs(p).img2_x = condArray(c).noisePairs(ind).noise2.x;
        pairs(p).img2_y = condArray(c).noisePairs(ind).noise2.y;

    end

end % next i

% --- RETRIEVE CHOICE IMGFILES AND XY
choice1_fn = condArray(c).choice1_fn;
choice1_x = condArray(c).choice1_x;
choice1_y = condArray(c).choice1_y;
choice2_fn = condArray(c).choice2_fn;
choice2_x = condArray(c).choice2_x;
choice2_y = condArray(c).choice2_y;

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

% --- DEFINE STANDARD FRAMES
fix_frame = {[], [], times.fixDur, fix_on};
preMovie_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], times.preMovieDur, choices_on};  % no event code here, using scene start
soa_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], times.soa, img1_off};
interPair_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], times.interPair, imgPair_off};
postMovie_frame = {{choice1_fn, choice2_fn}, [choice1_x choice1_y; choice2_x choice2_y], times.postMovieDur, endMovie};

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
frame{2} = preMovie_frame;

% --- use pair sequence fn, x and y to build movie frame seq

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
    pair_frame = {{choice1_fn, choice2_fn, this_img1_fn, this_img2_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img1_x this_img1_y; this_img2_x this_img2_y], times.stimDur, imgPair_on};
    img1_frame = {{choice1_fn, choice2_fn, this_img1_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img1_x this_img1_y], times.stimDur, img1_on};
    img2_frame = {{choice1_fn, choice2_fn, this_img2_fn}, [choice1_x choice1_y; choice2_x choice2_y; this_img2_x this_img2_y], times.stimDur, img2_on};

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
            frame{indx + 1} = img1_frame;
            % frame{indx + 2} = soa_frame;
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


