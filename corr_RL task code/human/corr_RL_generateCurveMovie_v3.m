function [movieImages, movieParams] = corr_RL_generateCurveMovie_v3(TrialRecord)
% This function returns a cell array, movieImages, that is used to set the
% 'List' property of a imageChanger() object.  This controls the sequence
% of images presented in the movie, which controls the proportion of cue
% and noise pairs included in each movie.

% Version history:
% v1: first effort to use line drawings at stimuli (Dave's code, Thomas'
% algorithm for parametric stimulus space)

% v2: adapted to new state definition recommended by Thomas, where states A
% and B correspond to two halves of one manifold (rather than two
% manifolds), and variation in orthogonal axis is either noise or related
% to reward state.

% v3: deleting orientat

% - APPROACH:
% - figure out things needed to specify image filenames by grabbing needed
% information from condArray
% - write movieImages array using these filenames
% - all curves in same block and typ

% ************************************************************************************
% --- if real fx, uncomment the following  lines
condArray = TrialRecord.User.condArray;
c = TrialRecord.CurrentCondition;
b = TrialRecord.CurrentBlock;
params = TrialRecord.User.params;

% --- if mockup, uncomment the following  lines
% [condArray, params] = corr_RL_buildTrials_v3();
% c = 14; % hard code condition number
% b = 2; % hard code block number

times = corr_RL_setTimes_v3();
codes = corr_RL_setCurveCodes_v3();

% --- DEFINE STANDARD IMAGES
preMovie_img = {[], [], times.preMovie_frames, codes.preMovie};
betweenCurves_img = {[], [], times.interPair_frames, codes.curve_off};

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

% --- RETRIEVE REWARD STATE from condArray
s = condArray(c).state;

% --- RETRIEVE MOVIE PARAMS FROM CONDARRAY
ct = condArray(c).curveMovieType;
b = condArray(c).blockNum;

% --- SELECT A LINEAR SEQUENCE OF CURVES at various orientations to the
% main and orthogonal manifolds

% this assumes a square matrix of curves, main = ortho levels
% startBox is the dimension per side of of the quadrant of locations within
% the curve grid from which a diagonal vector of length nCurvesPerMovie can
% be drawn diagonally away from the quadrant without running out of points
% in the curve grid
startBox = params.n_tvals_main - params.nCurvesPerMovie + 1;

% quadrants at 4 corners of grid contain valid start points, that will
% allow vectors of nCurvesPerMovie without, that are either horizontal,
% vertical, or diagaonial, without running out of space in the grid.

% --- 1. Pick a quadrant at random
q = randi(4);

movieParams.quad = q;

% --- set ranges of t_val indices for startBox in this quadrant
switch q

    case 1  % upper left
        startMain = 1;
        endMain = startBox;
        startOrtho = params.n_tvals_ortho - startBox + 1;
        endOrtho = params.n_tvals_ortho;

    case 2  % upper right
        startMain = params.n_tvals_main - startBox + 1;
        endMain = params.n_tvals_main;
        startOrtho = params.n_tvals_ortho - startBox + 1;
        endOrtho = params.n_tvals_ortho;

    case 3  % lower left
        startMain = params.n_tvals_main - startBox + 1;
        endMain = params.n_tvals_main;
        startOrtho = 1;
        endOrtho = startBox;

    case 4  % lower right
        startMain = 1;
        endMain =  startBox;
        startOrtho = 1;
        endOrtho = startBox;
end


% --- SELECT RANDOM START POINT WITHIN STARTBOX
firstMain = randi([startMain endMain]);
firstOrtho = randi([startOrtho endOrtho]);

% --- SET DIRECTION WITHIN CURVE GRID that movie will animate over
switch condArray(c).curveMovieOrientation

    case 'horizontal'
        switch q
            case 1  % upper left, line
                deltaMain = 1;
                deltaOrtho = 0;
            case 2
                deltaMain = -1;
                deltaOrtho = 0;
            case 3
                deltaMain = -1;
                deltaOrtho = 0;
            case 4
                deltaMain = 1;
                deltaOrtho = 0;
        end

    case 'vertical'
        switch q
            case 1  % upper left, line
                deltaMain = 0;
                deltaOrtho = -1;
            case 2
                deltaMain = 0;
                deltaOrtho = -1;
            case 3
                deltaMain = 0;
                deltaOrtho = 1;
            case 4
                deltaMain = 0;
                deltaOrtho = 1;
        end

    case 'diagonal'
        % set slope of diagonal line based on which quadrant of grid we are
        % starting from
        switch q
            case 1  % upper left, line
                deltaMain = 1;
                deltaOrtho = -1;
            case 2
                deltaMain = -1;
                deltaOrtho = -1;
            case 3
                deltaMain = -1;
                deltaOrtho = 1;
            case 4
                deltaMain = 1;
                deltaOrtho = 1;
        end

end

% --- BUILD VECTOR OF INDICES INTO CURVE GRID along main and ortho
% dimensions

mainSeq = [];
orthoSeq = [];

for f = 1 : params.nCurvesPerMovie
    nextMain = firstMain + ((f-1) * deltaMain);
    mainSeq = [mainSeq nextMain];
    nextOrtho = firstOrtho + ((f-1) * deltaOrtho);
    orthoSeq = [orthoSeq nextOrtho];
end

% --- IF ROUGH MOVIE, RANDOMIZE ORDER
if strcmp(condArray(c).curveMovieType, 'rough')
    rndOrder = randperm(params.nCurvesPerMovie);
    mainSeq = mainSeq(rndOrder);
    orthoSeq = orthoSeq(rndOrder);
end

% --- AGGREGATE MOVIE PARAMS FOR OUTPUT
movieParams.curveMovieType = condArray(c).curveMovieType;
movieParams.orientation = condArray(c).curveMovieOrientation;
movieParams.mainSeq = mainSeq;
movieParams.orthoSeq = orthoSeq;
movieParams.mainTvalSeq = params.endcurve_t(mainSeq);
movieParams.orthoTvalSeq = params.orthocurve_t(orthoSeq);

% --- DETERMINE BLOCK SPECIFIC filename elements that reflect which vars
% varied at block level by genCurve

switch condArray(c).snr

    case 1  % high SNR
        prefix = 'snr_high_';

    case 2  % low SNR
        prefix = 'snr_low_';

end


% --- BUILD MOVIE IMAGES
for cs = 1 : length(mainSeq)

    % --- build filename using mainSeq and orthoSeq info
    thisMain = mainSeq(cs);
    thisOrtho = orthoSeq(cs);
    fn = strcat(prefix, 'b', num2str(b), '_s', num2str(s), '_ec_', num2str(thisMain), '_oc_', num2str(thisOrtho),'.png');
    images{cs} =  {{fn}, [0 0], times.curve_frames, codes.curve_on};

end

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieImages
movieImages = {};
for f = 1 : size(images, 2)
    thisImg = images{1, f};
    movieImages = [movieImages; thisImg];
end

bob = 'finished';

end
