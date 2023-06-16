clc
clear

% Dimenstions of the links
dimensions = [ 0.9 1.3 2.5 1.25 1.25 1];

% Color of the poses
color = [0 0.4470 0.7410;
            0.8500 0.3250 0.0980;
            0.9290 0.6940 0.1250;
            0.4940 0.1840 0.5560;
            0.4660 0.6740 0.1880;
            0.3010 0.7450 0.9330;];

% Path through which the path to go through
path_points = [3 0.4827 4.7999 0 -1.5708 0;
               -0.5 -3 5.7999 -1.5708 0 1.5708;
               -3.2 1 3.7999 0 1.7708 0;
               0.2 3.2 5.7999 1.5708 0 -1.5708];

% Generate the spline
spline_points = generate_spline(path_points(:,1:3));

index = 1;

[r, c] = size(path_points);

% Plotting the obtained spline 
figure('NumberTitle', 'off', 'Name', 'Trajectory preview');
for l=1:r-1
    t = 0;
    start_q = eul2quat([path_points(l,6) path_points(l,5) path_points(l,4)]);
    end_q = eul2quat([path_points(l+1,6) path_points(l+1,5) path_points(l+1,4)]);

    qs = quaternion(start_q);
    qe = quaternion(end_q);
    
    while (t <= 1)
        q = slerp(qs,qe,t);
        [m, i, j, k] = parts(q);
        tcp_rotation = quat_2_eul([i, j, k, m]);

        tcp = [spline_points(index,1) spline_points(index,2) spline_points(index,3) tcp_rotation(1) tcp_rotation(2) tcp_rotation(3)];

        rotations = ik(dimensions, tcp);

        hold on
        plot3(spline_points(index,1), spline_points(index,2), spline_points(index,3),"k*");
        plot_points(pose_points(dimensions, rotations),color);
        hold off

        t = t + 0.1;
        index = index + 1;
    end
end