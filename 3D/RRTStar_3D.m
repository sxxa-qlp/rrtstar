clearvars
close all
x_max = 640;
y_max = 480;
z_max = 400;

EPS = 20;
numNodes = 2000;        

q_init.coord = [0 0 0];
q_init.cost = 0;
q_goal.coord = [640 400 180];
q_goal.cost = 0;
q_init.parent = 0;

nodes(1) = q_init;
node_count = 2;
figure(1)
for i = 1:1:numNodes
    q_rand = [rand(1)*x_max rand(1)*y_max rand(1)*z_max];
    plot3(q_rand(1), q_rand(2), q_rand(3), 'x', 'Color',  [0 0.4470 0.7410])
    for j = 1:1:length(nodes)
        if nodes(j).coord == q_goal.coord
            break
        end
    end
    ndist = [];
    for j = 1:1:length(nodes)
        n = nodes(j);
        tmp = sqrt((n.coord(1)-q_rand(1))^2 + (n.coord(2)-q_rand(2))^2 + (n.coord(3)-q_rand(3))^2);
        ndist = [ndist tmp];
    end
    [val, idx] = min(ndist);
    q_near = nodes(idx);
    
    q_new.coord = steer3d(q_rand, q_near.coord, val, EPS);
    line([q_near.coord(1), q_new.coord(1)], [q_near.coord(2), q_new.coord(2)], [q_near.coord(3), q_new.coord(3)], 'Color', 'k', 'LineWidth', 2);
    drawnow
    hold on
    q_new.cost = dist_3d(q_new.coord, q_near.coord) + q_near.cost;
    
    q_nearest = [];
    r = 50;
    neighbor_count = 1;
    for j = 1:1:length(nodes)
        if (dist_3d(nodes(j).coord, q_new.coord) - r) <= 0
            q_nearest(neighbor_count).coord = nodes(j).coord;
            q_nearest(neighbor_count).cost = nodes(j).cost;
            neighbor_count = neighbor_count+1;
        end
    end
    q_min = q_near;
    C_min = q_new.cost;
    
    for k = 1:1:length(q_nearest)
        if q_nearest(k).cost + dist_3d(q_nearest(k).coord, q_new.coord) < C_min
            q_min = q_nearest(k);
            C_min = q_nearest(k).cost + dist_3d(q_nearest(k).coord, q_new.coord);
            line([q_min.coord(1), q_new.coord(1)], [q_min.coord(2), q_new.coord(2)], [q_min.coord(3), q_new.coord(3)], 'Color', 'g');            
            hold on
        end
    end
    for j = 1:1:length(nodes)
        if nodes(j).coord == q_min.coord
            q_new.parent = j;
        end
    end
    nodes = [nodes q_new];
end

D = [];
for j = 1:1:length(nodes)
    tmpdist = dist_3d(nodes(j).coord, q_goal.coord);
    D = [D tmpdist];
end

[val, idx] = min(D);
q_final = nodes(idx);
q_goal.parent = idx;
q_end = q_goal;
nodes = [nodes q_goal];
while q_end.parent ~= 0
    start = q_end.parent;
    line([q_end.coord(1), nodes(start).coord(1)], [q_end.coord(2), nodes(start).coord(2)], [q_end.coord(3), nodes(start).coord(3)], 'Color', 'r', 'LineWidth', 4);
    hold on
    q_end = nodes(start);
end


