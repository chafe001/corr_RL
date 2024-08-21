
function [movieFrames] = HebbRL_generateStimMovie(TrialRecord)

c = TrialRecord.CurrentCondition;

% retrieve (make local copies of) variables from TrialRecord
conditions = TrialRecord.User.conditions;
params = TrialRecord.User.params;
stimPos = TrialRecord.User.stimPos;
stimImage = TrialRecord.User.stimImage;

pairSequence = zeros(params.maxPairReps, 1);
numTargetPairs = conditions(c).pair.reps;
targetPairs = randperm(params.maxPairReps, numTargetPairs);
% set movieFrames flags to 1 to present target pair
pairSequence(targetPairs) = 1;
dur = 3; % in screen refreshes, here for now...

% init movieFrames
movieFrames = [];

fs = TrialRecord.User.eventCodes.startMovie;

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
            case 1 % stim 1 then 2
                pairFrame1 = {{conditions(c).pair.stim1.img.fileName}, conditions(c).pair.stim1.pos.posXY, dur, fs + fc};
                pairFrame2 = {[], [], conditions(c).pair.soa, fs + fc + 1};
                pairFrame3 = {{conditions(c).pair.stim2.img.fileName}, conditions(c).pair.stim2.pos.posXY, dur, fs + fc + 2};
                pairFrame4 = {[], [], conditions(c).pair.interPair, fs + fc + 3};
            case 2 % stim 2 then 1
                pairFrame1 = {{conditions(c).pair.stim2.img.fileName}, conditions(c).pair.stim2.pos.posXY, dur, fs + fc};
                pairFrame2 = {[], [], conditions(c).pair.soa, fs + fc + 1};
                pairFrame3 = {{conditions(c).pair.stim1.img.fileName}, conditions(c).pair.stim1.pos.posXY, dur, fs + fc + 2};
                pairFrame4 = {[], [], conditions(c).pair.interPair, fs + fc + 3};
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
        pairFrame2 = {[], [], conditions(c).pair.soa, fs + fc + 1};
        pairFrame3 = {{stim2_rndImg.fileName}, stim2_rndPos.posXY, dur, fs + fc + 2};
        pairFrame4 = {[], [], conditions(c).pair.interPair, fs + fc + 3};

    end

    bob = 1;

    % aggregate the 4 frames for this pair together
    pairFrames = {pairFrame1{:}; pairFrame2{:}; pairFrame3{:}; pairFrame4{:}};
    movieFrames = [movieFrames; pairFrames];

end  % for p = 1 : size(pairSequence, 1)

bob = 'finished';

end


