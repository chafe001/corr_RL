% *********** RESCORLA WAGNER ***********
function LLH = compute_llh_RescorlaWagner_corr_RL_corr_int(params, choice, rew, block, corr)

alpha = params(1);
beta = params(2);
a_interaction = params(3);
b_interaction = params(4);

nchoices = numel(unique(choice));
ntrials = numel(choice);

% start each block with equal values
Q = ones(1, nchoices) * 1/nchoices;
LL = 0;

newblock = [1; find(diff(block) ~= 0)+1];

for t = 1:ntrials

    if (ismember(t, newblock))
        % start each block with equal values
        Q = ones(1, nchoices) * 1/nchoices;
    end        
    
    % compute choice probabilities
    newtemp = beta + b_interaction*corr(t);
    p = exp(newtemp*Q) / sum(exp(newtemp*Q));
    
    % accumulate log-liklihoods based on probability of actual choice
    % lower prob (poor fit) will generate a big negative number
    % we'll flip the sign, so big positive numbers will be bad fits
    % fmincon will try to minimize this
    LL=LL+log(p(choice(t)));

    % update values
    delta = rew(t) - Q(choice(t));
    newalpha = alpha + a_interaction*corr(t);
    Q(choice(t)) = Q(choice(t)) + newalpha * delta;
    Q(Q < 0) = 0; % try removing negative Q values

end % for each trial

LLH = -LL;

end % RW fx
