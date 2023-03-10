% Generates the control points of a given segment taking into account the
% geometry of the previous segment, if there are intermediate point and the
% geometry of the next segment
%
% INPUT  - start_point - start point of the segment
%        - start_vector - previous geometry of the segment
%        - intermediat_points - points between the start and end point
%        - end_vector - geometry of the next segment
%        - end_point - end point of the segment
% OUTPUT - points - sontrol points of the segment
function [points] = generate_control_points(start_point, start_vector, intermediat_points, end_vector, end_point)
    points = start_point; 
    
    start_end_v = end_point - start_point;
    start_end_v = start_end_v/norm(start_end_v);
    
    distance = norm(end_point - start_point)/2;
    
    % Control point of the start point depending on the previous segment
    % geometry
    start_vector = start_vector/norm(start_vector);
    if length(start_vector) == 3
        points = [points; start_point + distance*start_vector];
    else
        points = [points; start_point + distance*start_end_v];
    end
    
    % Control point that are paralel with the segment between the start and
    % end vector
    [inter_row, inter_column] = size(intermediat_points);
    if inter_row > 1
        for i=1:inter_row
            points = [points; intermediat_points(i,:) + distance*start_end_v];
            points = [points; intermediat_points(i,:)];
            points = [points; intermediat_points(i,:) - distance*start_end_v];
        end
    end
    
    % Control point of the end point depending on the next segment geometry
    end_vector = end_vector/norm(end_vector);
    if length(end_vector) == 3
        points = [points; end_point - distance*end_vector];
    else
        points = [points; end_point - distance*start_end_v];
    end
    
    points = [points; end_point]; 
end
