function [movieImages, pairSeq] = corr_RL_generateBarMovie_v2_mockup()
% This function returns a cell array, movieImages, that is used to set the
% 'List' property of a imageChanger() object.  This controls the sequence
% of images presented in the movie, which controls the proportion of cue
% and noise pairs included in each movie.

% VERSION HISTORY
% v1: works with original xPairs design
% v2: adds new randList pairs design

% --- if real fx, uncomment the following  lines
% condArray = TrialRecord.User.condArray;
% params = TrialRecord.User.params;
% c = TrialRecord.CurrentCondition;

% --- if mockup, uncomment the following  lines
[condArray, params] = corr_RL_buildTrials_v5();
c = 4; % hard code condition number
bn = 2; % hard code block number

times = corr_RL_setTimes_v3();
codes = corr_RL_setBarCodes_v3();

% --- create pairSeq vector specifying which pairs to show how many times
% in movie in randomized order
nPairs = size(condArray(c).cuePairs, 2);
pairSeq = 1:nPairs;
pairSeq = repmat(pairSeq, 1, params.numCueReps);
pairSeq = pairSeq(randperm(size(pairSeq, 2)));

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


% codes.startFix = 10;
% codes.preMovie = 20;
% codes.imgPair_on = 30;
% codes.imgPair_off = 40;
% codes.img1_on = 50;
% codes.img1_off = 60;
% codes.img2_on = 70;
% codes.img2_off = 80;
% codes.endMovie = 90;
% codes.beginRespWindow = 100;
% codes.response_key1 = 110;
% codes.response_key2 = 120;
% codes.choiceRing_on = 130;
% codes.errorRing_on = 140;
% codes.rewRing_on = 150;


% --- DEFINE STANDARD IMAGES
preMovie_img = {[], [], times.preMovie_frames, TrialRecord.User.codes.preMovie};
soa_img = {[], [], times.soa_frames, TrialRecord.User.codes.img1_off};
interPair_img = {[], [], times.interPair_frames, TrialRecord.User.codes.imgPair_off};

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
pair_img = {};
img1 = {};
img2 = {};
images = {};
thisImg = {};
movieImages = {};

% --- SET FIRST FRAME (irrespective of movieMode)
images{1} = preMovie_img;

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
    pair_img = {{leftImg_fn, rightImg_fn}, [leftImg_x leftImg_y; rightImg_x rightImg_y], times.stim_frames, TrialRecord.User.codes.imgPair_on};
    leftImg_frame = {{leftImg_fn}, [leftImg_x leftImg_y], times.stim_frames, TrialRecord.User.codes.img1_on};
    rightImg_frame = {{rightImg_fn}, [rightImg_x rightImg_y], times.stim_frames, TrialRecord.User.codes.img2_on};

    % --- COMBINE FRAMES INTO SEQUENCEg
    switch params.movieMode

        case 'simultaneous'
            % p, indx and frame number looping values:
            % p 1 : indx = 1, pair_img = 2, interPair_img = 3
            % p 2 : indx = 3, pair_img = 4, interPair_img = 5
            % p 3 : indx = 5, pair_img =  6, interPair_img = 7
            % p 4 : indx = 7, pair_img =  8, interPair_img = 9 ...
            indx = ((p - 1) * 2) + 2;
            images{indx + 1} = pair_img;
            images{indx + 2} = interPair_img;
            
        case 'stdp'
            % pr, indx and frame number looping values:
            % pr 1 : indx = 1, 1on = 2, 1off = 3, 2on = 4, 2off = 5
            % pr 2 : indx = 5, 1on = 6, 1off = 7, 2on = 8, 2off = 9
            % pr 3 : indx = 9, 1on = 10, 1off = 11, 2on = 12, 2off = 13
            % pr 4 : indx = 13, 1on = 14, 1off = 15, 2on = 16, 2off = 17 ...
            indx = ((p - 1) * 4) + 2;
            images{indx + 1} = leftImg_frame;
            % images{indx + 2} = soa_img;
            images{indx + 2} = pair_img;
            images{indx + 3} = rightImg_frame;
            images{indx + 4} = interPair_img;

        otherwise
            error('unrecognized movieMode in generateStimMovie');

    end  % switch movieMode
end  % next p

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieImages
movieImages = {};
for f = 1 : size(images, 2)
    thisImg = images{1, f};
    movieImages = [movieImages; thisImg]; 
end


bob = 'finished';


end

