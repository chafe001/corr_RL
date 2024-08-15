function [movieFrames] = framesTask_generateStimMovie_v2(TrialRecord)

c = TrialRecord.CurrentCondition;

% retrieve (make local copies of) variables from TrialRecord
conditions = TrialRecord.User.conditions;
params = TrialRecord.User.params;
stimPos = TrialRecord.User.stimPos;
stimImage = TrialRecord.User.stimImage;

pairSequence = zeros(params.maxPairReps, 1);
numTargetPairs = conditions(c).pair.reps;
% randomly select which pairs in sequence will be signal pairs and which noise
% pairs
% p = randperm(n,k) returns a row vector containing k unique integers selected randomly from 1 to n.
signalPairs = randperm(params.maxPairReps, numTargetPairs);
% set movieFrames flags to 1 to present target pair
pairSequence(signalPairs) = 1;
dur = 3; % in screen refreshes, here for now...

% init movieFrames
movieFrames = [];

% initialize fs, 'first stim', event code to increment as eacth stim is shown
fs = TrialRecord.User.eventCodes.startMovie;

% select soa within range for this pair.  Set soa outside of loop setting
% pair params so all pairs in this movie get the same soa (soa is a
% property of the trial, the range a property of the block).
minSoa = conditions(c).pair.soaRange(1); % in screen refresh units
maxSoa = conditions(c).pair.soaRange(2);
if (minSoa == 0) && (maxSoa == 0) % check whether minSoa and maxSoa are 0 (shortest possible interval)
    pairSoa = 0;
elseif minSoa == maxSoa % check whether minSoa == maxSoa (fixed interval)
    pairSoa = minSoa;
else % select soa at random within specified range for this pair
    % X = randi([imin,imax],___) returns an array containing integers drawn from the discrete uniform distribution on the interval [imin,imax],
    pairSoa = randi([minSoa, maxSoa]);
end



% build stim pairs with intervening and following blank
for p = 1 : size(pairSequence, 1)

    % set up a frame counter that increments by 5 frames, since there are 4
    % frames per stimulus pair, and the loop counts by pair number
    fc = ((p-1) * 4) + 1;

    % define the 4 frames associated with each pair, stim1, blank, stim2,
    % blank
    if pairSequence(p) == 1  % target pair
        switch conditions(c).pair.order
            % these lines have format required by ImageChanger, will
            % concatenate lines to form the movie
            case 'fixed'
                pairFrame1 = {{conditions(c).pair.stim1.img.fileName}, conditions(c).pair.stim1.pos.posXY, dur, fs + fc};
                pairFrame2 = {[], [], pairSoa, fs + fc + 1};
                pairFrame3 = {{conditions(c).pair.stim2.img.fileName}, conditions(c).pair.stim2.pos.posXY, dur, fs + fc + 2};
                pairFrame4 = {[], [], conditions(c).interPair, fs + fc + 3};
            case 'random'
                flipCoin = randi(2);

                if flipCoin == 1
                    pairFrame1 = {{conditions(c).pair.stim1.img.fileName}, conditions(c).pair.stim1.pos.posXY, dur, fs + fc};
                    pairFrame2 = {[], [], pairSoa, fs + fc + 1};
                    pairFrame3 = {{conditions(c).pair.stim2.img.fileName}, conditions(c).pair.stim2.pos.posXY, dur, fs + fc + 2};
                    pairFrame4 = {[], [], conditions(c).interPair, fs + fc + 3};
                else
                    pairFrame1 = {{conditions(c).pair.stim2.img.fileName}, conditions(c).pair.stim2.pos.posXY, dur, fs + fc};
                    pairFrame2 = {[], [], pairSoa, fs + fc + 1};
                    pairFrame3 = {{conditions(c).pair.stim1.img.fileName}, conditions(c).pair.stim1.pos.posXY, dur, fs + fc + 2};
                    pairFrame4 = {[], [], conditions(c).interPair, fs + fc + 3};

                end


        end

    else % noise pair

        stim1_found = false;
        while ~stim1_found
            % select random image and position for stim1
            stim1_rndPos = stimPos(randi(size(stimPos, 2)));
            stim1_rndImg = stimImage(randi(size(stimImage, 2)));
            % make sure stim1_rndPos is not in the target pair
            if ~isequal(stim1_rndPos, conditions(c).pair.stim1.pos) && ~isequal(stim1_rndPos, conditions(c).pair.stim2.pos)
                stim1_found = true;
            end
        end

        stim2_found = false;
        while ~stim2_found
            % select random image and position for stim2
            stim2_rndPos = stimPos(randi(size(stimPos, 2)));
            stim2_rndImg = stimImage(randi(size(stimImage, 2)));
            % make sure neither of these stim are one of the stimuli in the
            % target pair based on position only (ok for noise pair if same image,
            % but different location from target pair)
            if ~isequal(stim2_rndPos, stim1_rndPos) && ~isequal(stim2_rndPos, conditions(c).pair.stim1.pos) && ~isequal(stim1_rndPos, conditions(c).pair.stim2.pos)
                stim2_found = true;
            end

        end

        pairFrame1 = {{stim1_rndImg.fileName}, stim1_rndPos.posXY, dur, fs + fc};
        pairFrame2 = {[], [], pairSoa, fs + fc + 1};
        pairFrame3 = {{stim2_rndImg.fileName}, stim2_rndPos.posXY, dur, fs + fc + 2};
        pairFrame4 = {[], [], conditions(c).interPair, fs + fc + 3};

    end

    bob = 1;

    % aggregate the 4 frames for this pair together
    pairFrames = {pairFrame1{:}; pairFrame2{:}; pairFrame3{:}; pairFrame4{:}};
    movieFrames = [movieFrames; pairFrames];

end  % for p = 1 : size(pairSequence, 1)

bob = 'finished';

end


