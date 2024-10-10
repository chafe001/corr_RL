
function [condAra, condAraLabel, trialAra, numConds] = TOPXconditionsSetup(trialSet)
% clean up our TOPX code and put a lot of the initial condition setup in
% here instead

%% -------- Repetitions per condition --------------
% Individual combinations of specific cues and probes, in each trial type

% Ara36 condition nums, stimuli and repetitions:
% 5 B-cues, 5 Y-probes.  With A and X, 6 cues and 6 probes (36
% combinations)

% TOTAL TRIALS: 250
% ------ AX 175 trials 70%
% COND_1  AX:  175 70%
% ------ AY 25 trials 10%
% COND_2  AY1: 5 2%
% COND_3  AY2: 5 2%
% COND_4  AY3: 5 2%
% COND_5  AY4: 5 2%
% COND_6  AY5: 5 2%
% ------  BX 25 trials 10%
% COND_7  B1X: 5 2%
% COND_8  B2X: 5 2%
% COND_9  B3X: 5 2%
% COND_10 B4X: 5 2%
% COND_11 B5X: 5 2%
% ------ BY 25 trials 10%
% COND_12 B1Y1: 1 0.4%
% COND_13 B1Y2: 1 0.4%
% COND_14 B1Y3: 1 0.4%
% COND_15 B1Y4: 1 0.4%
% COND_16 B1Y5: 1 0.4%
% COND_17 B2Y1: 1 0.4%
% COND_18 B2Y2: 1 0.4%
% COND_19 B2Y3: 1 0.4%
% COND_20 B2Y4: 1 0.4%
% COND_21 B2Y5: 1 0.4%
% COND_22 B3Y1: 1 0.4%
% COND_23 B3Y2: 1 0.4%
% COND_24 B3Y3: 1 0.4%
% COND_25 B3Y4: 1 0.4%
% COND_26 B3Y5: 1 0.4%
% COND_27 B4Y1: 1 0.4%
% COND_28 B4Y2: 1 0.4%
% COND_29 B4Y3: 1 0.4%
% COND_30 B4Y4: 1 0.4%
% COND_31 B4Y5: 1 0.4%
% COND_32 B5Y1: 1 0.4%
% COND_33 B5Y2: 1 0.4%
% COND_34 B5Y3: 1 0.4%
% COND_35 B5Y4: 1 0.4%
% COND_36 B5Y5: 1 0.4%
% ------
prep_250.AXreps = 175;
prep_250.AYreps = 5;
prep_250.BXreps = 5;
prep_250.BYreps = 1;

% TOTAL TRIALS: 480
% ------ AX 335 trials 69%
% COND_1  AX:  335 69%
% ------ AY 60 trials 12.4%
% COND_2  AY1: 12 2.0%
% COND_3  AY2: 12 2.0%
% COND_4  AY3: 12 2.0%
% COND_5  AY4: 12 2.0%
% COND_6  AY5: 12 2.0%
% ------  BX 60 trials 12.7%
% COND_7  B1X: 12 1.8%
% COND_8  B2X: 12 1.8%
% COND_9  B3X: 12 1.8%
% COND_10 B4X: 12 1.8%
% COND_11 B5X: 12 1.8%
% ------ BY 25 trials 5.2%
% COND_12 B1Y1: 1 0.1%
% COND_13 B1Y2: 1 0.1%
% COND_14 B1Y3: 1 0.1%
% COND_15 B1Y4: 1 0.1%
% COND_16 B1Y5: 1 0.1%
% COND_17 B2Y1: 1 0.1%
% COND_18 B2Y2: 1 0.1%
% COND_19 B2Y3: 1 0.1%
% COND_20 B2Y4: 1 0.1%
% COND_21 B2Y5: 1 0.1%
% COND_22 B3Y1: 1 0.1%
% COND_23 B3Y2: 1 0.1%
% COND_24 B3Y3: 1 0.1%
% COND_25 B3Y4: 1 0.1%
% COND_26 B3Y5: 1 0.1%
% COND_27 B4Y1: 1 0.1%
% COND_28 B4Y2: 1 0.1%
% COND_29 B4Y3: 1 0.1%
% COND_30 B4Y4: 1 0.1%
% COND_31 B4Y5: 1 0.1%
% COND_32 B5Y1: 1 0.1%
% COND_33 B5Y2: 1 0.1%
% COND_34 B5Y3: 1 0.1%
% COND_35 B5Y4: 1 0.1%
% COND_36 B5Y5: 1 0.1%
% ------
repAra36_480.AXreps = 335;
repAra36_480.AYreps = 12;
repAra36_480.BXreps = 12;
repAra36_480.BYreps = 1;

% TOTAL TRIALS: 400
% ------ AX 275 trials 68.75%
% COND_1  AX:  275 68.75%
% ------ AY 50 trials 12.4%
% COND_2  AY1: 10 2.0%
% COND_3  AY2: 10 2.0%
% COND_4  AY3: 10 2.0%
% COND_5  AY4: 10 2.0%
% COND_6  AY5: 10 2.0%
% ------  BX 50 trials 12.7%
% COND_7  B1X: 10 1.8%
% COND_8  B2X: 10 1.8%
% COND_9  B3X: 10 1.8%
% COND_10 B4X: 10 1.8%
% COND_11 B5X: 10 1.8%
% ------ BY 25 trials 6.25%
% COND_12 B1Y1: 1 0.1%
% COND_13 B1Y2: 1 0.1%
% COND_14 B1Y3: 1 0.1%
% COND_15 B1Y4: 1 0.1%
% COND_16 B1Y5: 1 0.1%
% COND_17 B2Y1: 1 0.1%
% COND_18 B2Y2: 1 0.1%
% COND_19 B2Y3: 1 0.1%
% COND_20 B2Y4: 1 0.1%
% COND_21 B2Y5: 1 0.1%
% COND_22 B3Y1: 1 0.1%
% COND_23 B3Y2: 1 0.1%
% COND_24 B3Y3: 1 0.1%
% COND_25 B3Y4: 1 0.1%
% COND_26 B3Y5: 1 0.1%
% COND_27 B4Y1: 1 0.1%
% COND_28 B4Y2: 1 0.1%
% COND_29 B4Y3: 1 0.1%
% COND_30 B4Y4: 1 0.1%
% COND_31 B4Y5: 1 0.1%
% COND_32 B5Y1: 1 0.1%
% COND_33 B5Y2: 1 0.1%
% COND_34 B5Y3: 1 0.1%
% COND_35 B5Y4: 1 0.1%
% COND_36 B5Y5: 1 0.1%
% ------

repAra36_400.AXreps = 275;
repAra36_400.AYreps = 10;
repAra36_400.BXreps = 10;
repAra36_400.BYreps = 1;

% TOTAL TRIALS: 300
% ------ AX 205 trials 68.33%
% COND_1  AX: 205 68.33%
% ------ AY 35 trials 11.67%
% COND_2  AY1: 7 2.33%
% COND_3  AY2: 7 2.33%
% COND_4  AY3: 7 2.33%
% COND_5  AY4: 7 2.33%
% COND_6  AY5: 7 2.33%
% ------  BX 35 trials 11.67%
% COND_7  B1X: 7 2.33%
% COND_8  B2X: 7 2.33%
% COND_9  B3X: 7 2.33%
% COND_10 B4X: 7 2.33%
% COND_11 B5X: 7 2.33%
% ------ BY 25 trials 8.33%
% COND_12 B1Y1: 1 0.33%
% COND_13 B1Y2: 1 0.33%
% COND_14 B1Y3: 1 0.33%
% COND_15 B1Y4: 1 0.33%
% COND_16 B1Y5: 1 0.33%
% COND_17 B2Y1: 1 0.33%
% COND_18 B2Y2: 1 0.33%
% COND_19 B2Y3: 1 0.33%
% COND_20 B2Y4: 1 0.33%
% COND_21 B2Y5: 1 0.33%
% COND_22 B3Y1: 1 0.33%
% COND_23 B3Y2: 1 0.33%
% COND_24 B3Y3: 1 0.33%
% COND_25 B3Y4: 1 0.33%
% COND_26 B3Y5: 1 0.33%
% COND_27 B4Y1: 1 0.33%
% COND_28 B4Y2: 1 0.33%
% COND_29 B4Y3: 1 0.33%
% COND_30 B4Y4: 1 0.33%
% COND_31 B4Y5: 1 0.33%
% COND_32 B5Y1: 1 0.33%
% COND_33 B5Y2: 1 0.33%
% COND_34 B5Y3: 1 0.33%
% COND_35 B5Y4: 1 0.33%
% COND_36 B5Y5: 1 0.33%
% ------

repAra36_300.AXreps = 205;
repAra36_300.AYreps = 7;
repAra36_300.BXreps = 7;
repAra36_300.BYreps = 1;

% TOTAL TRIALS: 150
% ------ AX 75 trials 50%
% COND_1  AX:  75 50%
% ------ AY 25 trials 16.7%
% COND_2  AY1: 5 3.3%
% COND_3  AY2: 5 3.3%
% COND_4  AY3: 5 3.3%
% COND_5  AY4: 5 3.3%
% COND_6  AY5: 5 3.3%
% ------  BX 25 trials 16.7%
% COND_7  B1X: 5 3.3%
% COND_8  B2X: 5 3.3%
% COND_9  B3X: 5 3.3%
% COND_10 B4X: 5 3.3%
% COND_11 B5X: 5 3.3%
% ------ BY 25 trials 16.7%
% COND_12 B1Y1: 1 0.67%
% COND_13 B1Y2: 1 0.67%
% COND_14 B1Y3: 1 0.67%
% COND_15 B1Y4: 1 0.67%
% COND_16 B1Y5: 1 0.67%
% COND_17 B2Y1: 1 0.67%
% COND_18 B2Y2: 1 0.67%
% COND_19 B2Y3: 1 0.67%
% COND_20 B2Y4: 1 0.67%
% COND_21 B2Y5: 1 0.67%
% COND_22 B3Y1: 1 0.67%
% COND_23 B3Y2: 1 0.67%
% COND_24 B3Y3: 1 0.67%
% COND_25 B3Y4: 1 0.67%
% COND_26 B3Y5: 1 0.67%
% COND_27 B4Y1: 1 0.67%
% COND_28 B4Y2: 1 0.67%
% COND_29 B4Y3: 1 0.67%
% COND_30 B4Y4: 1 0.67%
% COND_31 B4Y5: 1 0.67%
% COND_32 B5Y1: 1 0.67%
% COND_33 B5Y2: 1 0.67%
% COND_34 B5Y3: 1 0.67%
% COND_35 B5Y4: 1 0.67%
% COND_36 B5Y5: 1 0.67%
% ------

repAra36_equalLR.AXreps = 375;  % 75*5
repAra36_equalLR.AYreps = 25;    % 5*5
repAra36_equalLR.BXreps = 25;    % 5*5
repAra36_equalLR.BYreps = 5;    % 1*5

% TOTAL TRIALS: 150
% ------ AX 25 trials 25%
% COND_1  AX:  25 25%
% ------ AY 25 trials 25%
% COND_2  AY1: 5 5%
% COND_3  AY2: 5 5%
% COND_4  AY3: 5 5%
% COND_5  AY4: 5 5%
% COND_6  AY5: 5 5%
% ------  BX 25 trials 25%
% COND_7  B1X: 5 5%
% COND_8  B2X: 5 5%
% COND_9  B3X: 5 5%
% COND_10 B4X: 5 5%
% COND_11 B5X: 5 5%
% ------ BY 25 trials 25%
% COND_12 B1Y1: 1 1%
% COND_13 B1Y2: 1 1%
% COND_14 B1Y3: 1 1%
% COND_15 B1Y4: 1 1%
% COND_16 B1Y5: 1 1%
% COND_17 B2Y1: 1 1%
% COND_18 B2Y2: 1 1%
% COND_19 B2Y3: 1 1%
% COND_20 B2Y4: 1 1%
% COND_21 B2Y5: 1 1%
% COND_22 B3Y1: 1 1%
% COND_23 B3Y2: 1 1%
% COND_24 B3Y3: 1 1%
% COND_25 B3Y4: 1 1%
% COND_26 B3Y5: 1 1%
% COND_27 B4Y1: 1 1%
% COND_28 B4Y2: 1 1%
% COND_29 B4Y3: 1 1%
% COND_30 B4Y4: 1 1%
% COND_31 B4Y5: 1 1%
% COND_32 B5Y1: 1 1%
% COND_33 B5Y2: 1 1%
% COND_34 B5Y3: 1 1%
% COND_35 B5Y4: 1 1%
% COND_36 B5Y5: 1 1%
% ------

repAra36_balanced.AXreps = 125;  % 1*125
repAra36_balanced.AYreps = 25;    % 5*5
repAra36_balanced.BXreps = 25;    % 5*5
repAra36_balanced.BYreps = 5;    % 1*5

% TOTAL TRIALS: 150
% ------ AX 75 trials 50%
% COND_1  AX:  75 50%
% ------ AY 25 trials 16.7%
% COND_2  AY1: 5 3.3%
% COND_3  AY2: 5 3.3%
% COND_4  AY3: 5 3.3%
% COND_5  AY4: 5 3.3%
% COND_6  AY5: 5 3.3%
% ------  BX 27 trials 16.7%
% COND_7  B1X: 9 3.3%
% COND_8  B2X: 9 3.3%
% COND_9  B4X: 9 3.3%
% ------ BY 28 trials 16.7%
% COND_10 B1Y1: 2 0.67%
% COND_11 B1Y2: 2 0.67%
% COND_12 B1Y3: 2 0.67%
% COND_13 B1Y4: 2 0.67%
% COND_14 B1Y5: 2 0.67%
% COND_15 B2Y1: 2 0.67%
% COND_16 B2Y2: 2 0.67%
% COND_17 B2Y3: 2 0.67%
% COND_18 B2Y4: 2 0.67%
% COND_19 B2Y5: 2 0.67%
% COND_20 B4Y1: 2 0.67%
% COND_21 B4Y2: 2 0.67%
% COND_22 B4Y3: 2 0.67%
% COND_23 B4Y4: 2 0.67%
% COND_24 B4Y5: 2 0.67%
% ------

repAra24_equalLR_goodBXonly.AXreps = 375;  % 75*5
repAra24_equalLR_goodBXonly.AYreps = 25;    % 5*5
repAra24_equalLR_goodBXonly.BXreps = 45;    % 9*5
repAra24_equalLR_goodBXonly.BYreps = 10;    % 1*5

% TOTAL TRIALS: 150
% ------ AX 75 trials 50%
% COND_1  AX:  75 50%
% ------ AY 25 trials 16.7%
% COND_2  AY1: 5 3.3%
% COND_3  AY2: 5 3.3%
% COND_4  AY3: 5 3.3%
% COND_5  AY4: 5 3.3%
% COND_6  AY5: 5 3.3%
% ------  BX 25 trials 16.7%
% COND_7  B1X: 5 3.3%
% COND_8  B2X: 5 3.3%
% COND_9  B3X: 5 3.3%
% COND_10 B4X: 5 3.3%
% COND_11 B5X: 5 3.3%
% ------ BY 25 trials 16.7%
% COND_12 B1Y1: 1 0.67%
% COND_13 B1Y2: 1 0.67%
% COND_14 B1Y3: 1 0.67%
% COND_15 B1Y4: 1 0.67%
% COND_16 B1Y5: 1 0.67%
% COND_17 B2Y1: 1 0.67%
% COND_18 B2Y2: 1 0.67%
% COND_19 B2Y3: 1 0.67%
% COND_20 B2Y4: 1 0.67%
% COND_21 B2Y5: 1 0.67%
% COND_22 B3Y1: 1 0.67%
% COND_23 B3Y2: 1 0.67%
% COND_24 B3Y3: 1 0.67%
% COND_25 B3Y4: 1 0.67%
% COND_26 B3Y5: 1 0.67%
% COND_27 B4Y1: 1 0.67%
% COND_28 B4Y2: 1 0.67%
% COND_29 B4Y3: 1 0.67%
% COND_30 B4Y4: 1 0.67%
% COND_31 B4Y5: 1 0.67%
% COND_32 B5Y1: 1 0.67%
% COND_33 B5Y2: 1 0.67%
% COND_34 B5Y3: 1 0.67%
% COND_35 B5Y4: 1 0.67%
% COND_36 B5Y5: 1 0.67%
% ------

repAra36_moreBX.AXreps = 225;  % 75*3
repAra36_moreBX.AYreps = 15;    % 5*3
repAra36_moreBX.BXreps = 25;    % 5*5
repAra36_moreBX.BYreps = 3;    % 1*3

% TOTAL TRIALS: 400
% ------ AX 200 trials 50%
% COND_1  AX:  200 50%
% ------ AY 25 trials 6.25%
% COND_2  AY1: 5 1.25%
% COND_3  AY2: 5 1.25%
% COND_4  AY3: 5 1.25%
% COND_5  AY4: 5 1.25%
% COND_6  AY5: 5 1.25%
% ------  BX 150 trials 37.5%
% COND_7  B1X: 30 7.5%
% COND_8  B2X: 30 7.5%
% COND_9  B3X: 30 7.5%
% COND_10 B4X: 30 7.5%
% COND_11 B5X: 30 7.5%
% ------ BY 25 trials 6.25%
% COND_12 B1Y1: 1 0.25%
% COND_13 B1Y2: 1 0.25%
% COND_14 B1Y3: 1 0.25%
% COND_15 B1Y4: 1 0.25%
% COND_16 B1Y5: 1 0.25%
% COND_17 B2Y1: 1 0.25%
% COND_18 B2Y2: 1 0.25%
% COND_19 B2Y3: 1 0.25%
% COND_20 B2Y4: 1 0.25%
% COND_21 B2Y5: 1 0.25%
% COND_22 B3Y1: 1 0.25%
% COND_23 B3Y2: 1 0.25%
% COND_24 B3Y3: 1 0.25%
% COND_25 B3Y4: 1 0.25%
% COND_26 B3Y5: 1 0.25%
% COND_27 B4Y1: 1 0.25%
% COND_28 B4Y2: 1 0.25%
% COND_29 B4Y3: 1 0.25%
% COND_30 B4Y4: 1 0.25%
% COND_31 B4Y5: 1 0.25%
% COND_32 B5Y1: 1 0.25%
% COND_33 B5Y2: 1 0.25%
% COND_34 B5Y3: 1 0.25%
% COND_35 B5Y4: 1 0.25%
% COND_36 B5Y5: 1 0.25%
% ------

repAra36_danMidPrep.AXreps = 400;  % 200*1 = 200 total * 2
repAra36_danMidPrep.AYreps = 10;    % 5*25 = 25 total * 2
repAra36_danMidPrep.BXreps = 60;    % 5*30 = 150 total * 2
repAra36_danMidPrep.BYreps = 2;    % 1*1 = 25 total * 2

% TOTAL TRIALS: 400
% ------ AX 250 trials 62.5%
% COND_1  AX:  250 62.5%
% ------ AY 25 trials 6.25%
% COND_2  AY1: 5 1.25%
% COND_3  AY2: 5 1.25%
% COND_4  AY3: 5 1.25%
% COND_5  AY4: 5 1.25%
% COND_6  AY5: 5 1.25%
% ------  BX 100 trials 25%
% COND_7  B1X: 20 5%
% COND_8  B2X: 20 5%
% COND_9  B3X: 20 5%
% COND_10 B4X: 20 5%
% COND_11 B5X: 20 5%
% ------ BY 25 trials 6.25%
% COND_12 B1Y1: 1 0.25%
% COND_13 B1Y2: 1 0.25%
% COND_14 B1Y3: 1 0.25%
% COND_15 B1Y4: 1 0.25%
% COND_16 B1Y5: 1 0.25%
% COND_17 B2Y1: 1 0.25%
% COND_18 B2Y2: 1 0.25%
% COND_19 B2Y3: 1 0.25%
% COND_20 B2Y4: 1 0.25%
% COND_21 B2Y5: 1 0.25%
% COND_22 B3Y1: 1 0.25%
% COND_23 B3Y2: 1 0.25%
% COND_24 B3Y3: 1 0.25%
% COND_25 B3Y4: 1 0.25%
% COND_26 B3Y5: 1 0.25%
% COND_27 B4Y1: 1 0.25%
% COND_28 B4Y2: 1 0.25%
% COND_29 B4Y3: 1 0.25%
% COND_30 B4Y4: 1 0.25%
% COND_31 B4Y5: 1 0.25%
% COND_32 B5Y1: 1 0.25%
% COND_33 B5Y2: 1 0.25%
% COND_34 B5Y3: 1 0.25%
% COND_35 B5Y4: 1 0.25%
% COND_36 B5Y5: 1 0.25%
% ------

repAra36_danHardPrep.AXreps = 500;  % 250*1 = 250 total * 2
repAra36_danHardPrep.AYreps = 10;    % 5*25 = 25 total * 2
repAra36_danHardPrep.BXreps = 40;    % 5*20 = 100 total * 2
repAra36_danHardPrep.BYreps = 2;    % 1*1 = 25 total * 2

% TOTAL TRIALS: 400
% ------ AX 175 trials 43.75%
% COND_1  AX:  175 43.75%
% ------ AY 25 trials 6.25%
% COND_2  AY1: 5 1.25%
% COND_3  AY2: 5 1.25%
% COND_4  AY3: 5 1.25%
% COND_5  AY4: 5 1.25%
% COND_6  AY5: 5 1.25%
% ------  BX 175 trials 43.75%
% COND_7  B1X: 35 8.75%
% COND_8  B2X: 35 8.75%
% COND_9  B3X: 35 8.75%
% COND_10 B4X: 35 8.75%
% COND_11 B5X: 35 8.75%
% ------ BY 25 trials 6.25%
% COND_12 B1Y1: 1 0.25%
% COND_13 B1Y2: 1 0.25%
% COND_14 B1Y3: 1 0.25%
% COND_15 B1Y4: 1 0.25%
% COND_16 B1Y5: 1 0.25%
% COND_17 B2Y1: 1 0.25%
% COND_18 B2Y2: 1 0.25%
% COND_19 B2Y3: 1 0.25%
% COND_20 B2Y4: 1 0.25%
% COND_21 B2Y5: 1 0.25%
% COND_22 B3Y1: 1 0.25%
% COND_23 B3Y2: 1 0.25%
% COND_24 B3Y3: 1 0.25%
% COND_25 B3Y4: 1 0.25%
% COND_26 B3Y5: 1 0.25%
% COND_27 B4Y1: 1 0.25%
% COND_28 B4Y2: 1 0.25%
% COND_29 B4Y3: 1 0.25%
% COND_30 B4Y4: 1 0.25%
% COND_31 B4Y5: 1 0.25%
% COND_32 B5Y1: 1 0.25%
% COND_33 B5Y2: 1 0.25%
% COND_34 B5Y3: 1 0.25%
% COND_35 B5Y4: 1 0.25%
% COND_36 B5Y5: 1 0.25%
% ------

repAra36_danEzPrep.AXreps = 350;  % 175*1 = 175 total * 2
repAra36_danEzPrep.AYreps = 10;    % 5*5 = 25 total * 2
repAra36_danEzPrep.BXreps = 70;    % 5*35 = 175 total * 2
repAra36_danEzPrep.BYreps = 2;    % 1*1 = 25 total * 2

% TOTAL TRIALS: 100
% ------ AX 50 trials 50%
% COND_1  AX:  50 50%
% ------  BX 50 trials 50%
% COND_7  B1X: 10 10%
% COND_8  B2X: 10 10%
% COND_9  B3X: 10 10%
% COND_10 B4X: 10 10%
% COND_11 B5X: 10 10%
% ------
% will multiply reps to get to 700 total - more than we should hopefully
% ever run in a session

repAra36_AXBXonly.AXreps = 350;  % 50*7
repAra36_AXBXonly.AYreps = 0;
repAra36_AXBXonly.BXreps = 70;    % 10*7
repAra36_AXBXonly.BYreps = 0;

% TOTAL TRIALS: 60
% ------ AX 30 trials 50%
% COND_1  AX:  30 50%
% ------  BX 30 trials 50%
% COND_7  B1X: 10 33%
% COND_8  B2X: 10 33%
% COND_9  B3X: 0 0%
% COND_10 B4X: 10 33%
% COND_11 B5X: 0 0%
% ------
% will multiply reps to get to 600 total - more than we should hopefully
% ever run in a session

repAra36_goodAXBXonly.AXreps = 300;  % 30*10
repAra36_goodAXBXonly.AYreps = 0;
repAra36_goodAXBXonly.BXreps = 100;    % this is how the math works don't question me
repAra36_goodAXBXonly.BYreps = 0;

% Ara56 condition nums, stimuli and repetitions:
% 7 B-cues, 6 Y-probes.  With A and X, 8 cues and 7 probes (56
% combinations)
% TOTAL TRIALS: 770  (smaller sets require not sampling all stimulus
% combinations)
% ------ AX 534 trials 69.4%
% COND_1  AX:  534 69.4%
% ------ AY 96 trials 12.5%
% COND_2  AY1: 16 2.0%
% COND_3  AY2: 16 2.0%
% COND_4  AY3: 16 2.0%
% COND_5  AY4: 16 2.0%
% COND_6  AY5: 16 2.0%
% COND_7  AY6: 16 2.0%
% ------  BX 98 trials 12.7%
% COND_8  B1X: 14 1.8%
% COND_9  B2X: 14 1.8%
% COND_10 B3X: 14 1.8%
% COND_11 B4X: 14 1.8%
% COND_12 B5X: 14 1.8%
% COND_13 B6X: 14 1.8%
% COND_14 B7X: 14 1.8%
% ------ BY 42 trials 5.5%
% COND_15 B1Y1: 1 0.1%
% COND_16 B1Y2: 1 0.1%
% COND_17 B1Y3: 1 0.1%
% COND_18 B1Y4: 1 0.1%
% COND_19 B1Y5: 1 0.1%
% COND_20 B1Y6: 1 0.1%
% COND_21 B2Y1: 1 0.1%
% COND_22 B2Y2: 1 0.1%
% COND_23 B2Y3: 1 0.1%
% COND_24 B2Y4: 1 0.1%
% COND_25 B2Y5: 1 0.1%
% COND_26 B2Y6: 1 0.1%
% COND_27 B3Y1: 1 0.1%
% COND_28 B3Y2: 1 0.1%
% COND_29 B3Y3: 1 0.1%
% COND_30 B3Y4: 1 0.1%
% COND_31 B3Y5: 1 0.1%
% COND_32 B3Y6: 1 0.1%
% COND_33 B4Y1: 1 0.1%
% COND_34 B4Y2: 1 0.1%
% COND_35 B4Y3: 1 0.1%
% COND_36 B4Y4: 1 0.1%
% COND_37 B4Y5: 1 0.1%
% COND_38 B4Y6: 1 0.1%
% COND_39 B5Y1: 1 0.1%
% COND_40 B5Y2: 1 0.1%
% COND_41 B5Y3: 1 0.1%
% COND_42 B5Y4: 1 0.1%
% COND_43 B5Y5: 1 0.1%
% COND_44 B5Y6: 1 0.1%
% COND_45 B6Y1: 1 0.1%
% COND_46 B6Y2: 1 0.1%
% COND_47 B6Y3: 1 0.1%
% COND_48 B6Y4: 1 0.1%
% COND_49 B6Y5: 1 0.1%
% COND_50 B6Y6: 1 0.1%
% COND_51 B7Y1: 1 0.1%
% COND_52 B7Y2: 1 0.1%
% COND_53 B7Y3: 1 0.1%
% COND_54 B7Y4: 1 0.1%
% COND_55 B7Y5: 1 0.1%
% COND_56 B7Y6: 1 0.1%
% ------

repAra56_770.AXreps = 534;
repAra56_770.AYreps = 16;
repAra56_770.BXreps = 14;
repAra56_770.BYreps = 1;

% Test array
repAra36_test.AXreps = 1;
repAra36_test.AYreps = 1;
repAra36_test.BXreps = 1;
repAra36_test.BYreps = 1;


% --- IMPORTANT: trialSet is the control variable that determines the experiment
switch trialSet
    case 'prep_250'
        repAra = prep_250;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_trials480'
        repAra = repAra36_480;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_trials400'
        repAra = repAra36_400;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_trials300'
        repAra = repAra36_300;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_equalLR'
        repAra = repAra36_equalLR;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_balanced'
        repAra = repAra36_balanced;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_equalLR_goodBXonly'
        repAra = repAra24_equalLR_goodBXonly;
        condAra = 'condAra_equalLR_goodBXonly';
        numConds = 24;
        AYcondList = 2:6;
        BXcondList = 7:9;
        BYcondList = 10:24;
    case 'cond36_moreBX'
        repAra = repAra36_moreBX;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_danMidPrep'
        repAra = repAra36_danMidPrep;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_danHardPrep'
        repAra = repAra36_danHardPrep;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_danEzPrep'
        repAra = repAra36_danEzPrep;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_AXBXonly'
        repAra = repAra36_AXBXonly;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    case 'cond36_goodAXBXonly'
        repAra = repAra36_goodAXBXonly;
        condAra = 'condAra_goodAXBXonly';
        numConds = 4;   % this should be your total num conditions - AX and however many "good" BXs to include
        BXcondList = 2:numConds;
        AYcondList = 0;
        BYcondList = 0;
    case 'cond56_trials770'
        repAra = repAra56_770;
        condAra = 'ara56';
        numConds = 56;
        AYcondList = 2:7;
        BXcondList = 8:14;
        BYcondList = 15:56;
    case 'cond36_test'
        repAra = repAra36_test;
        condAra = 'ara36';
        numConds = 36;
        AYcondList = 2:6;
        BXcondList = 7:11;
        BYcondList = 12:36;
    otherwise
        disp('Please enter a valid condition/trial set');
end

%% -------------------- BUILD CONDITION ARRAY ----------------------------

if numConds == 56
    for c = 1:numConds
        switch c
            case {1, 2, 3, 4, 5, 6, 7}        %A cue
                condAra56{c}.cueStr = 'A';
                condAra56{c}.cueID = 0;
                condAra56{c}.cue_pic = 'calA_100_2p50c.png';
            case {8, 15, 16, 17, 18, 19, 20}  %B1 cue
                condAra56{c}.cueStr = 'B1';
                condAra56{c}.cueID = 1;
                condAra56{c}.cue_pic = 'calB_010_1p0c.png';
            case {9, 21, 22, 23, 24, 25, 26}  %B2 cue
                condAra56{c}.cueStr = 'B2';
                condAra56{c}.cueID = 2;
                condAra56{c}.cue_pic = 'calB_020_1p0c.png';
            case {10, 27, 28, 29, 30, 31, 32}  %B3 cue
                condAra56{c}.cueStr = 'B3';
                condAra56{c}.cueID = 3;
                condAra56{c}.cue_pic = 'calB_030_1p0c.png';
            case {11, 33, 34, 35, 36, 37, 38}  %B4 cue
                condAra56{c}.cueStr = 'B4';
                condAra56{c}.cueID = 4;
                condAra56{c}.cue_pic = 'calB_000_1p0c.png';
            case {12, 39, 40, 41, 42, 43, 44}  %B5 cue
                condAra56{c}.cueStr = 'B5';
                condAra56{c}.cueID = 5;
                condAra56{c}.cue_pic = 'calB_330_1p0c.png';
            case {13, 45, 46, 47, 48, 49, 50}  %B6 cue
                condAra56{c}.cueStr = 'B6';
                condAra56{c}.cueID = 6;
                condAra56{c}.cue_pic = 'calB_340_1p0c.png';
            case {14, 51, 52, 53, 54, 55, 56}  %B7 cue
                condAra56{c}.cueStr = 'B7';
                condAra56{c}.cueID = 7;
                condAra56{c}.cue_pic = 'calB_350_1p0c.png';
        end
    end

    for p = 1 : numConds
        switch p
            case {1, 8, 9, 10, 11, 12, 13, 14} %X probe
                condAra56{p}.probeStr = 'X';
                condAra56{p}.probeID = 0;
                condAra56{p}.probe_pic = 'calX_055_1p20c.png';
            case {2, 15, 21, 27, 33, 39, 45, 51} %Y1 probe
                condAra56{p}.probeStr = 'Y1';
                condAra56{p}.probeID = 1;
                condAra56{p}.probe_pic = 'calY_024_0p60c.png';
            case {3, 16, 22, 28, 34, 40, 46, 52} %Y2 probe
                condAra56{p}.probeStr = 'Y2';
                condAra56{p}.probeID = 2;
                condAra56{p}.probe_pic = 'calY_032_0p50c.png';
            case {4, 17, 23, 29, 35, 41, 47, 53} %Y3 probe
                condAra56{p}.probeStr = 'Y3';
                condAra56{p}.probeID = 3;
                condAra56{p}.probe_pic = 'calY_040_0p40c.png';
            case {5, 18, 24, 30, 36, 42, 48, 54} %Y4 probe
                condAra56{p}.probeStr = 'Y4';
                condAra56{p}.probeID = 4;
                condAra56{p}.probe_pic = 'calY_070_0p40c.png';
            case {6, 19, 25, 31, 37, 43, 49, 55} %Y5 probe
                condAra56{p}.probeStr = 'Y5';
                condAra56{p}.probeID = 5;
                condAra56{p}.probe_pic = 'calY_078_0p50c.png';
            case {7, 20, 26, 32, 38, 44, 50, 56} %Y6 probe
                condAra56{p}.probeStr = 'Y6';
                condAra56{p}.probeID = 6;
                condAra56{p}.probe_pic = 'calY_086_0p60c.png';
        end
    end
    condAra = condAra56;
    condAraLabel = 'condAra56';

elseif numConds == 36
    for c = 1:numConds
        switch c
            case {1, 2, 3, 4, 5, 6}        %A cue
                condAra36{c}.cueStr = 'A';
                condAra36{c}.cueID = 0;
                condAra36{c}.cue_pic = 'calA_100_2p50c.png';
            case {7, 12, 13, 14, 15, 16}  %B1 cue
                condAra36{c}.cueStr = 'B1';
                condAra36{c}.cueID = 1;
                condAra36{c}.cue_pic = 'calB_010_1p0c.png';
            case {8, 17, 18, 19, 20, 21}  %B2 cue
                condAra36{c}.cueStr = 'B2';
                condAra36{c}.cueID = 2;
                condAra36{c}.cue_pic = 'calB_020_1p0c.png';
            case {9, 22, 23, 24, 25, 26}  %B3 cue
                condAra36{c}.cueStr = 'B3';
                condAra36{c}.cueID = 3;
                condAra36{c}.cue_pic = 'calB_030_1p0c.png';
            case {10, 27, 28, 29, 30, 31}  %B4 cue
                condAra36{c}.cueStr = 'B4';
                condAra36{c}.cueID = 4;
                condAra36{c}.cue_pic = 'calB_000_1p0c.png';
            case {11, 32, 33, 34, 35, 36}  %B5 cue
                condAra36{c}.cueStr = 'B5';
                condAra36{c}.cueID = 5;
                condAra36{c}.cue_pic = 'calB_330_1p0c.png';
        end
    end

    for p = 1 : numConds
        switch p
            case {1, 7, 8, 9, 10, 11} %X probe
                condAra36{p}.probeStr = 'X';
                condAra36{p}.probeID = 0;
                condAra36{p}.probe_pic = 'calX_055_1p20c.png';
            case {2, 12, 17, 22, 27, 32} %Y1 probe
                condAra36{p}.probeStr = 'Y1';
                condAra36{p}.probeID = 1;
                condAra36{p}.probe_pic = 'calY_024_0p60c.png';
            case {3, 13, 18, 23, 28, 33} %Y2 probe
                condAra36{p}.probeStr = 'Y2';
                condAra36{p}.probeID = 2;
                condAra36{p}.probe_pic = 'calY_032_0p50c.png';
            case {4, 14, 19, 24, 29, 34} %Y3 probe
                condAra36{p}.probeStr = 'Y3';
                condAra36{p}.probeID = 3;
                condAra36{p}.probe_pic = 'calY_040_0p40c.png';
            case {5, 15, 20, 25, 30, 35} %Y4 probe
                condAra36{p}.probeStr = 'Y4';
                condAra36{p}.probeID = 4;
                condAra36{p}.probe_pic = 'calY_070_0p40c.png';
            case {6, 16, 21, 26, 31, 36} %Y5 probe
                condAra36{p}.probeStr = 'Y5';
                condAra36{p}.probeID = 5;
                condAra36{p}.probe_pic = 'calY_078_0p50c.png';

        end
    end
    condAra = condAra36;
    condAraLabel = 'condAra36';
elseif numConds == 24
    for c = 1:numConds
        switch c
            case {1, 2, 3, 4, 5, 6}        %A cue
                condAra24{c}.cueStr = 'A';
                condAra24{c}.cueID = 0;
                condAra24{c}.cue_pic = 'calA_100_2p50c.png';
            case {7, 10, 11, 12, 13, 14}  %B1 cue
                condAra24{c}.cueStr = 'B1';
                condAra24{c}.cueID = 1;
                condAra24{c}.cue_pic = 'calB_010_1p0c.png';
            case {8, 15, 16, 17, 18, 19}  %B2 cue
                condAra24{c}.cueStr = 'B2';
                condAra24{c}.cueID = 2;
                condAra24{c}.cue_pic = 'calB_020_1p0c.png';
            case {9, 20, 21, 22, 23, 24}  %B4 cue
                condAra24{c}.cueStr = 'B4';
                condAra24{c}.cueID = 4;
                condAra24{c}.cue_pic = 'calB_000_1p0c.png';
        end
    end

    for p = 1 : numConds
        switch p
            case {1, 7, 8, 9} %X probe
                condAra24{p}.probeStr = 'X';
                condAra24{p}.probeID = 0;
                condAra24{p}.probe_pic = 'calX_055_1p20c.png';
            case {2, 10, 15, 20} %Y1 probe
                condAra24{p}.probeStr = 'Y1';
                condAra24{p}.probeID = 1;
                condAra24{p}.probe_pic = 'calY_024_0p60c.png';
            case {3, 11, 16, 21} %Y2 probe
                condAra24{p}.probeStr = 'Y2';
                condAra24{p}.probeID = 2;
                condAra24{p}.probe_pic = 'calY_032_0p50c.png';
            case {4, 12, 17, 22} %Y3 probe
                condAra24{p}.probeStr = 'Y3';
                condAra24{p}.probeID = 3;
                condAra24{p}.probe_pic = 'calY_040_0p40c.png';
            case {5, 13, 18, 23} %Y4 probe
                condAra24{p}.probeStr = 'Y4';
                condAra24{p}.probeID = 4;
                condAra24{p}.probe_pic = 'calY_070_0p40c.png';
            case {6, 14, 19, 24} %Y5 probe
                condAra24{p}.probeStr = 'Y5';
                condAra24{p}.probeID = 5;
                condAra24{p}.probe_pic = 'calY_078_0p50c.png';

        end
    end
    condAra = condAra24;
    condAraLabel = 'condAra_equalLR_goodBXonly';
else    % this is our special AX/BX case, because it works super differently
    for c = 1:numConds
        switch c
            case {1}        %A cue
                condAra_goodAXBXonly{c}.cueStr = 'A';
                condAra_goodAXBXonly{c}.cueID = 0;
                condAra_goodAXBXonly{c}.cue_pic = 'calA_100_2p50c.png';
            case {2}  %B1 cue
                condAra_goodAXBXonly{c}.cueStr = 'B1';
                condAra_goodAXBXonly{c}.cueID = 1;
                condAra_goodAXBXonly{c}.cue_pic = 'calB_010_1p0c.png';
            case {3}  %B2 cue
                condAra_goodAXBXonly{c}.cueStr = 'B2';
                condAra_goodAXBXonly{c}.cueID = 2;
                condAra_goodAXBXonly{c}.cue_pic = 'calB_020_1p0c.png';
            case {4}  %B4 cue
                condAra_goodAXBXonly{c}.cueStr = 'B4';
                condAra_goodAXBXonly{c}.cueID = 4;
                condAra_goodAXBXonly{c}.cue_pic = 'calB_000_1p0c.png';
        end
    end

    for p = 1 : numConds
        switch p
            case {1, 2, 3, 4} %X probe
                condAra_goodAXBXonly{p}.probeStr = 'X';
                condAra_goodAXBXonly{p}.probeID = 0;
                condAra_goodAXBXonly{p}.probe_pic = 'calX_055_1p20c.png';
        end
    end
    condAra = condAra_goodAXBXonly;
    condAraLabel = 'condAra_goodAXBXonly';
end

%% -------- BUILD TRIAL STACK AND ADD TO TRIAL RECORD (user vars) --------

% TRIAL STACK is built from the condition array, replicating each condition
% according to the number of trials with that condition in the stack.

% TRIAL STACK structure:
% Percentages: 69 AX, 12.5 AY/BX, 6 BY
% Numbers out of 400: 276 AX, 50 AYs, 50 BXs, 24 BYs
% We have 7 Bs and 6 Ys
% 8 cues and 7 probes all together
% 56 different possible combinations of cues and probes
% Too many BY combinations (42) to present each combination

% Stimuli are already different between NHP and human studies to make them
% easier for NHP  (the Y probes are much lower spatial frequency in NHP so
% they can be distinguished on that basis).  For the humans to do the task
% they have to pay attention to orientation.  NHP less so.
trialAra =[];

for c = 1 : numConds
    theseTrials = [];
    if c == 1
        theseTrials = ones(1, repAra.AXreps);
    elseif ismember(c, AYcondList)
        theseTrials = c * ones(1, repAra.AYreps);
    elseif ismember(c, BXcondList)
        theseTrials = c * ones(1, repAra.BXreps);
    elseif ismember(c, BYcondList)
        theseTrials = c * ones(1, repAra.BYreps);
    end

    trialAra = [trialAra theseTrials];

end

end

