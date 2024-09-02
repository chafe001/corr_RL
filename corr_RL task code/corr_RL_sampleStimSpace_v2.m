function [blockStim] = corr_RL_sampleStimSpace_v2(params)
% corr_RL_sampleStimSpace defines the stimulus feature values of stimuli
% for this block

% The algorithm generates a list of stimuli with all possible combinations
% of the two feature dimensions specified in params, randomizes the list,
% selects the first 4 of these stimuli as cue stimuli for the block, and
% the next 4 stimuli as noise stimuli for the block, and returns these in
% blockstim.

% the easyStim flag ensures that cue stimuli all have different
% orientations to make perceptual discrimination easier. (It seemed harder
% to make discriminations between two stimuli that had the same orientation
% but different only in color).

% Algorithm needs to specify 4 cue stim and 4 noise stim, so combination of
% feature dimensions has to produce 8 stimuli at a minimum

% --- COMPUTE DIMENSIONS OF FEATURE SPACE
numAngles = size(params.Angles, 2);
numColors = size(params.FaceColors, 1);

% --- PERMUTE FEATURES
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

% --- left cue 1
blockStim.cue(1, 1).EdgeColor = randStim(1).FaceColor;
blockStim.cue(1, 1).FaceColor = randStim(1).FaceColor;
blockStim.cue(1, 1).Size = params.Size;
blockStim.cue(1, 1).Position = params.leftPos;
blockStim.cue(1, 1).Angle = randStim(1).Angle;
blockStim.cue(1, 1).FileName = findFileName(randStim(1));

% --- left cue 2
blockStim.cue(1, 2).EdgeColor = randStim(2).FaceColor;
blockStim.cue(1, 2).FaceColor = randStim(2).FaceColor;
blockStim.cue(1, 2).Size = params.Size;
blockStim.cue(1, 2).Position = params.leftPos;
blockStim.cue(1, 2).Angle = randStim(2).Angle;
blockStim.cue(1, 2).FileName = findFileName(randStim(2));

% --- right cue 1
blockStim.cue(2, 1).EdgeColor = randStim(3).FaceColor;
blockStim.cue(2, 1).FaceColor = randStim(3).FaceColor;
blockStim.cue(2, 1).Size = params.Size;
blockStim.cue(2, 1).Position = params.rightPos;
blockStim.cue(2, 1).Angle = randStim(3).Angle;
blockStim.cue(2, 1).FileName = findFileName(randStim(3));

% --- right cue 2
blockStim.cue(2, 2).EdgeColor = randStim(4).FaceColor;
blockStim.cue(2, 2).FaceColor = randStim(4).FaceColor;
blockStim.cue(2, 2).Size = params.Size;
blockStim.cue(2, 2).Position = params.rightPos;
blockStim.cue(2, 2).Angle = randStim(4).Angle;
blockStim.cue(2, 2).FileName = findFileName(randStim(4));


bob = 1;

end

% ----------------------- UTILITY FXs ---------------------------

function fileName = findFileName(inStim)

RGB_str = num2str(inStim.FaceColor);
% remove extra spaces in RGB triplet
RGB_str(isspace(RGB_str)) = [];

angle_str = num2str(inStim.Angle);




fileName = strcat('ang_', angle_str, '_rgb_', RGB_str, '.png');


end
