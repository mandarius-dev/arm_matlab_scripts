% Generates points on the spline that passes through CERTAIN points 
%
% INPUT  - path_points - points through which the splien to pass through
% OUTPUT - points - points on the spline
function [points] = generate_path_length(path_points)
    [no_points, c] = size(path_points);
    
    out_geometry = 0;
    in_geometry = 0;
    points = [];
    
    for i=1:no_points-2
        in_geometry = (path_points(i+2,:)-path_points(i+1,:))/norm(path_points(i+2,:)-path_points(i+1,:));
        control_points = generate_control_points(path_points(i,:), out_geometry, 0, in_geometry, path_points(i+1, :));
        out_geometry = in_geometry;

        points = [points; generate_spline_points(control_points)];
    end
    
end