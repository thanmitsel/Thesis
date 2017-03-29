%% ===  KMeans & PCA ===
%  One useful application of PCA is to use it to visualize high-dimensional
%  data. In the last K-Means exercise you ran K-Means on 3-dimensional 
%  pixel colors of an image. We first visualize this output in 3D, and then
%  apply PCA to obtain a visualization in 2D.

% If 3D unroll
if (size(H,3)>1)
    [X, Y]=unrollto2D(X,Y2D);
end
K = 3;
max_iters = 10;
initial_centroids = kMeansInitCentroids(X, K);
[centroids, idx] = runkMeans(X, initial_centroids, max_iters);

%  Sample 1000 random indexes (since working with all the data is
%  too expensive. If you have a fast computer, you may increase this.
sel = floor(rand(1000, 1) * size(X, 1)) + 1;

%  Setup Color Palette
palette = hsv(K);
colors = palette(idx(sel), :);

%  Visualize the data and centroid memberships in 3D
%figure;
%scatter3(X(sel, 1), X(sel, 2), X(sel, 3), 10, colors);
%title('Pixel dataset plotted in 3D. Color shows centroid memberships');
%fprintf('Program paused. Press enter to continue.\n');
%pause;

%% ===  PCA for Visualization ===
% Use PCA to project this cloud to 2D for visualization

% Subtract the mean to use PCA
[X_norm, mu, sigma] = normalizeMinus_Plus(X);

% PCA and project the data to 2D
[U, S] = pca(X_norm);
Z = projectData(X_norm, U, 2);

% Plot in 2D
figure;
plotDataPoints(Z(sel, :), idx(sel), K);
title('2D plot of features, using PCA for dimensionality reduction');
fprintf('Program paused. Press enter to continue.\n');
pause;
