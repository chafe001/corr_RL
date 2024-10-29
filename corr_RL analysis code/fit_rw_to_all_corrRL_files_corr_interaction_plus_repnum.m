% based on:
%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 3 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"

narms = 4; % model choices as a total of 4, L/R for each of the two stimuli in a block
% narms = 2; % model choices as just either left or right

LB = [0 0 -Inf -Inf -Inf]; % loweer bounds (alpha beta alpha_interaction beta_interaction_corr beta_interaction_rep)
UB = [2 Inf Inf Inf Inf]; % upper bounds
% LB = [0 0 ]; % loweer bounds (alpha beta)
% UB = [2 Inf]; % upper bounds

% set fmincon options
% options=optimset('MaxIterations', 10000, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');
% options=optimoptions('fmincon', 'MaxIterations', 10000, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');
options=optimoptions('fmincon', 'MaxIterations', 400, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');

load('D:\code\tasks\corr_RL\matt_24_10_22.mat');
data = bData; % rename
corrconditions = unique(data(:,stdcol.cuePercent));
cue_shown = mod(data(:, stdcol.cond)+1,2)+1; % cues are labeled 1,2 then 3,4, then 4,5 etc.  change all to 1,2 (which should match responseKey)
data(:,stdcol.cond) = cue_shown; % replace

% create a column indicating hown many times the subject has seen a valid (unbroken) pair of a particular set: call it nstimviews
% (there are numCueStim pairs associated with each response direction in each block, shown for numCueReps minus broken pairs:
% numNoisePairs = round((1 - condArray(c).cuePercent) * length(pairSeq)); % from corr_RL_generageBarMovie_v2.m
nstimviews = [];

% file may have multiple runs with blocks repeated - find resets
resets = find(diff(data(:,stdcol.block)) < 0);
for rr = 1 : numel(resets)
    data(resets(rr)+1:end,stdcol.block) = data(resets(rr)+1:end,stdcol.block) + 1000;
end

blocks = unique(data(:,stdcol.block));


for bb = 1 : numel(blocks)
    thisblock = data(data(:,stdcol.block) == blocks(bb), :);
    thisblockviews = zeros(size(thisblock,1), 1);

    for cc = 1 : 2 % two cues
        cuerows = find(thisblock(:,stdcol.cond) == cc);
        these_stimuli = thisblock(cuerows, stdcol.firstPairSeq:end);
        nviews = sum(these_stimuli' < 10)'; % singletons are the cue num plus either 10 or 20, pairs are single digit
        nviews = cumsum(nviews); % accumulate views accross trials
        thisblockviews(cuerows) = nviews;
    end
    nstimviews = [nstimviews; thisblockviews];

end % for each block

if (narms == 2)
    choice = data(:,stdcol.responseKey);
elseif (narms == 4)
    choice = ones(size(data(:,1)))*-1;
    choice(data(:,stdcol.rewardState) == 1 & data(:,stdcol.choseCorrect) == 0) = 1;
    choice(data(:,stdcol.rewardState) == 1 & data(:,stdcol.choseCorrect) == 1) = 2;
    choice(data(:,stdcol.rewardState) == 2 & data(:,stdcol.choseCorrect) == 0) = 3;
    choice(data(:,stdcol.rewardState) == 2 & data(:,stdcol.choseCorrect) == 1) = 4;
end
rew = data(:,stdcol.choseCorrect);
block = data(:,stdcol.block);
corr = data(:,stdcol.cuePercent);

startparams = [];

% run optimization over 10 starting points
for init=1:100
    dispevery(init, 10, 'iters');

    % random starting point
%     x0=rand(1,4);
%     x0 = [.5 .5 -.75 -.75];
    x0=[rand(1,2) 2*(rand(1,3)-0.5)]; % allow negative starting interaction terms

    % save starting values
    startparams = [startparams; x0];

    % optimize
    [paramvals,fval,bla,bla2] =fmincon(@(x) compute_llh_RescorlaWagner_corr_RL_corr_int_plus_repnum(x,choice, rew, block, corr, nstimviews),x0,[],[],[],[],...
        LB, UB, [],options);

    % store optimization result
    parsout(init,:) = [paramvals,fval];
end

% find global best
[mf,i]=min(parsout(:,end));
out = parsout(i,:);

%%
figure;
% alpha, beta, alpha_interaction, beta_interaction, LL
corrs = unique(corr);
for ii = 1 : numel(corrs)
    xlstrs{ii} = ['corr: ' num2str(corrs(ii))];
end
learning_rates = out(1) + corrs.*out(3);
temps = out(2) + corrs.*out(4);

subplot(1,3,1);
plot(learning_rates, 'o-');
xticks(1:numel(corrs));
xticklabels(xlstrs);
a = axis;
axis([0.5 numel(corrs) + 0.5 a(3:4)]);
xlabel('correlation');
ylabel('RW alpha value');
title('Learning Rate')

subplot(1,3,2);
plot(temps, 'o-');
xticks(1:numel(corrs));
xticklabels(xlstrs);
a = axis;
axis([0.5 numel(corrs) + 0.5 a(3:4)]);
xlabel('correlation');
ylabel('RW beta value');
title('temperature')

subplot(1,3,3);
b = temps';
test_RW_temp;
title('effect of temp on choice');

