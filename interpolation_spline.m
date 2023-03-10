clc
clear

% Dimenstions of the links
dimensions = [ 0.9 1.3 2.5 1.25 1.25 1];

% Path through which the path to go through
path_points = [0.4827 -5 4.0999;
               0.4827 -4 4.0999;
               1.4827 -4 4.0999;
               1.4827 -5 4.0999];

% Generate the spline
spline_points = generate_spline(path_points);

% Plotting the obtained spline    
figure
plot3(spline_points(:,1), spline_points(:,2), spline_points(:,3),'k*'); 
title('Pose');
axis([-8 8 -8 8 0 8]);
view(3);
grid;
       
            