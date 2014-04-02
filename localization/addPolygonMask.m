function objectMask = addPolygonMask(context, objectMask)
    global height; global width;
    global U; global V;

    %Set up GUI
    f = figure();
    imgHandle = imshow(zeros(height,width,3,'uint8'));

    [rgb,~] = getKinectData(context);
    displayKinectRGB(rgb,imgHandle); 

    disp('Select mask polygon vertices. Press Enter when done.');  
    [u_vertices,v_vertices] = ginput;
    
    objectMask = objectMask | repmat(inpolygon(U,V,u_vertices,v_vertices), [1,1,3]);
    
    close(f);
end