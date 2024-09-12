
function [] = genCurves_v2()
%%

% Version history

% matlab_line_drawings
% randomly samples knot grid (2D cartesian feature space) to draw
% parametrically controlled curves per Thomas' algorith 

% Dave's code.  Interestingly, Dave had chatGPT translate Python into
% Matlab.  Then checked that it worked. Thomas noticed some potential
% oddities in the algorithm, needs a look over

% genCurves
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


% set params structure.  
params.size_of_knot_grid = 10;
params.low = -1;
params.high = 1;
knot_grid = make_knot_grid(params.size_of_knot_grid, params.low, params.high);
params.max_knot_number = 10;
params.D = 256; % resolution_of_curves
params.K = 2; % number of axes in curve space that we will sample
params.S = 1; % number of "exposures" to generate
params.N = 12; % number of samples per exposure
params.save_png = true;
params.plotCurveSeq = true;
params.n_knot_points = 5;
% params.n_knot_points = 2;

params.nBlocks = 10;
params.curvesPerBlock = 2;

% Specify the "curve of origin"
curve_of_origin = zeros(params.D, 2);

% Circle
rng = (0:params.D-1)' / params.D * 2 * pi;
curve_of_origin(:, 1) = sin(rng);
curve_of_origin(:, 2) = cos(rng);
radius = 0.1 * (params.high - params.low);
curve_of_origin = curve_of_origin * radius;
% oXY = xy2stacked(curve_of_origin);

for b = 1:params.nBlocks

    for c = 1:params.curvesPerBlock

        % --- curves for A state
        % endcurve
        knots = sample_knots(knot_grid, params.n_knot_points, false);
        [endcurve, ~] = upsample(knots, params.D);

        % orthocurve
        el = sum(sum(endcurve .* endcurve));
        knots = sample_knots(knot_grid, params.n_knot_points, false);
        [other_curve, ~] = upsample(knots, params.D);
        orthocurve = sum(sum(other_curve .* endcurve)) * endcurve / el - other_curve;
        fprintf('check: %.2f\n', sum(sum(orthocurve .* endcurve))); % ??

        % Generate one sequence and look at it
        scale_lim = 1;

        % Travel smoothly along manifold, sample a curve at each point
        smooth_sequence = zeros(params.N, params.D, 2);
        for i = 1:params.N
            t = interp1([1, params.N], [-scale_lim, scale_lim], i);
            smooth_sequence(i, :, :) = curve_of_origin + t * endcurve;
        end

        % Random samples of curves along an orthogonal manifold: this is the "noise"
        rough_sequence = zeros(params.N, params.D, 2);
        for n = 1:params.N
            t = max(min(randn, scale_lim), -scale_lim);
            rough_sequence(n, :, :) = curve_of_origin + t * orthocurve;
        end

     

        %%
        % Plotting
        figure;
        plot(endcurve(:, 1), endcurve(:, 2));
        hold on;
        plot(orthocurve(:, 1), orthocurve(:, 2), 'r');

        %%

        if params.plotCurveSeq
            % lim = 1.75;
            lim = 1.5;
            limx = [-lim, lim];
            limy = [-lim, lim];

            figure;
            for i = 1:3
                for n = 1:params.N
                    subplot(3, params.N, (i-1)*params.N + n);
                    if i == 1
                        plot(smooth_sequence(n, :, 1), smooth_sequence(n, :, 2));
                    elseif i == 2
                        plot(rough_sequence(n, :, 1), rough_sequence(n, :, 2));
                    else
                        plot((rough_sequence(n, :, 1) + smooth_sequence(n, :, 1))/2, ...
                            (rough_sequence(n, :, 2) + smooth_sequence(n, :, 2))/2);
                    end
                    xlim(limx);
                    ylim(limy);
                    axis off;
                    axis equal;
                end
            end

        end

        %%
        if params.save_png

            for i = 1:3
                for n = 1:params.N
                    % subplot(3, params.N, (i-1)*params.N + n);
                    if i == 1
                        f = figure;
                        plot(smooth_sequence(n, :, 1), smooth_sequence(n, :, 2));
                    elseif i == 2
                        f = figure;
                        plot(rough_sequence(n, :, 1), rough_sequence(n, :, 2));
                    else
                        f = figure;
                        plot((rough_sequence(n, :, 1) + smooth_sequence(n, :, 1))/2, ...
                            (rough_sequence(n, :, 2) + smooth_sequence(n, :, 2))/2);
                    end
                    xlim(limx);
                    ylim(limy);
                    axis off;
                    axis equal;

                    % --- SAVE PNG
                    state = 'A';
                    fn = buildFilename(params, i, n, b, c);
                    cd blockstim
                    % f is figure object, if not included in print command, prints
                    % last ML screen changed, eg user, as png file
                    print(f, fn, '-dpng');
                    close;
                    cd ..

                end
            end

        end % save_png

    end % curvesPerBlock

end  % nBlocks





%%
% Utilities for generating curves

    function fn = buildFilename(params, i, n, b, c)

        blockstr = strcat ('b', num2str(b), '_');
        curvestr = strcat ('c', num2str(c), '_');

        switch i

            case 1
                typeStr = 'smooth_';

            case 2
                typeStr = 'rough_';

            case 3
                typeStr = 'comb_';

        end

        sampStr = strcat('s', num2str(n));

        fn = strcat(typeStr, blockstr, curvestr, sampStr);

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

end
