% based on:
%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 3 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"

narms = 4; % model choices as a total of 4, L/R for each of the two stimuli in a block
% narms = 2; % model choices as just either left or right

LB = [0 0]; % loweer bounds (alpha beta)
% UB = [1 Inf]; % upper bounds
UB = [2 Inf]; % upper bounds

% set fmincon options
options=optimset('MaxFunEval',100000,'Display','off','algorithm','active-set');

% load('D:\code\tasks\corr_RL\241014_all_bData.mat');
load('D:\code\tasks\corr_RL\dave_bData.mat');
% load('D:\code\tasks\corr_RL\[mvc 2 colors 4 stim 3 reps .3 .9 cuePer .8 .2 rewProb] all_bData.mat');

corrconditions = unique(bData(:,stdcol.cuePercent));

for cc = 1 : numel(corrconditions)

    % get blocks of this correlation
    data = bData(bData(:,stdcol.cuePercent) == corrconditions(cc), :);

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


    % run optimization over 10 starting points
    for init=1:10
        % random starting point
        x0=rand(1,2);
        % optimize
        [paramvals,fval,bla,bla2] =fmincon(@(x) compute_llh_RescorlaWagner_corr_RL(x,choice, rew, block),x0,[],[],[],[],...
            LB, UB, [],options);
        % store optimization result
        parsout(init,:) = [paramvals,fval];
    end
    % find global best
    [mf,i]=min(parsout(:,end));
    out(cc,:) = [corrconditions(cc) parsout(i,:) numel(block)];

end

cols.corrCond = 1;
cols.alpha = 2;
cols.beta = 3;
col.llh = 4;
cols.ntrials = 5;

% % combine dcs
% out(out(:,3) == 0, 3) = 1;

%%
figure;

ma = grpstats(out(:,cols.alpha), out(:,cols.corrCond));
% sa = grpstats(out(:,cols.alpha), out(:,cols.corrCond), 'sem');

subplot(1,3,1);
% errorbar(ma, sa);
plot(ma, 'o-');
corrs = unique(out(:,cols.corrCond));
for ii = 1 : numel(corrs)
    xlstrs{ii} = ['corr: ' num2str(corrs(ii))];
end
xticklabels(xlstrs);
xticks(1:numel(corrs));
ylabel('RW alpha value');
a = axis;
axis([0.5 numel(corrs) + 0.5 a(3:4)]);
title('learning rate')

mb = grpstats(out(:,cols.beta), out(:,cols.corrCond));
% sb = grpstats(out(:,cols.beta), out(:,cols.corrCond), 'sem');

subplot(1,3,2);
% errorbar(mb, sb);
plot(mb, 'o-');
xticks(1:numel(corrs));
xticklabels(xlstrs);
ylabel('RW beta value');
a = axis;
axis([0.5 numel(corrs) + 0.5 a(3:4)]);
title('temperature')


subplot(1,3,3);
b = out(:,cols.beta)';
test_RW_temp;
title('effect of temp on choice');
