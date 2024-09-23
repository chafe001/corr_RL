function [blockStim] = corr_RL_sampleStimSpace_v2(params)
% corr_RL_sampleStimSpace defines the stimulus feature values of stimuli
% for this block

% The algorithm generates a list of stimuli with all possible combinations
% of the two feature dimensions specified in params, randomizes the list,
% selects the first 4 of these stimuli as cue stimuli for the block, and
% the next 4 stimuli as noise stimuli for the block, and returns these in
% blockstim.

% VERSION HISTORY

% v1: initial effort, easyStim enabled to ensure all cue stimuli have
% different orientations to make perceptual discrimination easier, however
% this reduces the task to 1D (orientation), making color a distractor
% feature. Used up through corr_RL v4. Algorithm needs to specify 4 cue stim
% and 4 noise stim, so combination of feature dimensions has to produce 8 stimuli
% at a minimum

% v2: written at time of corr_RL v5 development.  Switching from xCorr to randomized list algorithm
% to define correlation patterns defining state.

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

% --- ADD ID NUM to each stim to keep track of stim through process
for s = 1 : size(randStim, 1)
    randStim(s).id = s;
end

% --- SET BLOCKSTIM (cue stim and noise stim)
for cs = 1 : params.numCueStim
    blockStim.cue(cs).EdgeColor = randStim(cs).FaceColor;
    blockStim.cue(cs).FaceColor = randStim(cs).FaceColor;
    blockStim.cue(cs).Size = params.Size;
    blockStim.cue(cs).Angle = randStim(cs).Angle;
    blockStim.cue(cs).FileName = findFileName(randStim(cs));
    blockStim.cue(cs).id = randStim(cs).id;
end

for ns = 1 : (length(randStim) - params.numCueStim)
    rndIndx = ns + params.numCueStim;
    blockStim.noise(ns).EdgeColor = randStim(rndIndx).FaceColor;
    blockStim.noise(ns).FaceColor = randStim(rndIndx).FaceColor;
    blockStim.noise(ns).Size = params.Size;
    blockStim.noise(ns).Angle = randStim(rndIndx).Angle;
    blockStim.noise(ns).FileName = findFileName(randStim(rndIndx));
    blockStim.noise(ns).id = randStim(rndIndx).id;
end


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
