function [blockStim] = corr_RL_sampleStimSpace_v1(params)
% corr_RL_sampleStimSpace defines the stimulus feature values of stimuli
% for this block

% Each block we need to sample 8 stimuli from feature space
% - 2 cue stimuli for left screen location
% - 2 noise stimuli for left screen location
% - 2 cue stimuli for right screen location
% - 2 noise stimuli for right screen location

% We will hold feature spacing between the four stimuli at left and right
% screen locations fixed so that blocks don't vary much in perceptual 
% difficulty discriminating the stimuli
% 
% Typical feature values, set in buildTrials
% params.variableDim(1).label = 'Angle';
% params.variableDim(1).values = [0 45 90 135];
% params.variableDim(2).label = 'FaceColor';
% params.variableDim(2).values = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white
% params.Size = [1 4]; % [width height] in degrees
% params.Scale = [1 1]; % Magnification. 1, by default [x_scale y_scale].

% --- RANDMIZE ANGLE IF ENABLED
if params.randAngle
    % --- select one angle shift to apply to all angles to keep angle
    % spacing constant
    thisAngleShift = randi(5) * params.angleShift;
    params.Angles = params.Angles + thisAngleShift;
end  

% --- PERMUTE angles and colors
numAngles = size(params.Angles, 2);
numColors = size(params.FaceColors, 1);
for a = 1:numAngles
    for c = 1:numColors
        stim(a, c).Angle = params.Angles(a);     
        stim(a, c).FaceColor = params.FaceColors(c, :);
    end
end

% --- CONVERT 2D to 1D matrix
allStim = reshape(stim, [(numAngles * numColors), 1]);

% --- RANDOMLY PERMUTE 1D matrix to randomize cue and noise stimuli
randStim = allStim(randperm(size(allStim, 1)), :);




% --- SET BLOCKSTIM
% params required for BoxGraphic
% stim.EdgeColor = [R G B]
% stim.FaceColor = [R G B]
% stim.size = [WIDTH HEIGHT]
% stim.Position = [X Y]
% stim.Scale = [xScale, yScale], 1 by default
% stim.Angle = Rotation in degrees
% stim.Zorder = 0 (back) by default

% params.variableDim(2).label = 'FaceColor';
% params.variableDim(2).values = [1 0 0; 0 0 1; 0 0 0; 1 1 1];  % red, blue, black, white

% blockStim.left_cue1.EdgeColor = randStim(1).
% blockStim.left_cue1.FaceColor = 




bob = 1;




% --- SELECT 8 random indices into the feature matrix 





% --- Define stim struct
% Based on input parameters for boxGraphic()



% --- SET FEATURE DIMENSIONS AND VALUES
% loop through feature value vectors to produce all combinations
% omit position which will be controlled outside of this function
% params.featureDim(1).label = 'Angle';
% params.featureDim(1).values = [0 45 90 135];
% params.featureDim(2).label = 'FaceColor';
% params.featureDim(2).values = [1 0 0; 1 1 0; 1 0.5 0; 0.5 0 1; 0 0 1];  % red, yellow, orange, purple, blue


bob = 1;

end