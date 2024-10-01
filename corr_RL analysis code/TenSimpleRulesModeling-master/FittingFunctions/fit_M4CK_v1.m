function [Xfit, LL, BIC] = fit_M4CK_v1(a, r)
options=optimset('MaxFunEval',100000,'Display','off','algorithm','active-set');%

obFunc = @(x) lik_M4CK_v1(a, r, x(1), x(2));

X0 = [rand 0.5+exprnd(1)];
LB = [0 0];
UB = [1 inf];
[Xfit, NegLL] = fmincon(obFunc, X0, [], [], [], [], LB, UB, [], options);

LL = -NegLL;
BIC = length(X0) * log(length(a)) + 2*NegLL;