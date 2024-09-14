function [movieImages] = corr_RL_generateCurveMovie_v2(TrialRecord)
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

% - APPROACH:
% - figure out things needed to specify image filenames by grabbing needed
% information from condArray
% - write movieImages array using these filenames
% - all curves in same block and typ

% ************************************************************************************
% --- if real fx, uncomment the following  lines
condArray = TrialRecord.User.condArray;
c = TrialRecord.CurrentCondition;
bn = TrialRecord.CurrentBlock;
params = TrialRecord.User.params;

% --- if mockup, uncomment the following  lines
% [condArray, params] = corr_RL_buildTrials_v3();
% c = 1; % hard code condition number
% b = 2; % hard code block number
% params = corr_RL_setParams_v3();

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
cmn = condArray(c).curveMovieNoise;
cmo = condArray(c).curveMovieOrder;
cmg = condArray(c).curveMovieGeometry;
b = condArray(c).blockNum;


% --- SELECT A LINEAR SEQUENCE OF CURVES at various orientations to the
% main and orthogonal manifolds

% this assumes a square matrix of curves, main = ortho levels
startBox = params.n_tvals_main - params.nCurvesPerMovie;

% quadrants at 4 corners of grid contain valid start points, that will
% allow vectors of nCurvesPerMovie without, that are either horizontal,
% vertical, or diagaonial, without running out of space in the grid.

% --- 1. Pick a quadrant at random
q = randi(4);

% --- pick random position within startBox
switch q

    case 1
        startMain = 1;
        endMain = params.n_tvals_main - params.nCurvesPerMovie + 1;
        startOrtho = params.n_tvals_ortho - params.nCurvesPerMovie + 1;
        endOrtho = 
        

    case 2

    case 3

    case 4
end

switch condArray(c).cueMovieOrientation

    case 'horizontal'



    case 'vertical'


    case 'diagonal'
        % set slope of diagonal line based on which quadrant of grid we are
        % starting from
        switch q
            case 1  % upper left, line
                deltaX = 1;
                deltaY = -1;

            case 2
                deltaX = -1;
                deltaY = -1;

            case 3
                deltaX = -1;
                deltaY = 1;

            case 4
                deltaX = 1;
                deltaY = 1;
        end

end


startMain = randi(params.n_tvals_main - params.nCurvesPerMovie);
startOrtho = randi(params.n_tvals_ortho)


% --- BUILD SEQ OF CURVE IMG FILE INDICES TO CONTROL MOVIE
switch params.blockParam

    case 'curveMovieType'

        if strcmp(condArray(c).curveMovieType, 'smooth')
            % set sequeunce of curve images along main manifold

            switch condArray(c).curveMovieDir
                case 1
                    mainSeq = (1:params.nCurvesPerMovie) + startMain;
                case 2
                    mainSeq = (params.nCurvesPerMovie:-1:1) + startMain;
            end

        elseif strcmp(condArray(c).curveMovieType, 'rough')
            mainSeq = randperm(params.nCurvesPerMovie) + startMain;
        else
            error('unknown curveMovieType in generateCurveMovie');
        end

        % --- select single random noise level for all curves in this
        % movie, curve should not jump around
        switch params.curveMovieNoiseMode

            case 'fixed'
                thisOrtho = randi(params.n_tvals_ortho);
                orthoSeq = zeros(1, length(mainSeq)) + thisOrtho;
            case 'dynamic'

            case 'random'
                % --- select n random sequence of integers in range for
                % n_tvals_ortho, with n = length(mainSeq)
                orthoSeq = [];
                for o = 1 : length(mainSeq)
                    thisOrtho = randi(params.n_tvals_ortho);
                    orthoSeq = [orthoSeq thisOrtho];
                end
        end

        bob = 1;



end


% --- add noise (specify location of curves along ortho manifold)

for cs = 1 : length(mainSeq)

    % --- build filename using mainSeq and orthoSeq info
    thisMain = mainSeq(cs);
    thisOrtho = orthoSeq(cs);
    fn = strcat('b', num2str(b), '_s', num2str(s), '_ec_', num2str(thisMain), '_oc_', num2str(thisOrtho),'.png');
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
