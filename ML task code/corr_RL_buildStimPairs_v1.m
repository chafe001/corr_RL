function [stimPairs, noisePairs, ind] = corr_RL_buildStimPairs_v1(stimSpace, params)

% Selects random indices into stimSpace to define stimulus pairs

% 3D stimSpace array, position, angle color
% stimSpace(d1, d2, d3).Position = params.featureDim(1).values(d1, :); % xy pairs
% stimSpace(d1, d2, d3).Angle = params.featureDim(2).values(d2); % degrees
% stimSpace(d1, d2, d3).FaceColor = params.featureDim(3).values(d3, :); % [R G B]
% stimSpace(d1, d2, d3).EdgeColor = params.featureDim(3).values(d3, :); % [R G B]

% --- RANDOMIZE INDICES IN 2nd and 3rd dimensions of stimSpace
d2_rndIndx = randperm(size(stimSpace, 2));
d3_rndIndx = randperm(size(stimSpace, 3));

% --- PERMUTE d2 and d3 random indices to produce a list of random pairings
% of d2 and d3 features to draw from to produce stim and noise pairs
randIndComb = [];
for d2 = 1 : length(d2_rndIndx)
    for d3 = 1 : length(d3_rndIndx)
        randIndx_23(d2,d3).d2Ind = d2_rndIndx(d2);
        randIndx_23(d2,d3).d3Ind = d3_rndIndx(d3);
    end % d2
end % d3


bob = 1;


% --- PICK TWO STIMULI AT RANDOM FOR RIGHT POSITION







% % this code assumes array size = 8
% if params.stimArraySize ~= 8
%     error('buildStimPairs assumes array size 8, modify array or code');
% end
% 
% if params.fixedStimLoc
%     ind.stimIndx = [2 4 6 8];  % diagonal locations
%     ind.noiseIndx = [1 3 5 7]; % locations on cardinal axes
%     % now randomize indices to vary assocaition between stim
%     % location and state
%     ind.stimIndx = ind.stimIndx(randperm(length(ind.stimIndx)));
%     ind.noiseIndx = ind.noiseIndx(randperm(length(ind.noiseIndx)));
% 
%     % create pairs used fixed stimulus locations
%     stimPairs(1).stim1_indx = ind.stimIndx(1);
%     stimPairs(1).stim1_fileName = 'filledCircle.png';
%     stimPairs(1).stim2_indx = ind.stimIndx(2);
%     stimPairs(1).stim2_fileName = 'filledCircle.png';
%     stimPairs(1).pairID = [ind.stimIndx(1), ind.stimIndx(2)];
% 
%     stimPairs(2).stim1_indx = ind.stimIndx(3);
%     stimPairs(2).stim1_fileName = 'filledCircle.png';
%     stimPairs(2).stim2_indx = ind.stimIndx(4);
%     stimPairs(2).stim2_fileName = 'filledCircle.png';
%     stimPairs(2).pairID = [ind.stimIndx(3), ind.stimIndx(4)];
% 
%     stimPairs(3).stim1_indx = ind.stimIndx(1);
%     stimPairs(3).stim1_fileName = 'filledCircle.png';
%     stimPairs(3).stim2_indx = ind.stimIndx(3);
%     stimPairs(3).stim2_fileName = 'filledCircle.png';
%     stimPairs(3).pairID = [ind.stimIndx(1), ind.stimIndx(3)];
% 
%     stimPairs(4).stim1_indx = ind.stimIndx(2);
%     stimPairs(4).stim1_fileName = 'filledCircle.png';
%     stimPairs(4).stim2_indx = ind.stimIndx(4);
%     stimPairs(4).stim2_fileName = 'filledCircle.png';
%     stimPairs(4).pairID = [ind.stimIndx(2), ind.stimIndx(4)];
% 
%     % --- generate noise pairs
%     noisePairs(1).noise1_indx = ind.noiseIndx(1);
%     noisePairs(1).noise1_fileName = 'filledCircle.png';
%     noisePairs(1).noise2_indx = ind.noiseIndx(2);
%     noisePairs(1).noise2_fileName = 'filledCircle.png';
%     noisePairs(1).pairID = [ind.noiseIndx(1), ind.noiseIndx(2)];
% 
%     noisePairs(2).noise1_indx = ind.noiseIndx(3);
%     noisePairs(2).noise1_fileName = 'filledCircle.png';
%     noisePairs(2).noise2_indx = ind.noiseIndx(4);
%     noisePairs(2).noise2_fileName = 'filledCircle.png';
%     noisePairs(2).pairID = [ind.noiseIndx(3), ind.noiseIndx(4)];
% 
%     noisePairs(3).noise1_indx = ind.noiseIndx(1);
%     noisePairs(3).noise1_fileName = 'filledCircle.png';
%     noisePairs(3).noise2_indx = ind.noiseIndx(3);
%     noisePairs(3).noise2_fileName = 'filledCircle.png';
%     noisePairs(3).pairID = [ind.noiseIndx(1), ind.noiseIndx(3)];
% 
%     noisePairs(4).noise1_indx = ind.noiseIndx(2);
%     noisePairs(4).noise1_fileName = 'filledCircle.png';
%     noisePairs(4).noise2_indx = ind.noiseIndx(4);
%     noisePairs(4).noise2_fileName = 'filledCircle.png';
%     noisePairs(4).pairID = [ind.noiseIndx(2), ind.noiseIndx(4)];
% 
% else
%     % --- select 4 integers within range of stimulus size to select 4 stimulus
%     % positions from stimArray at random
%     ind.rndIndx = randperm(params.stimArraySize);
%     % --- divide the randomized index vector into subsets of indices to use for stim pairs
%     % (first 4 elements of randomized vector), and remainder of indices to use for noise pairs
%     ind.stimIndx = ind.rndIndx(1:4);
%     ind.noiseIndx = ind.rndIndx(5:end);
% 
%     % --- use 4 randomly selected stim indices to create 4 crossed pairs
%     stimPairs(1).stim1_indx = ind.stimIndx(1);
%     stimPairs(1).stim1_fileName = 'filledCircle.png';
%     stimPairs(1).stim2_indx = ind.stimIndx(2);
%     stimPairs(1).stim2_fileName = 'filledCircle.png';
%     stimPairs(1).pairID = [ind.stimIndx(1), ind.stimIndx(2)];
% 
%     stimPairs(2).stim1_indx = ind.stimIndx(3);
%     stimPairs(2).stim1_fileName = 'filledCircle.png';
%     stimPairs(2).stim2_indx = ind.stimIndx(4);
%     stimPairs(2).stim2_fileName = 'filledCircle.png';
%     stimPairs(2).pairID = [ind.stimIndx(3), ind.stimIndx(4)];
% 
%     stimPairs(3).stim1_indx = ind.stimIndx(1);
%     stimPairs(3).stim1_fileName = 'filledCircle.png';
%     stimPairs(3).stim2_indx = ind.stimIndx(3);
%     stimPairs(3).stim2_fileName = 'filledCircle.png';
%     stimPairs(3).pairID = [ind.stimIndx(1), ind.stimIndx(3)];
% 
%     stimPairs(4).stim1_indx = ind.stimIndx(2);
%     stimPairs(4).stim1_fileName = 'filledCircle.png';
%     stimPairs(4).stim2_indx = ind.stimIndx(4);
%     stimPairs(4).stim2_fileName = 'filledCircle.png';
%     stimPairs(4).pairID = [ind.stimIndx(2), ind.stimIndx(4)];
% 
%     % --- generate noise pairs
%     noisePairs(1).noise1_indx = ind.noiseIndx(1);
%     noisePairs(1).noise1_fileName = 'filledCircle.png';
%     noisePairs(1).noise2_indx = ind.noiseIndx(2);
%     noisePairs(1).noise2_fileName = 'filledCircle.png';
%     noisePairs(1).pairID = [ind.noiseIndx(1), ind.noiseIndx(2)];
% 
%     noisePairs(2).noise1_indx = ind.noiseIndx(3);
%     noisePairs(2).noise1_fileName = 'filledCircle.png';
%     noisePairs(2).noise2_indx = ind.noiseIndx(4);
%     noisePairs(2).noise2_fileName = 'filledCircle.png';
%     noisePairs(2).pairID = [ind.noiseIndx(3), ind.noiseIndx(4)];
% 
%     noisePairs(3).noise1_indx = ind.noiseIndx(1);
%     noisePairs(3).noise1_fileName = 'filledCircle.png';
%     noisePairs(3).noise2_indx = ind.noiseIndx(3);
%     noisePairs(3).noise2_fileName = 'filledCircle.png';
%     noisePairs(3).pairID = [ind.noiseIndx(1), ind.noiseIndx(3)];
% 
%     noisePairs(4).noise1_indx = ind.noiseIndx(2);
%     noisePairs(4).noise1_fileName = 'filledCircle.png';
%     noisePairs(4).noise2_indx = ind.noiseIndx(4);
%     noisePairs(4).noise2_fileName = 'filledCircle.png';
%     noisePairs(4).pairID = [ind.noiseIndx(2), ind.noiseIndx(4)];
% 
% end



end