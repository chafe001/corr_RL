function LLH = compute_llh_RescorlaWagner_corr_RL_corr_int(params, choice, rew, block, corr)
    alpha = params(1);
    beta = params(2);
    a_interaction = params(3);
    b_interaction = params(4);  
    
    nchoices = numel(unique(choice));
    ntrials = numel(choice);
    Q = ones(1, nchoices) * 1/nchoices;
    LL = 0;
    newblock = [1; find(diff(block) ~= 0)+1];
    
    for t = 1:ntrials
        if (ismember(t, newblock))
            Q = ones(1, nchoices) * 1/nchoices;
        end
        
        % Compute modified parameters with bounds
        newalpha = max(0, min(1, alpha + a_interaction*corr(t)));  % Bound learning rate between 0 and 1
        newtemp = max(0.01, beta + b_interaction*corr(t));  % Ensure positive temperature
        
        % Numerically stable softmax
        Q_temp = newtemp * Q;
        Q_temp = Q_temp - max(Q_temp);  % Subtract maximum for numerical stability
        p = exp(Q_temp) / sum(exp(Q_temp));
        
        % Accumulate log-likelihood
        if any(p <= 0) || any(isnan(p))
            LLH = inf;  % Return inf if probabilities are invalid
            return;
        end
        LL = LL + log(p(choice(t)));
        
        % Update values with bounded learning rate
        delta = rew(t) - Q(choice(t));
        Q(choice(t)) = Q(choice(t)) + newalpha * delta;
        Q = max(0, Q);  % Ensure non-negative Q values
    end
    
    LLH = -LL;
end