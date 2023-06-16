% Using the control points the point on the spline are generated using the 
% De Casteljau algorithm 
%
% INPUT  - control_points - control points 
% OUTPUT - points - points on the spline
function [points] = generate_spline_points(control_points)
    t = 0;
    points = [];
    while t <= 1.01
        spline_point = de_casteljaus(control_points, t);
        points = [points; spline_point];

        t = t + 0.1;
    end
end
