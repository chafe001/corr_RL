% based on:
%%%%% Bob Wilson & Anne Collins
%%%%% 2018
%%%%% Code to produce figure 3 in submitted paper "Ten simple rules for the
%%%%% computational modeling of behavioral data"

narms = 4; % model choices as a total of 4, L/R for each of the two stimuli in a block
% narms = 2; % model choices as just either left or right

LB = [0 0 -Inf -Inf]; % loweer bounds (alpha beta alpha_interaction beta_interaction)
UB = [2 Inf Inf Inf]; % upper bounds
% LB = [0 0 ]; % loweer bounds (alpha beta)
% UB = [2 Inf]; % upper bounds

% set fmincon options
% options=optimset('MaxIterations', 10000, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');
% options=optimoptions('fmincon', 'MaxIterations', 10000, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');
options=optimoptions('fmincon', 'MaxIterations', 400, 'MaxFunEval',1000000,'Display','off','algorithm','active-set');

% load('D:\code\tasks\corr_RL\241014_all_bData.mat');
% load('D:\code\tasks\corr_RL\dave_bData.mat');
% load('D:\code\tasks\corr_RL\[mvc 2 colors 4 stim 3 reps .3 .9 cuePer .8 .2 rewProb] all_bData.mat');
load('D:\code\tasks\corr_RL\matt_24_10_22.mat');

corrconditions = unique(bData(:,stdcol.cuePercent));


% % get blocks of this correlation
% data = bData(bData(:,stdcol.cuePercent) == corrconditions(cc), :);
data = bData;

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
    x0=[rand(1,2) 2*(rand(1,2)-0.5)]; % allow negative starting interaction terms

    % save starting values
    startparams = [startparams; x0];

    % optimize
    [paramvals,fval,bla,bla2] =fmincon(@(x) compute_llh_RescorlaWagner_corr_RL_corr_int(x,choice, rew, block, corr),x0,[],[],[],[],...
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

