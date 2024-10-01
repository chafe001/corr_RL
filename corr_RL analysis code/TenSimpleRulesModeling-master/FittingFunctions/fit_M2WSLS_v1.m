function [Xfit, LL, BIC] = fit_M2WSLS_v1(a, r)
options=optimset('MaxFunEval',100000,'Display','off','algorithm','active-set');%

obFunc = @(x) lik_M2WSLS_v1(a, r, x);

X0 = rand;
LB = 0;
UB = 1;
[Xfit, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB, [], options);

LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;