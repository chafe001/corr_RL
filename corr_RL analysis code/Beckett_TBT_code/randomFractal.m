
% fractal stimuli, after Okihide Hikosaka's work:
% 1991: Generation of fractal patterns for probing the visual memory 
% 2012: Yamamoto, Monosov, Yasuda, & Hikosaka
% 2016: Object-finding skill created by repeated reward experience

% properties of the algorithm
n_colors = 5;
range_vertices = [3,6];%,6];
range_radii = [2,18];
range_deflection = [1,3];
range_nLayers = [3,6];%2,10];
colors = pickColors(n_colors);
bg_color = [.2 .2 .2];

figure(); axis square; hold on;
set(gcf,'Position',[440   483   326   315],'Color',bg_color);
set(gca,'color',bg_color,'XTick',[],'YTick',[],...
    'YColor',bg_color,'XColor',bg_color);
set(gca,'Position',[0 0 1 1])

% figure out how many shapes we will plot
nLayers = randi(range_nLayers);
radii = randi(range_radii,nLayers);
radii = sort(radii,'descend'); % big on bottom
radii(1) = max(range_radii);

for layer = 1:nLayers

    % properties of this shape
    n_vertices = randi(range_vertices);
    start_pt = rand(1).*2*pi;
    radius = radii(layer);

    % find where the polygon should be 
    pts = NaN(2,n_vertices);
    for pt = 1:n_vertices
        theta = (2*pi/n_vertices)*pt + start_pt;
        pts(:,pt) = [radius*sin(theta); radius*cos(theta)];
    end
    og_pts = pts;

    % now choose the depth of recursion
    n_deflection = randi(range_deflection);

    for k = 1:n_deflection
        const = rand*radius-1;

        new_pts = NaN(2,size(pts,2)*2+1);
        new_pts(:,1:2:end) = [pts,pts(:,1)];
        for step = 1:2:size(new_pts,2)-2

            % find the midpoint of each edge
            middle = (new_pts(:,step)+new_pts(:,step+2))./2;
            diff = new_pts(:,step+2)-new_pts(:,step);
            theta = atan(diff(2)/diff(1));

            % figure where the point is
            [th,r] = cart2pol(middle(1),middle(2))
            if th > 0
                new_pts(:,step+1) = middle + const.*[sin(theta); -cos(theta)];
            elseif th <= 0
                new_pts(:,step+1) = middle - const.*[sin(theta); -cos(theta)];
            end
        end
        pts = new_pts(:,1:end-1);
    end

    % now we have to deform the polygon
    fill(pts(1,:),pts(2,:),colors(randi(n_colors),:),...
        'LineStyle','none');

end

xlim([-25 25]); ylim([-25 25]);