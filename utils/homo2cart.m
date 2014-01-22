function cartesian = homo2cart(homogeneous)
% Converts homogeneous coordinates to cartesian
% Assumes coordinates are column vectors

    scale = repmat( homogeneous(end,:), [size(homogeneous,1)-1, 1] );
    cartesian = homogeneous(1:end-1,:) ./ scale;
end