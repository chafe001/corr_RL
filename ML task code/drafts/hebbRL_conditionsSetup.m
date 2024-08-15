
% function [condAra, condAraLabel, trialAra, numConds] = seqPred_conditionsSetup(trialSet)
function [condAra, condAraLabel, trialAra, numConds] = seqPred_conditionsSetup()
% --- CONDITIONS organization for seqPred
% This is a struct array
% Each element is an experimental condition
% Each condition defines a cue sequence and a probe
% Idea is that the cue sequence will be classified as A or B
% Classification will be based on presence of specific stimulus pairs (or
% longer runs) embedded in the sequence.
% Stimulus design features:
% 1.  A or B cue class is determined by one or more specific pairs of Gabor
% stimuli presented in a sequence. This recruits associative learning.
% 2. Timing and probability can be manipulated to influence learning rates.
% 3. Sequences can contain mixtures of A and B subsequences in different
% proportion
% 4. Sequences can contain different numbers of noise stimuli that are not
% associated with A or B categories to prevent this being perceptually
% trivial
% 5. We'll use an X-shaped stimulus array, near and far eccentricies, upper
% and lower, left and right quadrants, should drive discriminable activation
% in early visual cortex in fMRI
% 6. Stimulus pairs can appear at same location (different orientations),
% close locations, or far apart locations, requiring learning at different
% levels of the visual system.
% 7. Cue Gabors will be horizontal or vertical
% 8. Probe Gabors will be diagonal left (X-probe) or right (Y-probe)
% 9.  I think I like sequences of rapidly displayed pairs, or triplets or
% quartets, separated by delays, in the cue sequences.  This allows us to
% include working memory and sequence prediction into the structure. Sort
% of nicely hierarchical.

% WE NEED TO SPECIFY for each cue sequence
% 1. Whether we are showing doublets, triplets, or quartets
% 2. How many groups are we presenting.
% 3. Timing between stimuli within groups (in STDP range)
% 4. Timing between groups of stimuli (longer, WM range)
% 5. Stimuli in each group, Gabor orientations (png file name to call), and
% X,Y locations

% WE NEED THE FOLLOWING DATA STRUCTURES TO CONTROL THE SITMULUS SEQUENCES
% 1. Each condition contains an array of groups
% 2. Each group contains an array of gabors
% 3. Each gabor has a location (X, Y), an orientation (45 degree
% increments), a duration (ms), and a spatial frequency.  We can use the
% gabor stimulus generator from ML or just 4 png files loaded from memory.
% 4. The A or B cue status of the sequence


%% -------- SET condAra --------------
% SET stimulus parameters (locations, image fileNames) for conditions
% There are 8 conditions (first pass).
% A1 X
% A2 X
% A1 Y
% A2 Y
% B1 X
% B2 X
% B1 Y
% B2 Y
bob = 4;

params.stimPerSeq = 2;
params.numCond = 8;
params.numCueImg = 2;
params.numProbImg = 2;

params.A1Xreps = 50;
params.A2Xreps = 50;
params.B1Xreps = 50;
params.B2Xreps = 50;
params.A1Yreps = 50;
params.A2Yreps = 50;
params.B1Yreps = 50;
params.B2Yreps = 50;

% --- Stim array in degrees
% near stim
stimPos(1).posXY = [-4 4];
stimPos(1).posLabel = 'UL_near';
stimPos(2).posXY = [4 4];
stimPos(2).posLabel = 'UR_near';
stimPos(3).posXY = [4 -4];
stimPos(3).posLabel = 'LR_near';
stimPos(4).posXY = [-4 -4];
stimPos(4).posLabel = 'LL_near';
% far stim
stimPos(5).posXY = [-8 8];
stimPos(5).posLabel = 'UL_far';
stimPos(6).posXY = [8 8];
stimPos(6).posLabel = 'UR_far';
stimPos(7).posXY = [8 -8];
stimPos(7).posLabel = 'LR_far';
stimPos(8).posXY = [-8 -8];
stimPos(8).posLabel = 'LL_far';

center = [0 0];

cueStimImage(1).fileName = 'gabor_vertical_cue.png';
cueStimImage(1).cueID = 1;
cueStimImage(1).onsetEventCode = 20;
cueStimImage(1).str = 'verticalCue';

cueStimImage(2).fileName = 'gabor_horizontal_cue.png';
cueStimImage(2).cueID = 2;
cueStimImage(2).onsetEventCode = 21;
cueStimImage(2).str = 'horizontalCue';

probeStimImage(1).fileName = 'gabor_X_probe.png';
probeStimImage(1).probeID = 3;
probeStimImage(1).onsetEventCode = 40;
probeStimImage(1).str = 'xProbe';

probeStimImage(2).fileName = 'gabor_Y_probe.png';
probeStimImage(1).probeID = 4;
probeStimImage(1).onsetEventCode = 41;
probeStimImage(1).str = 'yProbe';

% --- BUILD STIM SEQUENCES
% sequences will be random selections of positions and images, defined by a
% set of random indices into the above position and image arrays. Check to
% make sure A1, A2, B1 and B2 are unique sets of random indices, so unique
% sequences of stimuli

% --- RANDOMIZE INDICES FOR A1 STIMULI AND POSITIONS
A1_posIndx = randi(params.numCond, [params.stimPerSeq 1])';
A1_imgIndx = randi(2, [params.stimPerSeq 1])';

indxMat = [A1_posIndx A1_imgIndx];

% --- RANDOMIZE INDICES FOR A2 STIMULI AND POSITIONS, ensure distinct from A1
seqFound = false;
while ~seqFound  % search
    A2_posIndx = randi(params.numCond, [params.stimPerSeq 1])';
    A2_imgIndx = randi(2, [params.stimPerSeq 1])';
    theseIndices = [A2_posIndx A2_imgIndx];
    if ~ismember(theseIndices, indxMat, 'rows')
        seqFound = true;
        indxMat = [indxMat; theseIndices];
    end
end

% --- RANDOMIZE INDICES FOR B1 STIMULI AND POSITIONS, ensure distinct from A1
seqFound = false;
while ~seqFound  % search
    B1_posIndx = randi(params.numCond, [params.stimPerSeq 1])';
    B1_imgIndx = randi(2, [params.stimPerSeq 1])';
    theseIndices = [B1_posIndx B1_imgIndx];
    if ~ismember(theseIndices, indxMat, 'rows')
        seqFound = true;
        indxMat = [indxMat; theseIndices];
    end
end

% --- RANDOMIZE INDICES FOR B2 STIMULI AND POSITIONS, ensure distinct from A1
seqFound = false;
while ~seqFound  % search
    B2_posIndx = randi(params.numCond, [params.stimPerSeq 1])';
    B2_imgIndx = randi(2, [params.stimPerSeq 1])';
    theseIndices = [B2_posIndx B2_imgIndx];
    if ~ismember(theseIndices, indxMat, 'rows')
        seqFound = true;
        indxMat = [indxMat; theseIndices];
    end
end

% --- USE RANDOM INDICES TO SET A1, A2, B1, B2 STIM SEQUENCES

% --- SET COND 1: A1 cue sequence, X probe
condAra(1).cueCat = 1; % A cue
condAra(1).cueSeq = 1; % A1 cue
condAra(1).cueLabel = 'A1';
condAra(1).probeType = 1; % X probe
condAra(1).probeLabel = 'X';
condAra(1).probe.fileName = 'xProbe.png';
condAra(1).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(1).cueStim(s).fileName = cueStimImage(A1_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(1).cueStim(s).posXY = stimPos(A1_posIndx(s)).posXY;
    % set stimulus position label
    condAra(1).cueStim(s).posLabel = stimPos(A1_posIndx(s)).posLabel;
end

% --- SET COND 2: A2 cue sequence, X probe
condAra(2).cueCat = 1; % A cue
condAra(2).cueSeq = 2; % A2 cue
condAra(2).cueLabel = 'A2';
condAra(2).probeType = 1; % X probe
condAra(2).probeLabel = 'X';
condAra(2).probe.fileName = 'xProbe.png';
condAra(2).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(2).cueStim(s).fileName = cueStimImage(A2_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(2).cueStim(s).posXY = stimPos(A2_posIndx(s)).posXY;
    % set stimulus position label
    condAra(2).cueStim(s).posLabel = stimPos(A2_posIndx(s)).posLabel;
end

% --- SET COND 3: B1 cue sequence, X probe
condAra(3).cueCat = 2; % B cue
condAra(3).cueSeq = 3; % B1 cue
condAra(3).cueLabel = 'B1';
condAra(3).probeType = 1; % X probe
condAra(3).probeLabel = 'X';
condAra(3).probe.fileName = 'xProbe.png';
condAra(3).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(3).cueStim(s).fileName = cueStimImage(B1_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(3).cueStim(s).posXY = stimPos(B1_posIndx(s)).posXY;
    % set stimulus position label
    condAra(3).cueStim(s).posLabel = stimPos(B1_posIndx(s)).posLabel;
end

% --- SET COND 4: B2 cue sequence, X probe
condAra(4).cueCat = 2; % B cue
condAra(4).cueSeq = 4; % B2 cue
condAra(4).cueLabel = 'B2';
condAra(4).probeType = 1; % X probe
condAra(4).probeLabel = 'X';
condAra(4).probe.fileName = 'xProbe.png';
condAra(4).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(4).cueStim(s).fileName = cueStimImage(B2_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(4).cueStim(s).posXY = stimPos(B2_posIndx(s)).posXY;
    % set stimulus position label
    condAra(4).cueStim(s).posLabel = stimPos(B2_posIndx(s)).posLabel;
end







% --- SET COND 5: A1 cue sequence, Y probe
condAra(5).cueCat = 1; % A cue
condAra(5).cueSeq = 1; % A1 cue
condAra(5).cueLabel = 'A1';
condAra(5).probeType = 2; % Y probe
condAra(5).probeLabel = 'Y';
condAra(5).probe.fileName = 'yProbe.png';
condAra(5).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(5).cueStim(s).fileName = cueStimImage(A1_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(5).cueStim(s).posXY = stimPos(A1_posIndx(s)).posXY;
    % set stimulus position label
    condAra(5).cueStim(s).posLabel = stimPos(A1_posIndx(s)).posLabel;
end

% --- SET COND 6: A2 cue sequence, Y probe
condAra(6).cueCat = 1; % A cue
condAra(6).cueSeq = 2; % A2 cue
condAra(6).cueLabel = 'A2';
condAra(6).probeType = 2; % Y probe
condAra(6).probeLabel = 'Y';
condAra(6).probe.fileName = 'yProbe.png';
condAra(6).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(2).cueStim(s).fileName = cueStimImage(A2_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(2).cueStim(s).posXY = stimPos(A2_posIndx(s)).posXY;
    % set stimulus position label
    condAra(2).cueStim(s).posLabel = stimPos(A2_posIndx(s)).posLabel;
end

% --- SET COND 7: B1 cue sequence, Y probe
condAra(7).cueCat = 2; % B cue
condAra(7).cueSeq = 3; % B1 cue
condAra(7).cueLabel = 'B1';
condAra(7).probeType = 2; % Y probe
condAra(7).probeLabel = 'Y';
condAra(7).probe.fileName = 'yProbe.png';
condAra(7).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(7).cueStim(s).fileName = cueStimImage(B1_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(7).cueStim(s).posXY = stimPos(B1_posIndx(s)).posXY;
    % set stimulus position label
    condAra(7).cueStim(s).posLabel = stimPos(B1_posIndx(s)).posLabel;
end

% --- SET COND 8: B2 cue sequence, Y probe
condAra(8).cueCat = 2; % B cue
condAra(8).cueSeq = 4; % B2 cue
condAra(8).cueLabel = 'B2';
condAra(8).probeType = 2; % Y probe
condAra(8).probeLabel = 'Y';
condAra(8).probe.fileName = 'yProbe.png';
condAra(8).probe.pos = 'center';
for s = 1 : params.stimPerSeq
    % set stimulus image
    condAra(8).cueStim(s).fileName = cueStimImage(B2_imgIndx(s)).fileName;
    % set stimulus position XY coordinates
    condAra(8).cueStim(s).posXY = stimPos(B2_posIndx(s)).posXY;
    % set stimulus position label
    condAra(8).cueStim(s).posLabel = stimPos(B2_posIndx(s)).posLabel;
end



condAraLabel = 'seqPred_condAra_8';


%% -------- BUILD TRIAL STACK AND ADD TO TRIAL RECORD (user vars) --------

% TRIAL STACK is built from the condition array, replicating each condition
% according to the number of trials with that condition in the stack.

trialAra =[];

% --- CONDITIONS FILE STRUCTURE
% this is how condition number and stimulus combinations are paired in the
% conditions file, defines stimuli to show for each condition number
% cond 1: params.A1Xreps = 50;
% cond 2: params.A2Xreps = 50;
% cond 3: params.B1Xreps = 50;
% cond 4: params.B2Xreps = 50;
% cond 5: params.A1Yreps = 50;
% cond 6: params.A2Yreps = 50;
% cond 7: params.B1Yreps = 50;
% cond 8: params.B2Yreps = 50;

% --- BUILD TRIAL ARRAY VECTOR
% this is a vector of integers corresponding to the condition numbers we
% want to present for the number of trials we wish to present. 

A1Xvect = zeros(1, params.A1Xreps) + 1;
A2Xvect = zeros(1, params.A2Xreps) + 2;
B1Xvect = zeros(1, params.B1Xreps) + 3;
B2Xvect = zeros(1, params.B2Xreps) + 4;
A1Yvect = zeros(1, params.A1Yreps) + 5;
A2Yvect = zeros(1, params.A2Yreps) + 6;
B1Yvect = zeros(1, params.B1Yreps) + 7;
B2Yvect = zeros(1, params.B2Yreps) + 8;

trialAra = [A1Xvect A2Xvect B1Xvect B2Xvect A1Yvect A2Yvect B1Yvect B2Yvect];

trialAraLabel = 'seqPred_trialAra';

numConds = params.numCond;

bob = 1;

end

