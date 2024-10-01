function [BIC, iBEST, BEST] = fit_all_v1(a, r)
xfit = cell(1,5);
LL = zeros(1,5);

[xfit{1}, LL(1), BIC(1)] = fit_M1random_v1(a, r);
[xfit{2}, LL(2), BIC(2)] = fit_M2WSLS_v1(a, r);
[xfit{3}, LL(3), BIC(3)] = fit_M3RescorlaWagner_v1(a, r);
[xfit{4}, LL(4), BIC(4)] = fit_M4CK_v1(a, r);
[xfit{5}, LL(5), BIC(5)] = fit_M5RWCK_v1(a, r);

[M, iBEST] = min(BIC);
BEST = BIC == M;
BEST = BEST / sum(BEST);