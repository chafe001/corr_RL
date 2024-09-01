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

condArray = TrialRecord.User.condArray;
c = TrialRecord.CurrentCondition;
params = corr_RL_setParams();
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


% --- compute number of cue stimulus pairs to display
pairReps = round(condArray(c).cuePercent * params.movieStimReps);

% --- compute number of cue stimulus singletons to display
singletonReps = params.movieStimReps - pairReps;

% --- build pairSeq vector determinining for each movie frame triplet to
% show both stimuli (1), omit the left stimulus (2), omit the right
% stimulus (3), or omit both stimuli (4).  Optionally replace omitted
% stimuli with a mask

% --- frame triplets showing both stimuli in the pair
bothStim = ones(1, pairReps);

% --- frame triplets showing only the left stimulus
leftStim = ones(1, singletonReps) + 1;

% --- frame triplets showing only the right stimulus
rightStim = ones(1, singletonReps) + 2;

% --- frame triplets out of total remaining to show neither stiuulus
neitherStim = ones(1, params.numMovieTriplets - (pairReps + (2 * singletonReps))) + 3;

% --- concatenate vectors
pairSeq = [bothStim leftStim rightStim neitherStim];

% --- randomize order of pairSeq
pairSeq = pairSeq(randperm(length(pairSeq)));

% --- build seq of pairs, stim and noise, to control movie frames
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
preMovie = {[], [], times.preMovie_frames, codes.preMovie};
soa = {[], [], times.soa_frames, codes.img1_off};
interPair = {[], [], times.interPair_frames, codes.imgPair_off};

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
pairFrames{1} = preMovie;

for p = 1 : length(pairs)

    % --- define left stimulus frame
    leftStim_fn = pairs(p).leftStim.FileName;
    leftStim_x = pairs(p).leftStim.Position(1);
    leftStim_y = pairs(p).leftStim.Position(2);
    leftStim = {leftStim_fn, [leftStim_x leftStim_y], times.stim_frames, codes.img1_on};

    % --- define right stimulus frame
    rightStim_fn = pairs(p).rightStim.FileName;
    rightStim_x = pairs(p).rightStim.Position(1);
    rightStim_y = pairs(p).rightStim.Position(2);
    rightStim = {rightStim_fn, [rightStim_x rightStim_y], times.stim_frames, codes.img2_on};

    % --- compute frame index counter based on 4 frames per pair
    frameIndx = ((p - 1) * 4) + 2;
    
    % --- combine with soa and interpair frames
    pairFrames{frameIndx} = leftStim;
    pairFrames{frameIndx + 1} = soa;
    pairFrames{frameIndx + 2} = rightStim;
    pairFrames{frameIndx + 3} = interPair;

end  % next p

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieImages
movieFrames = {};
for f = 1 : size(pairFrames, 2)
    thisFrame = pairFrames{1, f};
    movieFrames = [movieFrames; thisFrame]; 
end


bob = 'finished';


end


