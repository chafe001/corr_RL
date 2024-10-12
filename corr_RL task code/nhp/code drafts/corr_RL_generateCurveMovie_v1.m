function [movieImages] = corr_RL_generateCurveMovie_v1(TrialRecord)
% This function returns a cell array, movieImages, that is used to set the
% 'List' property of a imageChanger() object.  This controls the sequence
% of images presented in the movie, which controls the proportion of cue
% and noise pairs included in each movie.

% Version history:
% v1: first effort to use line drawings at stimuli (Dave's code, Thomas'
% algorithm for parametric stimulus space)

% - APPROACH:
% - figure out things needed to specify image filenames by grabbing needed
% information from condArray
% - write movieImages array using these filenames
% - all curves in same block and typ

% ************************************************************************************
% --- if real fx, uncomment the following  lines
condArray = TrialRecord.User.condArray;
c = TrialRecord.CurrentCondition;
params = corr_RL_setParams_v3();
bn = TrialRecord.CurrentBlock;

% --- if mockup, uncomment the following  lines
% [condArray, params] = corr_RL_buildTrials_v3();
% c = 4; % hard code condition number
% bn = 2; % hard code block number

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

% --- RETRIEVE INFORMATION from condArray needed to identify curve image filenames
% stimuli are pregenerated pngs
% need 4 pieces of information to identify the correct image file for this
% condition
% 1. curve type (comb(ined), smooth, rough)
% 2. block number  (saved in TrialRecord)
% 3. curve state (1 or 2, L or R response required)
% 4. sample number (specific curve along manifold)
% example filename:
% 'smooth_b3_c1_s2.png'

% --- RETRIEVE REWARD STATE from condArray, needed for curve number
rs = condArray(c).movieRewState;

% --- RETRIEVE CURVE TYPE from condArray
ct = condArray(c).curveType;

% --- BUILD IMAGE STACK specifying filenames, xy position, codes, times
for cs = 1 : params.nCurveSamples

    % --- FILENAME FOR THIS CURVE PNG FILE
    % continuous sequence of curve images, no blanks in between
    fn = strcat(ct, '_b', num2str(bn), '_c', num2str(rs), '_s', num2str(cs), '.png');
    images{cs} =  {{fn}, [0 0], times.curve_frames, codes.curve_on};

end  % next p

% --- CONCATENATE VARIABLE FRAMES ARRAY INTO movieImages
movieImages = {};
for f = 1 : size(images, 2)
    thisImg = images{1, f};
    movieImages = [movieImages; thisImg]; 
end

bob = 'finished';

end
