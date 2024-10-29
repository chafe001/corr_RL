function [stimSpace, params] = corr_RL_setStimSpace_v1(params)

% setStimSpace defines the stimulus parameters and ranges, and permutes
% them to produce all combinations of values specified.  This determines
% the total range of stimuli that will be selected from to produce trials.

% This discretizes the values and combinations of stimulus parameters

% For random sampling of stimuli from space, increase granularity of
% feature value vectors to approach a continuous sampling

% --- DEFINE AND INITIALIZE STIM STRUCT
% Feature dimensions defining stimulus appearance
% Based on input parameters for boxGraphic(), add
% other dims for other graphics functions if needed
stim.EdgeColor = NaN; % [R G B]
stim.FaceColor = NaN; % [R G B]
stim.size = NaN; % [WIDTH HEIGHT]
stim.Position = NaN; % [X Y]
stim.Scale = NaN; % [xScale, yScale]
stim.Angle = NaN; % Rotation in degrees
stim.Zorder = NaN; % 0 (back) by default.

% --- SET FEATURE DIMENSIONS AND VALUES
% loop through feature value vectors to produce all combinations
% omit position which will be controlled outside of this function
params.featureDim(1).label = 'Angle';
params.featureDim(1).values = [0 45 90 135];
params.featureDim(2).label = 'FaceColor';
params.featureDim(2).values = [1 0 0; 1 1 0; 1 0.5 0; 0.5 0 1; 0 0 1];  % red, yellow, orange, purple, blue

% NOTE: dimensions specified in this loop will have to be adjusted if the
% stimulus feature dimensions change
for d1 = 1 : size(params.featureDim(1).values, 2) % by rows of dim1, xy pairs
    for d2 = 1 : size(params.featureDim(2).values, 1) % by cols of dim2, angles
      
            stimSpace(d1, d2).dim1_label = params.featureDim(1).label;
            stimSpace(d1, d2).dim1_vals = params.featureDim(1).values(d1);
            stimSpace(d1, d2).dim2_label = params.featureDim(2).label;
            stimSpace(d1, d2).dim2_vals = params.featureDim(2).values(d2, :);
  
    end % for d2
end % for d3

bob = 1;

end