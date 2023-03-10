% Recursive De Casteljau algorithm  
%
% INPUT  - control_points - control points 
%        - t - spline control variable
% OUTPUT - spline_point - points on the spline
function [spline_point] = de_casteljaus(control_points, t)
    [rows, columns] = size(control_points);
    if rows == 2
        spline_point = (1-t)*control_points(1,:) + t*control_points(2,:);
        return
    end
    
    new_control_points = zeros(length(control_points)-1, 3);
    for i=1:length(control_points)-1
        new_control_points(i,:) = (1-t)*control_points(i,:) + t*control_points(i+1,:);
    end
    
    spline_point = de_casteljaus(new_control_points, t);
end