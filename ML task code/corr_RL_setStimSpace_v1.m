function [stimSpace, params] = corr_RL_setStimSpace_v1(params)

% buildStim sets the combinations of stimulus features that define the
% stimSpace.  stimSpace has number of dimensions equal to the number of
% features dimensions that are varied to produce the stimuli. 'pos' is the
% first feature dimension by default

% --- DEFINE AND INITIALIZE STIM STRUCT
% Feature dimensions definiting stimulus appearance
% Modeled on input parameters for boxGraphic(), add
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
% this discretizes feature space
params.featureDim(1).label = 'Position';
params.featureDim(1).values = [-4 0; 4 0]; % xy pairs
params.featureDim(2).label = 'Angle';
params.featureDim(2).values = [0 45 90 135];
params.featureDim(3).label = 'FaceColor';
params.featureDim(3).values = [1 0 0; 1 1 0; 1 0.5 0; 0.5 0 1; 0 0 1];  % red, yellow, orange, purple, blue

for d1 = 1 : size(params.featureDim(1).values, 1) % by rows of dim1, xy pairs

    for d2 = 1 : size(params.featureDim(2).values, 2) % by cols of dim2, angles

        for d3 = 1 : size(params.featureDim(3).values, 1) % by rows of dim3, colors

            stimSpace(d1, d2, d3).Position = params.featureDim(1).values(d1, :);
            stimSpace(d1, d2, d3).Angle = params.featureDim(2).values(d2);
            stimSpace(d1, d2, d3).FaceColor = params.featureDim(3).values(d3, :);
            stimSpace(d1, d2, d3).EdgeColor = params.featureDim(3).values(d3, :); % Edge and Face colors same

        end  % for d1
        
    end % for d2

end % for d3

bob = 1;

end