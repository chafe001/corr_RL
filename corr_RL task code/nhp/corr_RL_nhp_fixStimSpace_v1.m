function [blockStim] = corr_RL_nhp_fixStimSpace_v1(params)
% corr_RL_sampleStimSpace defines the stimulus feature values of stimuli
% for this block

% The algorithm generates a list of stimuli with all possible combinations
% of the two feature dimensions specified in params, randomizes the list,
% selects the first 4 of these stimuli as cue stimuli for the block, and
% the next 4 stimuli as noise stimuli for the block, and returns these in
% blockstim.

% --- COMPUTE ALL COMBINATIONS OF ANGLES AND COLORS
for a = 1:params.numAngles
    for c = 1:params.numColors
        stim(a, c).Angle = params.Angles(a);
        stim(a, c).FaceColor = params.FaceColors(c, :);
    end
end

% --- CONVERT 2D to 1D matrix
allStim = reshape(stim, [(params.numAngles * params.numColors), 1]);

% --- ADD ID NUM to each stim to keep track of stim through process
for s = 1 : size(allStim, 1)
    allStim(s).id = s;
end

% --- SET BLOCKSTIM (cue stim and noise stim)
for cs = 1 : params.numCueStim
    blockStim.cue(cs).EdgeColor = allStim(cs).FaceColor;
    blockStim.cue(cs).FaceColor = allStim(cs).FaceColor;
    blockStim.cue(cs).Angle = allStim(cs).Angle;
    blockStim.cue(cs).FileName = findFileName(allStim(cs));
    blockStim.cue(cs).id = allStim(cs).id;
end

for ns = 1 : (length(allStim) - params.numCueStim)
    rndIndx = ns + params.numCueStim;
    blockStim.noise(ns).EdgeColor = allStim(rndIndx).FaceColor;
    blockStim.noise(ns).FaceColor = allStim(rndIndx).FaceColor;
    blockStim.noise(ns).Angle = allStim(rndIndx).Angle;
    blockStim.noise(ns).FileName = findFileName(allStim(rndIndx));
    blockStim.noise(ns).id = allStim(rndIndx).id;
end

bob = 1;

end

% ----------------------- UTILITY FXs ---------------------------

function fileName = findFileName(inStim)

RGB_str = num2str(inStim.FaceColor);
% remove extra spaces in RGB triplet
RGB_str(isspace(RGB_str)) = [];

angle_str = num2str(inStim.Angle);

% fileName = strcat('ang_', angle_str, '_rgb_', RGB_str, '_large.png');


fileName = strcat('ang_', angle_str, '_rgb_', RGB_str, '.png');


end
