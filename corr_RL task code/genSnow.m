
% function [] = genSnow()

NROWS = 6;
NCOLS = 6;
corr = 0.3;

if (corr > 0.5)
    error('cannot have more than half of squares stay the same (c must <= 0.5)');
end

grid = randi(2, NCOLS, NROWS)-1;

figure(1); hold on;
subplot(2, 3, 1);
imagesc(grid)
colormap('gray'); axis off; axis equal;

% Option A
randorder = randperm(numel(grid));
ncorrsquares = round(numel(grid)*corr);

unchanged_squares1 = randorder(1:ncorrsquares);
leftoversquares = randorder(ncorrsquares+1:end);

grid2 = grid;
grid2(leftoversquares) = randi(2, 1, numel(leftoversquares))-1;

figure(1);
subplot(2, 3, 2);
imagesc(grid2)
colormap('gray'); axis off; axis equal;

grid3 = grid;
grid3(leftoversquares) = randi(2, 1, numel(leftoversquares))-1;

figure (1);
subplot(2, 3, 3);
imagesc(grid3)
colormap('gray'); axis off; axis equal;

% Option B
unchanged_squares2 = leftoversquares(1:ncorrsquares);
leftoversquares2 = setdiff(randorder, unchanged_squares2);
grid4 = grid;
grid4(leftoversquares2) = randi(2, 1, numel(leftoversquares2))-1;

figure(1); % plot original again
subplot(2, 3, 4);
imagesc(grid)
colormap('gray'); axis off; axis equal;

figure(1);
subplot(2, 3, 5);
imagesc(grid4)
colormap('gray'); axis off; axis equal;

grid5 = grid;
grid5(leftoversquares) = randi(2, 1, numel(leftoversquares))-1;

figure(1);
subplot(2, 3, 6);
imagesc(grid5)
colormap('gray'); axis off; axis equal;

% plot again, witch changed in gray
grid2(leftoversquares) = 0.5;
grid3(leftoversquares) = 0.5;
grid4(leftoversquares2) = 0.5;
grid5(leftoversquares2) = 0.5;

figure(2);
subplot(2, 3, 1);
imagesc(grid)
colormap('gray'); axis off; axis equal;
subplot(2, 3, 4);
imagesc(grid)
colormap('gray'); axis off; axis equal;
subplot(2, 3, 2);
imagesc(grid2)
colormap('gray'); axis off; axis equal;
subplot(2, 3, 3);
imagesc(grid3)
colormap('gray'); axis off; axis equal;
subplot(2, 3, 5);
imagesc(grid4)
colormap('gray'); axis off; axis equal;
subplot(2, 3, 6);
imagesc(grid5)
colormap('gray'); axis off; axis equal;


