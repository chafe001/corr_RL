function [states,stateProbs,LL,nParams,Tall,Eall] = find2States_v1(choices)
% This fx derived from Beckett's find3states, altered transition (T) and
% emission (E) matrices after reading matlab intro to HMM for 2 states, in
% this case explore/exploit, operating on the choice data logged as
% choseCorrect (or not). Model failed to converge when provided key 1 and 2
% as choice data (of course), as this is random by design.  It is key 1 if
% movie 1 (chose correct), or key 2 if movie 2.

% seed the transition matrix for 2 states, random responding
% (explore) and response 1 and 2 (exploit)
T = [(1/2) (1/2);...
     (3/4) (1/4)];

% Beckett's original
% T = [(1/4) (1/4) (1/4) (1/4);...
%      (3/4) (1/4) (0/4) (0/4);...
%      (3/4) (0/4) (1/4) (0/4);...
%      (3/4) (0/4) (0/4) (1/4)];


% Seed the emission matrix for 2 responses (2-arm bandit)
E = [(1/2) (1/2);...
        0     1];
    
% Beckett's original
% E = [(1/3) (1/3) (1/3);...
%         1     0     0;...
%         0     1     0;...
%         0     0     1];
    
% train the HMM
[Tall,Eall] = hmmtrain(choices, T, E);

% get the most likely sequence of states
states = hmmviterbi(choices, Tall, Eall);
% tmp = num2cell(likelyStates);
% [states] = deal(tmp{:});

% now append the probabilities
[stateProbs,LL] = hmmdecode(choices, Tall, Eall);
% tmp = num2cell(stateProbs);
% [stateProbs] = deal(tmp{1,:});
% only the p(ORE)!!

nParams = sum(sum(E~=0,2)-1) + sum(sum(T~=0,2)-1);