
function [] = genCurves_v3()
%%

% Version history

% matlab_line_drawings
% randomly samples knot grid (2D cartesian feature space) to draw
% parametrically controlled curves per Thomas' algorith

% Dave's code.  Interestingly, Dave had chatGPT translate Python into
% Matlab.  Then checked that it worked. Thomas noticed some potential
% oddities in the algorithm, needs a look over

% gendcurves
% converting to function to generate sets of curves for each block.
% Alternating curve complexity (smooth, rough) over blocks, and outputting
% png files to be loaded by MovieGraphic in monkeyLoogic. corr_RL v3
% modified to work with these images.

% Algorithm walk-through:
% 1. define a curve_of_origin (circle)
% 2. call sample_knots(), picks random set of xy positions from knot grid
% 3. call upsample() to define 'endcurve' by computing spline between the random knots
% 4. repeat steps 2 and 3 to generate a second curve
% 5. invoke secrete mathematical incantations to make the second curve
% orthogonal to the first, 'orthocurve'
% 7. Sample curves along a 'manifold' (line through the feature space).
% Method for sampling manifold:
% a. Generate a vector of scaling values (t) from -1 to +1
% b. Loop through 't', each iter multiply endcurve by t (scale endcurve)
% c. Add scaled endcurve to curve_of_origin
% d. This produces a smooth_sequence of 'samples' along the manifold
% e. Add this sequence to an image stack to make a movie
% e. To examine effect of correlation on learning, generate rough_sequence
% f. Create random vector of scaling values 't'
% g. Multiple random t's by orthocurve to sample noise manifold
% h. Collect these into image stack, produces a jumpy movie

% Embedding curves in task context:
% 1. Generate two curves for each block
% 2. Associate one curve with L key, the other with R key
% 3. Subjects learn to map curves to keys
% 4. Vary curve complexity over blocks by alternately showing
% smooth_sequence and rough_sequence movies.

% This first version of the task is trivial, almost no learning.
% Perceptual system immediately discriminates curves (visually distinct)
% and with very little trial and error learns to map curves to keys

% genCurves_v2:
% Next steps, after speaking with Thomas
% 1. Associate L and R keys (states) with opposite halves of the continuum
% of curves along a single manifold.
% 2. Never show the same curve twice, need to learn the manifold rather
% than any individual visual pattern.
% 3. Do this by discretizing manifold segments on each side of the middle
% point (decision boundary), and build a movie only out of that segment
% 4. This is all single manifold
% 5. Use ortho manifold to dissociate reward state from feature correlation
% 6. Do this by adding in varying amounts of ortho curve.
% 7. Use quantity of orthocurve added in to modulate the degree of noise
% (if ortho component is unrelated to response/reward), or to dissociate
% feature correlation (endcurve) from RPE (orthocurve).  That is, determine
% response (L/R key) and reward probability based on sign and magnitude of
% orthocurve addition

% genCurves_v3: 
% modified to vary balance between tvals scaling main (signal) and
% ortho (noise) manifolds at the block level.


% set curveParams structure

curveParams.nBlocks = 10;
curveParams.nStates = 2;

curveParams.n_tvals_main = 12;
curveParams.n_tvals_ortho = 12;

curveParams.size_of_knot_grid = 10;
curveParams.low = -1;
curveParams.high = 1;
knot_grid = make_knot_grid(curveParams.size_of_knot_grid, curveParams.low, curveParams.high);
curveParams.max_knot_number = 10;
curveParams.D = 256; % resolution_of_curves
curveParams.K = 2; % number of axes in curve space that we will sample
% curveParams.S = 1; % number of "exposures" to generate - not used presently
curveParams.save_png = true;
curveParams.plotCurveSeq = true;

curveParams.n_knot_points = 5;
% curveParams.n_knot_points = 2;

% Specify the "curve of origin"
curve_of_origin = zeros(curveParams.D, 2);

% Circle
rng = (0:curveParams.D-1)' / curveParams.D * 2 * pi;
curve_of_origin(:, 1) = sin(rng);
curve_of_origin(:, 2) = cos(rng);
radius = 0.1 * (curveParams.high - curveParams.low);
curve_of_origin = curve_of_origin * radius;
% oXY = xy2stacked(curve_of_origin);

% --- t val ranges to control mixtures of signal (main) and noise (ortho)
% manifolds 
cuveParams.t_limit_large = 1;
cuveParams.t_limit_small = 0.50;
cuveParams.t_limit_offset = 0.5;

for b = 1:curveParams.nBlocks

    % --- BLOCK LEVEL operations
    % compute endcurve (signal) and orthocurve (noise or reward) for this block

    % define random endcurve
    knots = sample_knots(knot_grid, curveParams.n_knot_points, false);
    [endcurve, ~] = upsample(knots, curveParams.D);

    % define random orthocurve
    el = sum(sum(endcurve .* endcurve));
    knots = sample_knots(knot_grid, curveParams.n_knot_points, false);
    [other_curve, ~] = upsample(knots, curveParams.D);
    orthocurve = sum(sum(other_curve .* endcurve)) * endcurve / el - other_curve;
    fprintf('check: %.2f\n', sum(sum(orthocurve .* endcurve)));

    % plot endcurve and orthocurve
    f = figure;
    plot(endcurve(:, 1), endcurve(:, 2));
    hold on;
    plot(orthocurve(:, 1), orthocurve(:, 2), 'r');

    if curveParams.save_png
        cd blockstim
        fn = strcat('b', num2str(b), '_endCurve(blue)_orthoCurve(red).png');
        print(f, fn, '-dpng');
        cd ..
    end

    % --- SET BLOCK LEVEL VARIABLES that modify curve movies

    if mod(b, 2) ~= 0  % odd block num

        state1_main_lowerT = -cuveParams.t_limit_large;
        state1_main_upperT = 0;
        state1_ortho_lowerT = -cuveParams.t_limit_small;
        state1_ortho_upperT = cuveParams.t_limit_small;

        state2_main_lowerT = 0;
        state2_main_upperT = cuveParams.t_limit_large;
        state2_ortho_lowerT = -cuveParams.t_limit_small;
        state2_ortho_upperT = cuveParams.t_limit_small;

        snrLevel = 'high';


    else % even block num

        state1_main_lowerT = -cuveParams.t_limit_small;
        state1_main_upperT = 0;
        state1_ortho_lowerT = -cuveParams.t_limit_large;
        state1_ortho_upperT = cuveParams.t_limit_large;

        state2_main_lowerT = 0;
        state2_main_upperT = cuveParams.t_limit_small;
        state2_ortho_lowerT = -cuveParams.t_limit_large;
        state2_ortho_upperT = cuveParams.t_limit_large;

        snrLevel = 'low';

    end


    for s = 1:curveParams.nStates  % 2 states per block (L/R response)

        % --- STATE LEVEL operations
        % discretize scaling variable, t, to generate unique, nonoverlapping
        % curve movies for this state corresponding to curve samples in windows
        % along manifold

        % set limits on t for this state. States 1 and 2 correspond to first
        % and second halves of manifold for now
        switch s
            case 1
                main_lowerT = state1_main_lowerT;
                main_upperT = state1_main_upperT;
                ortho_lowerT = state1_ortho_lowerT;
                ortho_upperT = state1_ortho_upperT;
            case 2
                main_lowerT = state2_main_lowerT;
                main_upperT = state2_main_upperT;
                ortho_lowerT = state2_ortho_lowerT;
                ortho_upperT = state2_ortho_upperT;
        end

        % --- set range of t values specifying weights with which endcurve
        % and orthocurve are summed to produce individual curves
        curveParams.endcurve_t = interp1([1, curveParams.n_tvals_main], [main_lowerT, main_upperT], 1:curveParams.n_tvals_main);
        curveParams.orthocurve_t = interp1([1, curveParams.n_tvals_ortho], [ortho_lowerT, ortho_upperT], 1:curveParams.n_tvals_ortho);

        % build a 2D matrix of curves defined by endcurve and orthocurve t
        % values
        for ec = 1 : length(curveParams.endcurve_t)
            for oc = 1 : length(curveParams.orthocurve_t)
                state_curves(ec, oc, :, :) = curve_of_origin + (curveParams.endcurve_t(ec) * endcurve) + (curveParams.orthocurve_t(oc) * orthocurve);
            end
        end

        if curveParams.plotCurveSeq
            lim = 1.5;
            limx = [-lim, lim];
            limy = [-lim, lim];

            f = figure;

            for ec = 1: length(curveParams.endcurve_t)
                for oc = 1: length(curveParams.orthocurve_t)
                    subplot(length(curveParams.orthocurve_t), length(curveParams.endcurve_t), (ec-1)*length(curveParams.orthocurve_t)+oc);
                    x = state_curves(ec,oc,:,1);
                    x = squeeze(x);
                    y = state_curves(ec,oc,:,2);
                    y = squeeze(y);
                    plot(x,y);
                    xlim(limx);
                    ylim(limy);
                    axis off;
                    axis equal;

                end
            end

            if curveParams.save_png
                cd blockstim
                fn = strcat('b', num2str(b), '_s', num2str(s), '_main(x-axis)_ortho(y-axis)_curveSeq.png');
                print(f, fn, '-dpng');
                cd ..
            end

        end


        if curveParams.save_png

            for ec = 1: length(curveParams.endcurve_t)
                for oc = 1: length(curveParams.orthocurve_t)
                    f = figure;
                    x = state_curves(ec,oc,:,1);
                    x = squeeze(x);
                    y = state_curves(ec,oc,:,2);
                    y = squeeze(y);
                    plot(x,y);
                    xlim(limx);
                    ylim(limy);
                    axis off;
                    axis equal;
                    %--- SAVE PNG
                    cd blockstim
                    fn = buildFilename(curveParams, b, s, ec, oc, snrLevel);
                    % f is figure object, if not included in print command, prints
                    % last ML screen changed, eg user, as png file
                    print(f, fn, '-dpng');
                    close;
                    % changedir back to working directory
                    cd ..
                end
            end

        end

    end  % nStates
end  % nBlocks


% --- SAVE PARAMS FILE FOR ML TO READ IN

cd blockstim
save('curveParams.mat', "curveParams");

cd ..




end




%%
% Utilities for generating curves

function fn = buildFilename(curveParams, b, s, ec, oc, snrLevel);

blockstr = strcat('_b', num2str(b), '_');
statestr = strcat('s', num2str(s), '_');
mainstr = strcat('ec_', num2str(ec), '_');
orthostr = strcat('oc_', num2str(oc), '.png');
snrStr = strcat('snr_', snrLevel);

fn = strcat(snrStr, blockstr, statestr, mainstr, orthostr);

bob = 1;


end


% function stacked = xy2stacked(xy)
%     n = size(xy, 1);
%     stacked = reshape(xy', [n*2, 1]);
% end

function xy = stacked2xy(stacked)
assert(mod(length(stacked), 2) == 0);
n = length(stacked) / 2;
xy = reshape(stacked, [2, n])';
end

function segmented = stacked2segmented(curve)
n_points = length(curve) / 2;
assert(mod(n_points, 1) == 0);
x1_idx = 1:n_points-1;
x2_idx = 2:n_points;
y1_idx = x1_idx + n_points;
y2_idx = x2_idx + n_points;
segmented = [curve(x1_idx), curve(x2_idx), curve(y1_idx), curve(y2_idx)];
end

function probes_nxy = linear_probe_set(lim, num, center, dash)
if nargin < 3
    center = [0, 0];
end
if nargin < 4
    dash = false;
end

cnt = 1;
base_probes = 6 * num;
if dash
    num_probes = base_probes * (1 + dash);
else
    num_probes = base_probes;
end
probes_nxy = zeros(num_probes, 2, 2);
fprintf('making %d probes\n', num_probes);
eps = 0.01; % avoid corners

% Vertical probes
for x = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [x, lim; x, -lim];
    cnt = cnt + 1;
end

% Horizontal probes
for y = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [lim, y; -lim, y];
    cnt = cnt + 1;
end

% Negative oblique
for y = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [-lim, y; y, -lim];
    cnt = cnt + 1;
end
for x = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [x, lim; lim, x];
    cnt = cnt + 1;
end

% Positive oblique
for y = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [lim, y; -y, -lim];
    cnt = cnt + 1;
end
for x = linspace(-lim+eps, lim-eps, num)
    probes_nxy(cnt, :, :) = [x, lim; -lim, -x];
    cnt = cnt + 1;
end

if dash
    inc = 1 / dash;
    for i = 1:base_probes
        xp = polyfit([0, 1], probes_nxy(i, :, 1)', 1);
        yp = polyfit([0, 1], probes_nxy(i, :, 2)', 1);
        stop = 0;
        for j = 1:dash
            start = stop;
            stop = start + inc;
            probes_nxy(cnt, :, 1) = polyval(xp, [start, stop]);
            probes_nxy(cnt, :, 2) = polyval(yp, [start, stop]);
            cnt = cnt + 1;
        end
    end
end

probes_nxy = probes_nxy + repmat(reshape(center, [1, 1, 2]), [size(probes_nxy, 1), 2, 1]);
end

function grid = make_knot_grid(size, low, high)
[X, Y] = meshgrid(linspace(low, high, size));
grid = [X(:), Y(:)];
end

function knots = sample_knots(knot_grid, number_of_knot_points, closed)
if nargin < 3
    closed = true;
end

grid_size = size(knot_grid, 1);
if nargin < 2 || isempty(number_of_knot_points)
    nkp = grid_size;
else
    nkp = number_of_knot_points;
end

dice = randsample(grid_size, nkp, nkp > grid_size);
if closed
    dice(end) = dice(1);
end
knots = knot_grid(dice, :);
end

function [xy, knots] = upsample(knots, resolution, kind)
if nargin < 3
    kind = 'spline';
end

num_knots = size(knots, 1);

if num_knots < 3
    kind = 'linear';
end

plot_range = linspace(0, num_knots-1, resolution);

if strcmp(kind, 'linear')
    fx = interp1(0:num_knots-1, knots(:,1), plot_range, 'linear');
    fy = interp1(0:num_knots-1, knots(:,2), plot_range, 'linear');
else
    fx = interp1(0:num_knots-1, knots(:,1), plot_range, 'spline');
    fy = interp1(0:num_knots-1, knots(:,2), plot_range, 'spline');
end

xy = [fx', fy'];
end


