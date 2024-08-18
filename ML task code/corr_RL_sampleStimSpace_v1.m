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

% params required for BoxGraphic
% stim.EdgeColor = [R G B]
% stim.FaceColor = [R G B]
% stim.size = [WIDTH HEIGHT]
% stim.Position = [X Y]
% stim.Scale = [xScale, yScale], 1 by default
% stim.Angle = Rotation in degrees
% stim.Zorder = 0 (back) by default

% --- SET BLOCKSTIM

% --- set individual ue and noise stimulus parameters

% --- left cue 1
blockStim.cue(1, 1).EdgeColor = randStim(1).FaceColor;
blockStim.cue(1, 1).FaceColor = randStim(1).FaceColor;
blockStim.cue(1, 1).Size = params.Size;
blockStim.cue(1, 1).Position = params.leftPos;
blockStim.cue(1, 1).Angle = randStim(1).Angle;
% --- left cue 2
blockStim.cue(1, 2).EdgeColor = randStim(2).FaceColor;
blockStim.cue(1, 2).FaceColor = randStim(2).FaceColor;
blockStim.cue(1, 2).Size = params.Size;
blockStim.cue(1, 2).Position = params.leftPos;
blockStim.cue(1, 2).Angle = randStim(2).Angle;
% --- right cue 1
blockStim.cue(2, 1).EdgeColor = randStim(3).FaceColor;
blockStim.cue(2, 1).FaceColor = randStim(3).FaceColor;
blockStim.cue(2, 1).Size = params.Size;
blockStim.cue(2, 1).Position = params.leftPos;
blockStim.cue(2, 1).Angle = randStim(3).Angle;
% --- right cue 2
blockStim.cue(2, 2).EdgeColor = randStim(4).FaceColor;
blockStim.cue(2, 2).FaceColor = randStim(4).FaceColor;
blockStim.cue(2, 2).Size = params.Size;
blockStim.cue(2, 2).Position = params.leftPos;
blockStim.cue(2, 2).Angle = randStim(4).Angle;

% --- left noise 1
blockStim.noise(1, 1).EdgeColor = randStim(5).FaceColor;
blockStim.noise(1, 1).FaceColor = randStim(5).FaceColor;
blockStim.noise(1, 1).Size = params.Size;
blockStim.noise(1, 1).Position = params.leftPos;
blockStim.noise(1, 1).Angle = randStim(5).Angle;
% --- left noise 2
blockStim.noise(1, 2).EdgeColor = randStim(6).FaceColor;
blockStim.noise(1, 2).FaceColor = randStim(6).FaceColor;
blockStim.noise(1, 2).Size = params.Size;
blockStim.noise(1, 2).Position = params.leftPos;
blockStim.noise(1, 2).Angle = randStim(6).Angle;
% --- right noise 1
blockStim.noise(2, 1).EdgeColor = randStim(7).FaceColor;
blockStim.noise(2, 1).FaceColor = randStim(7).FaceColor;
blockStim.noise(2, 1).Size = params.Size;
blockStim.noise(2, 1).Position = params.leftPos;
blockStim.noise(2, 1).Angle = randStim(7).Angle;
% --- right noise 2
blockStim.noise(2, 2).EdgeColor = randStim(8).FaceColor;
blockStim.noise(2, 2).FaceColor = randStim(8).FaceColor;
blockStim.noise(2, 2).Size = params.Size;
blockStim.noise(2, 2).Position = params.leftPos;
blockStim.noise(2, 2).Angle = randStim(8).Angle;

bob = 1;



end