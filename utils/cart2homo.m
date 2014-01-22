function homogeneous = cart2homo(cartesian)
% Converts cartesian to homogeneous coordinates
% Coordinates must be column vectors

    homogeneous = [cartesian; ones(1,size(cartesian,2))];
end